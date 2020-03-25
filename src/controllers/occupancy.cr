require "./application"

module PlaceOS::Analytics
  class Occupancy < Application
    base "/"

    get "/organisation/:id/occupancy" do
      org_id = params["id"]
      start  = Time::Format::RFC_3339.parse params["start"]
      stop   = Time::Format::RFC_3339.parse params["stop"]
      every  = params["every"]?

      if every
        locations = Occupancy.series start, stop, every, filters: [
          "(r) => r.org == \"#{org_id}\""
        ]
        render json: locations
      else
        locations = Occupancy.aggregate start, stop, filters: [
          "(r) => r.org == \"#{org_id}\""
        ]
        render json: locations.values.sum / locations.size.to_f
      end
    end

    # Calculates an aggregate occupancy for each location allowed by the filters
    # across the given time range.
    def self.aggregate(start : Time, stop : Time, filters = [] of String)
      query = <<-FLUX
        // Events of interest, grouped by location
        events = from(bucket: "#{App::INFLUX_BUCKET}")
          |> range(start: #{start.to_rfc3339}, stop: #{stop.to_rfc3339})
          |> filter(fn: (r) => r._measurement == "presence")
          #{ filters.join { |pred| "|> filter(fn: #{pred})" } }
          |> pivot(rowKey: ["_time", "lvl", "src"], columnKey: ["_field"], valueColumn: "_value")
          |> group(columns: ["loc", "lvl", "bld", "org"])

        // Setup a second set of events directly preceeding these that we can
        // use to fill with previous value.
        shifted = events
          |> timeShift(duration: -1ns)
          |> drop(columns: ["val"])

        // Proportion of time window each location was occupied for.
        locations = union(tables: [events, shifted])
          |> sort(columns: ["_time"])
          |> fill(column: "val", usePrevious: true)
          |> integral(unit: 1s, column: "val")
          |> map(fn: (r) => ({r with val: r.val / #{(stop - start).total_seconds}}))

        locations
          |> group()
          |> yield(name: "location-occupancy")
        FLUX

      response = Flux.query query do |row|
        {row["loc"], row["val"].to_f}
      end

      response.first.to_h
    end

    # Calculate a regular time series of occupancy levels with aggregations at
    # the specified interval.
    # TODO: implement stricter type for interval
    def self.series(start : Time, stop : Time,  interval : String, filters = [] of String)
      # FIXME: this will provide incorrect values when the source data is not a
      # regular series.
      query = <<-FLUX
        from(bucket: "#{App::INFLUX_BUCKET}")
          |> range(start: #{start.to_rfc3339}, stop: #{stop.to_rfc3339})
          |> filter(fn: (r) => r._measurement == "presence")
          #{ filters.join { |pred| "|> filter(fn: #{pred})" } }
          |> pivot(rowKey: ["_time", "lvl", "src"], columnKey: ["_field"], valueColumn: "_value")
          |> group(columns: ["loc", "lvl", "bld", "org"])
          |> aggregateWindow(fn: mean, every: #{interval}, column: "val", createEmpty: true)
          |> yield(name: "location-occupancy-series")
        FLUX

      results = {} of String => Array(Float64?)

      # FIXME: implement Flux.stream for a query that yields rows / tables as it
      # goes.
      Flux.query query do |row|
        loc = row["loc"]
        val = row["val"].to_f unless row["val"].empty?
        results[loc] ||= [] of Float64?
        results[loc] << val
        nil
      end

      results
    end
  end
end