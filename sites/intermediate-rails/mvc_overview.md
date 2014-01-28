## Explaining MVC and Records

![MVC Overview](/intro-to-rails/img/mvc.png)

Rails implements a very specific notion of the **Model/View/Controller** pattern, which guides how you structure your web applications.

<h3 id="model">Model</h3>
  
* saves data to the database
* accesses data from the database
* bridge between the database and objects
  
<h3 id="view">View</h3>

* display the data for human (or machine) consumption
* webpages are views

<h3 id="controller">Controller</h3>

* acts as the glue between the models and the views
* combines data from multiple models
* summarizes and filters data

In MVC, models, views, and controllers have very specific jobs.  Separating responsibilities like this make it easy to maintain and extend rails applications.  When responsibilities become muddied it gets much harder to debug issues and add new functionality.