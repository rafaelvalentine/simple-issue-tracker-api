require "rails_helper"

RSpec.describe SprintsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sprints").to route_to("sprints#index")
    end

    it "routes to #show" do
      expect(get: "/sprints/1").to route_to("sprints#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/sprints").to route_to("sprints#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/sprints/1").to route_to("sprints#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/sprints/1").to route_to("sprints#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/sprints/1").to route_to("sprints#destroy", id: "1")
    end
  end
end
