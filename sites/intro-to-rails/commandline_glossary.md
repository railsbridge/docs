**~**  Called 'tilde'. On OS X or Linux, this is a shortcut to the **home directory** for your user.

**/**  When you use an 'escape sequence' in front of a character, the normal interpretation of that character is not applied.

**=**  Assignment to make whatever follows, to be treated as true (_Name="Veronica"_).

**==**  Boolean, a data type with only 2 possible values: True or False (_Is name=="Veronica"? True_).


**cd (or cd ~)**  Change into your **home directory**.

**cd** _directory_ **(or cd ..)**  Change into the parent directory of your current directory.

**cd ../../**  Go up 2 levels / multiple levels.

**cd** _foo_  Change into the directory named _foo_.

**cp** _original.rb copy.rb_  Makes a copy of the _original.rb_ file.

**ls**  List the contents of your current directory.

**ls** _directory_  Shows all contents (files and folders) of the directory.

**pwd**  Shows the full path of the directory you are currently in (e.g. _/home/heidi/tehcodez/Railsbridge_).

**-h (or --help)**  Can be run with all commands to list more helpful information.

**puts** _something_  Prints its argument to the console. Can be used in Rails apps to print something in the console where the server is running.


**git branch**  Shows you the branch that you're currently in.

**git status**  Shows you any pending changes that you've created since your last commit.

**git add -A**  Will add all your changes to your next commit.

**git add** _file1.md file2.md file3.md_  Will add only the files you specify to your next commit.

**git commit -m** _"some useful message for your future self"_  Commits all your changes with your descriptive message to git.

**git push origin** <i>remote\_branch\_name</i>  This pushes the code in your current branch to the <i>remote\_branch\_name</i> branch on the remote repo named 'origin'.


**rails new** _NameApp_  Creates a new Rails application with the entire Rails directory structure to run your application.

**rails server (or rails s)**  Launches a small web server named WEBrick that you will use any time you want to access your application through a web browser.

**rails generate (or rails g)**  Uses templates to create a bunch of directories and files in your application.

**rails generate scaffold**  Creates a full set of model, database migration for that model, controller to manipulate it, views to view and manipulate the data and a test suite for each of the above.

**rake**  Rake is ‘Ruby Make', used to build up a list of tasks.

**rails console (or rails c)** Lets you interact with your Rails application from the command line, useful for testing out quick ideas with code and changing data server-side without touching the website.

**rails console --sandbox**  If you wish to test out some code without changing any data.

**rails dbconsole (or rails db)**  Used to figure out which database you're using and drops you into whichever command line interface you would use with.  It supports MySQL, PostgreSQL, SQLite and SQLite3.

**rails destroy (or rails d)**  Does the opposite of generate.  It will figure out what generate did and undo it.
