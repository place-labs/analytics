# Mock metadata for initial testing
PlaceOS::Analytics::Model::TempData = {
  # Organisations
  "zone-xP3Z77ZH-Z" => {
    name:        "Lendlease",
    description: "",
    buildings:   [
      "zone-y3qHfB~QrH",
    ],
  },

  # Buildings
  "zone-y3qHfB~QrH" => {
    name:         "Barangaroo Tower 3",
    description:  "",
    organisation: "zone-xP3Z77ZH-Z",
    levels:       [
      "zone-y3qRLrZGVs",
    ],
  },

  # Levels
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

  # Locations
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
}
