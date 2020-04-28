require "./application"
require "../queries/usage"
require "../lib/tools/aggregate"

module PlaceOS::Analytics
  # Provides metrics based on location usage.
  #
  # Usage is an indicator of material usage of a location, or more contretely:
  # the lack of availability. A location is considered in use when there are any
  # signs of life. For example, a desk with a laptop, bag or paperwork present,
  # but no person, would be considered in use. If a person was present, this
  # location would also be considered in use.
  class Usage < Application
    base "/"

    {% for path, tag in {organisation: :org, building: :bld, level: :lvl} %}
      get "/{{path.id}}/:id/usage" do
        id    = params["id"]
        start = Time::Format::RFC_3339.parse params["start"]
        stop  = Time::Format::RFC_3339.parse params["stop"]
        every = params["every"]?
        group = params["group_by"]?

        if every
          location_series = Query::Usage.series start, stop, every, filters: [
            "(r) => r.{{tag.id}} == \"#{id}\""
          ]
          if location_series.empty?
            render json: [] of Float64?
          elsif group
            render json: Tools::Aggregate.mean_series(location_series, group_by: group)
          else
            render json: Tools::Aggregate.mean_series(location_series)
          end

        elsif group
          location_aggregates = Query::Usage.aggregate start, stop, filters: [
            "(r) => r.{{tag.id}} == \"#{id}\""
          ]
          if location_aggregates.empty?
            render json: {} of String => Float64
          else
            render json: Tools::Aggregate.mean(location_aggregates, group_by: group)
          end

        else
          location_aggregates = Query::Usage.aggregate start, stop, filters: [
            "(r) => r.{{tag.id}} == \"#{id}\""
          ]
          if location_aggregates.empty?
            render json: nil
          else
            render json: Tools::Aggregate.mean(location_aggregates)
          end
        end
      end
    {% end %}
  end
end
