require 'spec_helper'
require "media_wiki"

include MediaWiki

describe "mw2md" do
  it "converts [[]]" do
    expect(mw2md("[[OS X 10.7 (Lion)]]")).to eq("[OS X 10.7 Lion](os_x_10_7_lion)")
  end
end

=begin
* Mac users: [[OS X 10.7 (Lion)]] | [[OS_X_10.6_(Snow_Leopard) | OS X 10.6 (Snow Leopard)]] | [[OS X 10.6 or 10.5 (Snow Leopard or Leopard)]]. [[Determining your OS X version|Click here if you're not sure what version of OS X you have.]]
* Linux users: [[Ubuntu 10.04 - Rails 3 |Ubuntu 10.04]]
* Windows users: [[WindowsInstaller - Rails 3|Windows 7/Vista/XP]]
=end

