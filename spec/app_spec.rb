here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "#{here}/../app"

describe InstallFest do
  it "is a sinatra app" do
    assert { InstallFest.ancestors.include? Sinatra::Application }
  end
end

