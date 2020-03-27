require "./application"
require "../queries/occupancy"

module PlaceOS::Analytics
  # Provides metrics based on location occupancy.
  #
  # Occupancy is an an indicator of human usage of locations. A location is
  # considered occupied when a person is physically there and using it. A
  # location which has had materials left (laptops, paper etc), but no person
  # present is considered un-occupied.
  class Occupancy < Application
    base "/"

    {% for path, tag in { organisation: :org, building: :bld, level: :lvl } %}
      get "/{{path.id}}/:id/occupancy" do
        id    = params["id"]
        start = Time::Format::RFC_3339.parse params["start"]
        stop  = Time::Format::RFC_3339.parse params["stop"]
        every = params["every"]?
        group = params["group_by"]?

        if every
          head :bad_request if group
          location_series = Query::Occupancy.series start, stop, every, filters: [
            "(r) => r.{{tag.id}} == \"#{id}\""
          ]
          head :no_content if location_series.empty?
          render json: Occupancy.aggregate(location_series)

        elsif group
          head :bad_request unless group == "type"
          location_aggregates = Query::Occupancy.aggregate start, stop, filters: [
            "(r) => r.{{tag.id}} == \"#{id}\""
          ]
          head :no_content if location_aggregates.empty?
          render json: Occupancy.aggregate_by(group, location_aggregates)

        else
          location_aggregates = Query::Occupancy.aggregate start, stop, filters: [
            "(r) => r.{{tag.id}} == \"#{id}\""
          ]
          head :no_content if location_aggregates.empty?
          render json: Occupancy.aggregate(location_aggregates)
        end
      end
    {% end %}

    # Aggregate a set of single values.
    def self.aggregate(value_hash : Hash(String, Float64))
      value_hash.values.sum / value_hash.size.to_f
    end

    # Aggegate a set of values by a location attribute
    # FIXME: implement grouping based on location metadata
    def self.aggregate_by(attr : String, value_hash : Hash(String, Float64))
      {
        workstations: 0.0,
        workpoints: 0.0,
        informal: 0.0,
        formal: 0.0,
        social: 0.0,
        unknown: aggregate(value_hash)
      }
    end

    # Aggregate a set of uniform series, producing a single series with each
    # point representing the mean value of all components at that time.
    def self.aggregate(value_hash : Hash(String, Array(Float64?)))
      value_hash.values.reduce do |acc, i|
        acc.zip(i).map do |a, b|
          if a && b
            (a + b) / 2.0
          elsif a
            a
          elsif b
            b
          else
            nil
          end
        end
      end
    end
  end
end
