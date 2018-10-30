require "spec_helper"

require_relative "../app"
require "rack/test"

describe InstallFest do
  include Rack::Test::Methods

  # todo: move to shared module
  def get! *args
    get *args
    expect(last_response.status).to eq(200)
  end

  def app
    Rack::Builder.parse_file(File.join(File.dirname(__FILE__), '..', 'config.ru')).first
  end

  describe "an app with slides" do
    require "deck"
    before do
      here = File.expand_path(File.dirname(__FILE__))
      allow(Site).to receive(:sites_dir).and_return(File.join(here, 'sites'))
    end

    it "renders a deck" do
      get! "/meals/breakfast"
      # rendered_breakfast = Deck::SlideDeck.new(:slides => Deck::Slide.split(@breakfast)).to_pretty  # for some reason it's not rendering pretty from the app even though the app uses .to_pretty
      expect(last_response.body).to include("Raisin Bran")
    end

    # todo: include deck.js source right inside the HTML
    it "serves up deck.js and other public assets" do
      get! "/deck.js/core/deck.core.js"
      expect(last_response.body).to include("Deck JS - deck.core")

      get! "/deck.js/jquery-1.7.2.min.js"
      expect(last_response.body).to include("jQuery v1.7.2 jquery.com")

      get! "/assets/application.css"
      expect(last_response.body).to include("/* Code ray css */")
    end
  end
end