## Ruby

Open an interactive Ruby terminal (type 'exit' to quit)

    irb

Run a ruby program named FILENAME.rb

    ruby FILENAME.rb

Installs a gem called GEMNAME

    gem install GEMNAME

Installs gems listed in the `Gemfile`

    bundle install

## Rails

Create a new rails project called `NAME`

    rails new NAME
    
Auto-generate routes (this can also be done manually)

    rails generate scaffold

Create a new [Rails model]

    rails generate model MODELNAME

Update the database to match what you have described in your code

    rake db:migrate

Run the application locally (Ctrl-C to quit)

    rails server

Start an interactive Ruby session that knows about your Rails models (type 'exit' to quit)

    rails console

Print the routes for your application

    rake routes

## Browser

Go to the root page of your rails application

    http://localhost:3000

## Git

Creates a new git repository in your current directory.

    git init

Add the current directory, and all sub directories, to your git repository.

    git add .

Tells you what you've added, deleted, and changed between your current directory and you local git repository.

    git status

Prints the difference between FILENAME and what is in your local git repository.

    git diff FILENAME

Commit the files you've added to the local repository.

    git commit -m "Describe what has changed, and why" .

Push *committed* changes to the remote server.

    git push
