OS X 10.3-10.5 (Panther, Tiger, Leopard)

# Xcode tools
These are part of OS X, but are not installed by default.

[Install Xcode](install_xcode)

# Git

## On Leopard or Panther

* Visit <http://code.google.com/p/git-osx-installer/>
* Click "Download the packages here" which will take you to a list of downloads. Pick Intel if you have an Intel Mac, and Universal Binary if you have a PowerPC Mac.
* ([How to tell if you have an Intel or PPC Mac](how_to_tell_if_you_have_an_intel_or_ppc_mac))

## On Tiger

* Visit <http://metastatic.org/text/Concern/2008/03/08/git-package-1543-for-os-x/>

# Ruby, RubyGems, and Rails

For Panther and Leopard, follow the directions here:

<http://wiki.rubyonrails.org/getting-started/installation/mac>

**EXCEPT when it says do this:*' <code>sudo gem install rails</code>, '*do this instead:** <code>sudo gem install rails --version 2.3.9 --no-rdoc --no-ri</code>

If you are having this error:

    ERROR:  Error installing rubygems-update: hoe requires RubyGems version >= 1.3.1

Try the steps in this order:

    sudo gem update --system
    sudo gem install rubygems-update
    sudo update_rubygems

For Tiger ONLY:

* Install the "X11 User" optional package from your OS X DVD.

* Install [<http://www.macports.org/install.php> MacPorts].

* Ruby: <code>sudo port install ruby</code>

* Gems:
 * download [<http://rubyforge.org/frs/?group_id=126> RubyGems]
 * unpack: <code>tar xzf rubygems-1.3.5.tgz</code>
 * <code>cd rubygems-1.3.5</code>
 * Install:<code>ruby setup.rb</code>

* Rails: <code>sudo gem install rails --version 2.3.9 --no-rdoc --no-ri</code>

# SQLite and SQLite Manager Firefox add-on
**SQLite**

In some cases, SQLite was installed with Rails in the previous section. To check, do <code>gem list</code> in Terminal.app. If the list includes sqlite3-ruby, you're good.

If the list does not include sqlite3-ruby, do <code>sudo gem install sqlite3-ruby</code> in Terminal app.

**SQLite Manager Firefox add-on**

Step 1 is [<http://www.mozilla.com/en-US/> install Firefox]. Even if it's already installed, you may need to upgrade; the add-on requires 3.5 or greater. ([How to find out which version of Firefox you have](how_to_find_out_which_version_of_firefox_you_have))

Install the SQLite Manager Firefox add-on.

* Open Firefox

* Under the Tools menu, select Add-Ons

* Click Get Add-Ons at the top of the small window that comes up

* In the search box, enter "SQLite" without the quotes

* The first search result should be SQLite Manager.
 * If SQLite Manager is not in the search results, you probably have a version of Firefox that is too old. [<http://www.mozilla.com/en-US/> Install a newer version of Firefox] and then try again to install the add-on.

* Click the "Add to Firefox..." button.

* Click "Install" in the small window that comes up

* Click "Restart Firefox" in the add-ons window to complete the install. This will preserve the windows you have open, so it should bring you right back to this page.

* Once Firefox has restarted, look under the Tools menu. SQLite Manager should be one of the options.

# Install KomodoEdit
We'll be using the KomodoEdit text editor during the workshop, though you are free to use a different editor if you prefer. It must be a plain-text editor, such as vi or Textmate. Microsoft Word and other word processing programs won't work. If in doubt, use KomodoEdit.

**Installation steps:**

* Download the KomodoEdit installer (available for [<http://downloads.activestate.com/Komodo/releases/5.2.4/Komodo-Edit-5.2.4-4343-macosx-x86.dmg> Intel] or [<http://downloads.activestate.com/Komodo/releases/5.2.4/Komodo-Edit-5.2.4-4343-macosx-powerpc.dmg> PowerPC]). ([How_to_tell_if_you_have_an_Intel_or_PPC_Mac|Click here if you're not sure whether you have an Intel or PowerPC Mac.](how_to_tell_if_you_have_an_intel_or_ppc_mac_click_here_if_you_re_not_sure_whether_you_have_an_intel_or_powerpc_mac_))

* Select "Open with DiskImageMounter" in the file save dialog. This should be the default.

* It will open an installer with a KomodoEdit icon and a picture of your Applications folder. Drag KomodoEdit into your Applications folder.

* Unmount the installer disk image by dragging it from your desktop to the trash.

# Other required libraries
Open a Terminal window and type the following with a return at the end of each line:
    sudo gem install rspec rspec-rails cucumber cucumber-rails database_cleaner webrat --no-rdoc --no-ri
    sudo gem install heroku --no-rdoc --no-ri

# Verify installation
Make sure you can do everything in the following sections of the [<http://wiki.devchix.com/index.php?title=Server_2003> Windows install directions] (from "Create a Test Application" onwards). Wherever it says "open git bash", substitute "open Terminal."

* [Server_2003#Create_a_test_application|Create a test application](server_2003_create_a_test_application_create_a_test_application)

* [Server_2003#Create a model|Create a model](server_2003_create_a_model_create_a_model)

* [Server_2003#Check test_app in to Local Git|Check test_app in to Local Git](server_2003_check_test_app_in_to_local_git_check_test_app_in_to_local_git)

* [Server_2003#Create_an_ssh_public_key|Create an ssh public key](server_2003_create_an_ssh_public_key_create_an_ssh_public_key)

* [Server_2003#Create a Heroku Account|Create a Heroku Account](server_2003_create_a_heroku_account_create_a_heroku_account)

* [Server_2003#Deploy test_app to Heroku|Deploy test_app to Heroku](server_2003_deploy_test_app_to_heroku_deploy_test_app_to_heroku)
