## Getting Started

1. Create your project

2. View your project in the browser. You should see a default page.

## Create your Controller

Each Class/Controller has a set of methods that can be associated with it: index, create, new, edit, show, update, destroy.
We will start with index, which is used to display your entry point <<TODO: What is the purpose of the index method?

3. Create your first controller called 'Homes'. Use the existing instance of a controller to fill in the content!

Create a controller file in the app/controller folder. "The file should always be named with lower case letters and underscores."

    app/controller/homes_controller.rb

4. Create the index method in the controller. In the homes_controller.rb file add:

    def index
    end

## Create your View

5. Create your first view, to be associated with the 'Homes' class and the 'index' method. Use the existing instance of a view to fill in the content!

Create a class folder in app/view. "The folder name should always be lower case and the name of your class."
 
    app/view/homes

Create a file for your first method in the app/view/class folder. "The filename should always be lower case and the name of the method."
 
    app/view/homes/index.html.rb

Each view created is associated with a class and method pair. If the method does not exist then theoretically nothing should render. BUT, rails helps you out and if no method is defined it pretends that the method exists, and is empty, and render as such.

## Create your Route

A "route" is a path that points to a method for a specific class. This class and method pair also indicates which view should be used, via the file and file naming conventions mentioned above.

6. Edit routes.rb so that the base url points to your application entry point

	root home#index

"NOTE: This says that your base url (i.e. root) should use the "home" class and the "index" method of that class. The view used will be the html file in the "home" folder with name "index (e.g. home/index.html.rb)."

Each subsequent route should be defined in a similar but slightly differnet way:

    get 'new' => 'home#new'

"NOTE: This say that the base url with /new on the end will direct to the `new` method for the `homes` class."

## Test your new Controller

7. Go back to your project in the browser and confirm that you now see your index.html.rb file instead of the default when you go to the root path.

8. Add a 'new' method to the homes controller and test that you can see it at the /new path in the web browser.


    