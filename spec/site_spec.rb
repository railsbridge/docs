require "spec_helper"

require "site"

describe Site do
  it "lists all sites" do
    sites = Site.all
    site_names = sites.map(&:name)
    site_names.should include("installfest")
    site_names.should include("intro-to-rails")
  end
  
  it "has doc files" do
    installfest = Site.named("installfest")
    doc_filenames = installfest.docs.map(&:filename)
    doc_filenames.should include("configure_git.step")
  end
  
  it "finds the sites_dir" do
    Site.sites_dir.should == File.expand_path(File.join(File.dirname(__FILE__), "..", "sites", "en"))
  end

  it "finds the sites_dir for Spanish locale" do
    Site.sites_dir('es').should == File.expand_path(File.join(File.dirname(__FILE__), "..", "sites", "es"))
  end
end
