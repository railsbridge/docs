require "wrong/adapters/rspec"

here = File.expand_path File.dirname(__FILE__)
require "./mw2md"

include MW2MD

describe "mw2md" do
  it "converts [[]]" do
    assert {
      mw2md("[[OS X 10.7 (Lion)]]") == "[OS X 10.7 Lion](osx107lion)"
    }
  end
end

=begin
* Mac users: [[OS X 10.7 (Lion)]] | [[OS_X_10.6_(Snow_Leopard) | OS X 10.6 (Snow Leopard)]] | [[OS X 10.6 or 10.5 (Snow Leopard or Leopard)]]. [[Determining your OS X version|Click here if you're not sure what version of OS X you have.]]
* Linux users: [[Ubuntu 10.04 - Rails 3 |Ubuntu 10.04]]
* Windows users: [[WindowsInstaller - Rails 3|Windows 7/Vista/XP]]
=end

