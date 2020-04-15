module PlaceOS::Analytics::Query
  module Raw
    extend self

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
