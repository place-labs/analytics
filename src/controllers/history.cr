require "./application"
require "../queries/raw"

module PlaceOS::Analytics
  class History < Application
    base "/"

    # Provides the state of a tracked param at a previous point in time.
    get "/location/:id/raw/:event" do
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

      if value = Query::Raw.state location, event, time
        render json: value
      else
        response.headers["Content-Type"] = "application/json"
        render text: "null"
      end
    end
  end
end
