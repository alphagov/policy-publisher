require 'rails_helper'

RSpec.describe "the healthcheck page", type: :request do
  it "should return success" do
    get "/healthcheck"

    expect(response.status).to eq(200)
  end
end
