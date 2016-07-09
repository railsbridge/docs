!SLIDE
## Web App Network Architecture
![](img/web-application.png)

!SLIDE
## Web App MVC Architecture
![](img/mvc_simple.png)

!SLIDE
# REST
* Representational State Transfer
* Application state and functionality are abstracted into resources
* Each resource may be referenced with a global identifier (URI over HTTP)
* Resources share a uniform interfaces
* Note
  * introduced in 2000 in the doctoral dissertation of Roy Fielding
  * http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm

!SLIDE
# REST URIs and HTTP actions
* GET http://myserver.com/topics - a list of all the topics
* GET http://myserver.com/topics/1 - the first topic
* POST http://myserver.com/topics - create a topic
* PUT http://myserver.com/topics/1 - modify the first topic
* DELETE http://myserver.com/topics/1 - delete the first topic

