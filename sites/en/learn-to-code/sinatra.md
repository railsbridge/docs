<!-- next_step "extra" -->

# Sinatra

Sinatra is a Web Application Framework. It includes a Web Server and lets you write code to show when people request web pages.

# Hi, Sinatra

1. install Sinatra by running `gem install sinatra` on the command line

2. create a file called `hi.rb` containing this:

        require 'sinatra'

        get '/hi' do
          "Hi!"
        end

3. run `ruby hi.rb`

Now open a Web Browser (like Firefox or Chrome or Safari or Internet Explorer) and enter the following URL into the address bar:

    http://localhost:4567/hi

# Congratulations

You just wrote a web server.

No, really.

# Hello, Whoever

Change `hi.rb` to look like this:

    require 'sinatra'

    get '/hi/:who' do
      "Hi " + params[:who] + "!"
    end

Now visit the following URL:

    http://localhost:4567/hi/alice

# LAB: Yeller

Make a route in your Sinatra application so that when someone requests this:

    /yell/ahoy

they see this:

    AHOY!!!

and when someone requests this:

    /yell/dinnertime

they see this:

    DINNERTIME!!!

# Detour: Deploying to Heroku

* Railsbridge pages describing account setup & <a href="/installfest/deploy_a_rails_app">deploy</a> steps


