require "./application"
require "../queries/occupancy"
require "../lib/tools/aggregate"

module PlaceOS::Analytics
  # Provides metrics based on location occupancy.
  #
  # Occupancy is an an indicator of human usage of locations. A location is
  # considered occupied when a person is physically there and using it. A
  # location which has had materials left (laptops, paper etc), but no person
  # present is considered un-occupied.
  class Occupancy < Application
    base "/"

    {% for path, tag in {organisation: :org, building: :bld, level: :lvl} %}
      get "/{{path.id}}/:id/occupancy" do
        id    = params["id"]
        start = Time::Format::RFC_3339.parse params["start"]
        stop  = Time::Format::RFC_3339.parse params["stop"]
        every = params["every"]?
        group = params["group_by"]?

        if every
          location_series = Query::Occupancy.series start, stop, every, filters: [
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
          location_aggregates = Query::Occupancy.aggregate start, stop, filters: [
            "(r) => r.{{tag.id}} == \"#{id}\""
          ]
          if location_aggregates.empty?
            render json: {} of String => Float64
          else
            render json: Tools::Aggregate.mean(location_aggregates, group_by: group)
          end

        else
          location_aggregates = Query::Occupancy.aggregate start, stop, filters: [
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
