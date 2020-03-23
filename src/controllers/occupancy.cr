require "./application"

module PlaceOS::Analytics
  class Occpancy < Application
    base "/"

    {% for entity in [:organisation, :building, :level, :location] %}
      get "/{{entity}}/:id/occupancy" do
        id = params["id"]

        start = params["start"]
        stop = params["stop"]

        every = params["every"]?

        group_by = params["group_by"]?
        filter = params["filter"]?

        if every
          render json: 50.times.map { rand }.to_a
        elsif group_by
          render json: {
            workstations: rand,
            workpoints: rand,
            informal: rand,
            formal: rand,
            social: rand,
            unknown: rand
          }
        else
          render json: rand
        end
      end
    {% end %}

#    def self.aggregate(start : Time, stop : Time, filters = [] of String)
#    end
#
#    def self.series
#    end
  end
end
