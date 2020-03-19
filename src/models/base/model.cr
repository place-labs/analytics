require "./temp_data"

module PlaceOS::Analytics::Model
  # Base class for all PlaceOS Analytics models
  abstract class ModelBase
    def self.find(id : String)
      TempData[id]?
    end
  end
end
