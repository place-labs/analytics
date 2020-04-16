require "csv"
require "./base/model"

module PlaceOS::Analytics::Model
  class Location < ModelBase
    alias Location = {id: String, name: String, description: String, organisation: String, building: String, level: String, type: String?, bookable: Bool, email: String?, capacity: Int32?}

    TEMP_DATA = Hash(String, Location).new.tap do |locations|
      csv = {{ read_file("src/models/temp_data.csv") }}
      CSV.new(csv, headers: true) do |csv|
        entry = {
          id:           csv["id"],
          name:         csv["name"],
          description:  csv["description"],
          organisation: csv["organisation"],
          building:     csv["building"],
          level:        csv["level"],
          type:         csv["type"]?,
          bookable:     csv["bookable"] == "TRUE",
          email:        csv["email"]?,
          capacity:     csv["capacity"].to_i32?,
        }
        locations[entry[:id]] = entry
      end
    end

    def self.temp_data
      TEMP_DATA
    end
  end
end
