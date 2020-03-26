require "./application"
require "../queries/occupancy"

module PlaceOS::Analytics
  class Occupancy < Application
    base "/"

    get "/organisation/:id/occupancy" do
      org_id = params["id"]
      start  = Time::Format::RFC_3339.parse params["start"]
      stop   = Time::Format::RFC_3339.parse params["stop"]
      every  = params["every"]?
      group  = params["group_by"]?

      if every
        head :bad_request if group

        series = Query::Occupancy.series start, stop, every, filters: [
          "(r) => r.org == \"#{org_id}\""
        ]
        render json: series

      elsif group
        head :bad_request unless group == "type"

        locations = Query::Occupancy.aggregate start, stop, filters: [
          "(r) => r.org == \"#{org_id}\""
        ]
        # FIXME: group location aggregates by types
        if locations.empty?
          head :no_content
        else
          render json: {
            workstations: 0.0,
            workpoints: 0.0,
            informal: 0.0,
            formal: 0.0,
            social: 0.0,
            unknown: locations.values.sum / locations.size.to_f
          }
        end

      else
        locations = Query::Occupancy.aggregate start, stop, filters: [
          "(r) => r.org == \"#{org_id}\""
        ]
        if locations.empty?
          head :no_content
        else
          render json: locations.values.sum / locations.size.to_f
        end
      end
    end
  end
end
