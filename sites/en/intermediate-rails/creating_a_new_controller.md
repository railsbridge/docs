## Getting Started

**1\.** Create your project

**2\.** View your project in the browser. You should see a default page.

## Create your Controller

Controllers are classes that inherit from ApplicationController.

Controllers in Rails have one or many **actions**.
Each action is defined as a method inside the controller.
Some standard actions are **index, create, new, edit, show, update,** and **destroy**. But you're not limited to using those names.

We will start with index, which can be used to display the main page in your application.

**3\.** Create your first controller called **HomeController**.

Create a controller file in the app/controller folder. *The file should always be named with lower case letters and underscores.*

```
app/controllers/home_controller.rb
```

**4\.** Create your controller, with an empty index method. In the home_controller.rb file add:

```
class HomeController < ApplicationController
  def index
  end
end
```

## Create your View

**5\.** Create your first view, to be associated with the `Home` controller and the `index` action.

Create a new folder in app/views. *The folder name should always be lower case and the name of your controller.*

```
app/views/home
```

Create a file for your first action in the app/views/home folder. *The filename should always be lower case and the name of the action.*

```
app/views/home/index.html.rb
```

Each view created is associated with one controller action. You don't even really need to define a method in the associated controller: as long as the associated controller and route exist, Rails will pretend that the method exists, and is empty, and render as such.

## Create your Route

A **route** is a path that points to an action for a specific controller. This controller and action pair (often stylized as **controller#action**) also indicates which view should be used, via the file naming conventions mentioned above.

**6\.** Edit routes.rb so that the base url points to your application entry point

```
root 'home#index'
```

NOTE: This says that your base url (i.e. root) should use the `index` action of the `home` controller. The view used will be the file in the app/views/home folder with name `index` (e.g. app/views/home/index.html.erb).

Each subsequent route should be defined in a similar way:

```
get 'about' => 'home#about'
```

NOTE: This says that the base url with /about on the end will direct to the `about` action in the `home` controller.

## Test your new Controller

**7\.** Go back to your project in the browser and confirm that on the root path you now see the content from your index.html.erb file instead of the default Rails welcome page.

**8\.** Add an `about` action to the Home controller and test that you can see it at the /about path in the web browser.


    