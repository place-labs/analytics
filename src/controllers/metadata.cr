require "./application"
require "../models/organisation"
require "../models/building"
require "../models/level"
require "../models/location"

module PlaceOS::Analytics
  class Metadata < Application
    base "/"

    get "/organisation/:id" do
      id = params["id"]
      metadata = Model::Organisation.find id
      head :not_found unless metadata
      render json: metadata
    end

    get "/building/:id" do
      id = params["id"]
      metadata = Model::Building.find id
      head :not_found unless metadata
      render json: metadata
    end

    get "/level/:id" do
      id = params["id"]
      metadata = Model::Level.find id
      head :not_found unless metadata
      render json: metadata
    end

    get "/location/:id" do
      id = params["id"]
      metadata = Model::Location.find id
      head :not_found unless metadata
      render json: metadata
    end
  end
end
