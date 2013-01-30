require "spec_helper"

require "site"

describe Site do
  it "lists all sites" do
    sites = Site.all
    site_names = sites.map(&:name)
    site_names.should include("installfest")
    site_names.should include("curriculum")
  end
  
  it "has doc files" do
    installfest = Site.named("installfest")
    doc_filenames = installfest.docs.map(&:filename)
    doc_filenames.should include("install_homebrew.step")
  end
end
