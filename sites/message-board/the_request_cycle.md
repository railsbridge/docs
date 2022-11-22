### How does typing in a URL result in a web page being rendered? Here's a rough overview.

<img src="img/request-cycle.jpg" height="600px">

1. The user types in a URL, hoping for a cool website.
1. After the DNS gets resolved (a topic for another day), the request hits a web server, which asks Rails what it's got.
1. Rails goes to the routes file first, which takes the URL and calls a corresponding controller action.
1. The controller goes and gets whatever stuff it needs from the database using the relevant model.
1. With the data the controller got from the model, it uses the view to make some HTML.
1. Rails packages up the response and gives it to the web server.
1. The web server delivers the response to the browser to display a cool website to the user.

