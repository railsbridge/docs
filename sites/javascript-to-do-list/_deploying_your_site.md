### Goal

Hosting your project requires you to make the HTML, JavaScript and CSS files
available over the Internet.

There are three hosting options, depending on how much of a challenge you are looking
for:

* Use a static site hosting service
* Use git and Github Pages
* Roll your own with a hosting provider

### Using a Static Site Hosting Service

If you are brand new to hosting websites, you may want to use a static site
hosting service. These allow you to upload a zip file of html, css and
javascript and have a working website. An easy one is
[Forge](https://getforge.com/).

1. Sign up for Forge
2. Zip your project directory
3. Drag it into the Forge website

Now you have a fully functioning site hosted online! Share the link
with your friends and family and wow them with your skills!

### Using Git and Github Pages

If you like with git and github, take a stab at setting up your site
with [Github Pages](http://pages.github.com/). The easiest thing to do is:
cd .

1. From the terminal, `cd` into your project directory
1. Turn it into a git repository by running `git init`
1. Checkout a branch called `gh-pages`
1. Commit all the files
1. Create a remote repository on github for the project.
1. Follow their instructions for adding the github remote to your existing repo
1. Follow the instructions on [Github Pages](http://pages.github.com) for
   setting up a project site from scratch.
1. Make the `gh-pages` the default branch
1. Push it on up!

### Rolling Your Own Hosting With a Cloud Provider

If you secretly are an unix admin who floats in the cloud; consider
using Amazon
[S3](http://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html) or
[Rackspace Cloud
Files](http://www.rackspace.com/knowledge_center/article/use-cloud-files-to-serve-static-content-for-websites)

Both of these services are designed to serve up static files without needing to
pay for a virtual server. This makes your monthly hosting bill for even large,
high traffic sites incredibly cheap.