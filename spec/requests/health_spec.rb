require "rails_helper"

RSpec.describe "Health EndPoint", type: :request do
  describe "GET /health" do
    before { get '/health' }

    it "Should return OK" do
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload['api']).to eq('OK')
    end

    it "Should return OK" do
      expect(response).to have_http_status(200)
    end
  end
end