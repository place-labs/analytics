require "./base/model"

module PlaceOS::Analytics::Model
  class Level < ModelBase
    def self.temp_data
      {
        "zone-y3qRLrZGVs" => {
          name:         "Level 10",
          description:  "",
          organisation: "zone-xP3Z77ZH-Z",
          building:     "zone-y3qHfB~QrH",
          locations:    [
            "foo",
            "bar",
            "baz",
          ],
        },
      }
    end
  end
end
