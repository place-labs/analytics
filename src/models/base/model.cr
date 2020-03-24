module PlaceOS::Analytics::Model
  # Base class for all PlaceOS Analytics models
  abstract class ModelBase
    def self.find(id : String)
      temp_data[id]?
    end
  end
end
