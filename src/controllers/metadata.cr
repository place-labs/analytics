require "./application"
require "../models/organisation"
require "../models/building"
require "../models/level"
require "../models/location"

module PlaceOS::Analytics
  # Very quick and dirty mocked metadata service. This should be binned at the
  # first opportunity.
  class Metadata < Application
    base "/"

    get "/organisation/:id" do
      id = params["id"]
      metadata = Model::Organisation.find id
      head :not_found unless metadata
      render json: metadata
    end

    get "/organisation/:id/buildings" do
      id = params["id"]
      org = Model::Organisation.find(id)
      head :not_found unless org
      buildings = org[:buildings].map &->Model::Building.find(String)
      render json: buildings
    end

    get "/building/:id" do
      id = params["id"]
      metadata = Model::Building.find id
      head :not_found unless metadata
      render json: metadata
    end

    get "/building/:id/levels" do
      id = params["id"]
      building = Model::Building.find(id)
      head :not_found unless building
      levels = building[:levels].map &->Model::Level.find(String)
      render json: levels
    end

    get "/level/:id" do
      id = params["id"]
      metadata = Model::Level.find id
      head :not_found unless metadata
      render json: metadata
    end

    get "/level/:id/locations" do
      id = params["id"]
      level = Model::Level.find(id)
      head :not_found unless level
      locations = level[:locations].map &->Model::Location.find(String)
      render json: locations
    end

    get "/location/:id" do
      id = params["id"]
      metadata = Model::Location.find id
      head :not_found unless metadata
      render json: metadata
    end
  end
end
