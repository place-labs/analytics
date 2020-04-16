require "./base/model"
require "./location"

module PlaceOS::Analytics::Model
  class Level < ModelBase
    TEMP_DATA = {
      "zone-~VdQ7IEvSe" => {
        id:           "zone-~VdQ7IEvSe",
        name:         "Level 8",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
      "zone-~Vc7XN6LRz" => {
        id:           "zone-~Vc7XN6LRz",
        name:         "Level 9",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
      "zone-y3qRLrZGVs" => {
        id:           "zone-y3qRLrZGVs",
        name:         "Level 10",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
      "zone-~VdKS8yX4B" => {
        id:           "zone-~VdKS8yX4B",
        name:         "Level 11",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
      "zone-~VcDEE_EnY" => {
        id:           "zone-~VcDEE_EnY",
        name:         "Level 12",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
      "zone-~VdXyi0ZpC" => {
        id:           "zone-~VdXyi0ZpC",
        name:         "Level 13",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
      "zone-~Vd97OUC0h" => {
        id:           "zone-~Vd97OUC0h",
        name:         "Level 14",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
      "zone-~VdFyZwwKq" => {
        id:           "zone-~VdFyZwwKq",
        name:         "Level 16",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
      "zone-~VchiGG_MY" => {
        id:           "zone-~VchiGG_MY",
        name:         "Level 17",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
      "zone-~Vcwdome1Y" => {
        id:           "zone-~Vcwdome1Y",
        name:         "Level 18",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
      "zone-~Vd1qoDHT0" => {
        id:           "zone-~Vd1qoDHT0",
        name:         "Level 19",
        description:  "",
        organisation: "zone-xP3Z77ZH-Z",
        building:     "zone-y3qHfB~QrH",
        locations:    [] of String,
      },
    }.tap do |levels|
      Location::TEMP_DATA.each_value do |location|
        level = levels[location[:level]]?
        level[:locations] << location[:id] if level
      end
    end

    def self.temp_data
      TEMP_DATA
    end
  end
end
