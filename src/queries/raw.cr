module PlaceOS::Analytics::Query
  module Raw
    extend self

    def first_event_time(start : Time, stop : Time, filters = [] of String)
      query = <<-FLUX
        from(bucket: "#{App::INFLUX_BUCKET}")
          |> range(start: #{start.to_rfc3339}, stop: #{stop.to_rfc3339})
          |> filter(fn: (r) => r["_field"] == "loc")
          #{filters.join { |pred| "|> filter(fn: #{pred})" }}
          |> first()
        FLUX

      response = Flux.query query do |row|
        Time::Format::RFC_3339.parse row["_time"]
      end

      response.first.first unless response.empty?
    end

    def last_event_time(start : Time, stop : Time, filters = [] of String)
      query = <<-FLUX
        from(bucket: "#{App::INFLUX_BUCKET}")
          |> range(start: #{start.to_rfc3339}, stop: #{stop.to_rfc3339})
          |> filter(fn: (r) => r["_field"] == "loc")
          #{filters.join { |pred| "|> filter(fn: #{pred})" }}
          |> last()
        FLUX

      response = Flux.query query do |row|
        Time::Format::RFC_3339.parse row["_time"]
      end

      response.first.first unless response.empty?
    end

    def event_window(start : Time, stop : Time, filters = [] of String)
      first = first_event_time start, stop, filters
      return nil unless first
      last = last_event_time start, stop, filters if first
      return nil unless last
      {first, last}
    end

    def event_window_total_seconds(start : Time, stop : Time, filters = [] of String)
      event_window(start, stop, filters).try do |(first, last)|
        (last - first).total_seconds
      end
    end

    def state(location : String, event : String, at : Time, max_age = 3.days, filters = [] of String)
      # Offset time slightly to ensure that if querying low time-granularity
      # data (e.g. 9:30am observation) the correct observation is returned.
      time = at + 5.milliseconds

      # OPTIMIZE: lookup level first and use this to filter before pivot
      query = <<-FLUX
        from(bucket: "#{App::INFLUX_BUCKET}")
          |> range(start: #{(time - max_age).to_rfc3339}, stop: #{time.to_rfc3339})
          |> filter(fn: (r) => r._measurement == "#{event}")
          |> pivot(rowKey: ["_time", "lvl", "src"], columnKey: ["_field"], valueColumn: "_value")
          |> filter(fn: (r) => r.loc == "#{location}")
          #{filters.join { |pred| "|> filter(fn: #{pred})" }}
          |> rename(columns: {"val": "_value"})
          |> last()
        FLUX

      response = Flux.query query do |row|
        row["_value"].to_f
      end

      response.first.first unless response.empty?
    end
  end
end
