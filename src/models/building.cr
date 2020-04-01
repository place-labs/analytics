require "./base/model"

module PlaceOS::Analytics::Model
  class Building < ModelBase
    def self.temp_data
      {
        "zone-y3qHfB~QrH" => {
          id:           "zone-y3qHfB~QrH",
          name:         "Barangaroo Tower 3",
          description:  "",
          organisation: "zone-xP3Z77ZH-Z",
          levels:       [
            "zone-~VdQ7IEvSe",
            "zone-~Vc7XN6LRz",
            "zone-y3qRLrZGVs",
            "zone-~VdKS8yX4B",
            "zone-~VcDEE_EnY",
            "zone-~VdXyi0ZpC",
            "zone-~Vd97OUC0h",
            "zone-~VdFyZwwKq",
            "zone-~VchiGG_MY",
            "zone-~Vcwdome1Y",
            "zone-~Vd1qoDHT0",
          ],
        },
      }
    end
  end
end
