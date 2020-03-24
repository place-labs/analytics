require "./base/model"

module PlaceOS::Analytics::Model
  class Location < ModelBase
    def self.temp_data
      {
        "foo" => {
          name:         "Foo",
          description:  "",
          organisation: "zone-xP3Z77ZH-Z",
          building:     "zone-y3qHfB~QrH",
          level:        "zone-y3qRLrZGVs",
          type:         "Unknown",
          bookable:     true,
          email:        "foo@example.com",
          capacity:     6,
        },
        "bar" => {
          name:         "Bar",
          description:  "",
          organisation: "zone-xP3Z77ZH-Z",
          building:     "zone-y3qHfB~QrH",
          level:        "zone-y3qRLrZGVs",
          type:         "Unknown",
          bookable:     true,
          email:        "bar@example.com",
          capacity:     4,
        },
        "baz" => {
          name:         "Baz",
          description:  "",
          organisation: "zone-xP3Z77ZH-Z",
          building:     "zone-y3qHfB~QrH",
          level:        "zone-y3qRLrZGVs",
          type:         "Unknown",
          bookable:     true,
          email:        "baz@example.com",
          capacity:     3,
        },
      }
    end
  end
end
