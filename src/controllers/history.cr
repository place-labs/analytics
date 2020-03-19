require "./application"

module PlaceOS::Analytics
  class History < Application
    base "/"

    # Provides the state of a tracked param at a previous point in time.
    get "/location/:id/state/:event" do
      location = params["id"]
      event = params["event"]
      time = params["at"]?

      now = Time.utc
      if time
        time = Time::Format::RFC_3339.parse(time)
        head :bad_request if time > now
      else
        time = now
      end

      if value = History.lookup location, event, at: time
        render json: value
      else
        head :no_content
      end
    end

    # Provide a regular time series for a tracked param.
    get "/location/:id/series/:event" do
      location = params["id"]
      event = params["event"]
      start = Time::Format::RFC_3339.parse params["start"]
      stop = Time::Format::RFC_3339.parse params["stop"]
      interval = params["every"]

      render json: [0.0, 1.0, 1.0, 1.0, 0.0]
    end

    # Lookup the value of a tracked param at a specified point in time. Returns
    # nil if no data is availble.
    def self.lookup(location : String, event : String, at time : Time) : Float64?
      # Offset time slightly to ensure that if querying low time-granularity
      # data (e.g. 9:30am observation) the correct observation is returned.
      time += 5.milliseconds

      # OPTIMIZE: lookup level first and use this to filter before pivot
      query = <<-FLUX
        from(bucket: "place")
          |> range(start: #{(time - 3.days).to_rfc3339}, stop: #{time.to_rfc3339})
          |> filter(fn: (r) => r._measurement == "#{event}")
          |> pivot(rowKey: ["_time", "lvl", "src"], columnKey: ["_field"], valueColumn: "_value")
          |> filter(fn: (r) => r.loc == "#{location}")
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
