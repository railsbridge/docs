## Workshops

**Note** This may be outdated

Slide contents that change with each workshop are contained in three files under the workshop project. The 'hello and welcome, this is when the breaks are' presentation slides are in current.deck.md. The 'this is what we will learn today' slides are in welcome.deck.md. And the 'this is what we have learned, and what comes next' slides are in closing.deck.md.

To change those contents, clone this repo, make changes, and then to include your changes in the publicly available repo, send a pull request.

##clone the repo

On a command line cd into a directory for the installfest app to live on your machine. For example, to put it in your home directory: `cd ~`

Then clone the repository from github:
`git clone git://github.com/phpbridge/docs.git`

And open it in the editor of your choice.

## changes

If you want to change the name of the hosts and sponsors in the intro slides, open current.deck.md, find and replace the name of the previous hosts and sponsors on the slide deck. To include their logos, drop an image inside the public/img folder. If their are more or fewer hosts and sponsors than in the previous workshop, create new slides!

Check that the current.deck.md and closing.deck.md files fit the workshop.

## pull request

When you're happy with how you've changed the repository, commit it. In the command line, add your changes with `git add .` and commit them locally with `git commit -m "super descriptive message "`. Push it to your own fork of the repository with`git push`. The next step, submitting a pull request is used to incorporate your changes into RailsBridge's version of the repository. Navigate to your forked version of the repository on github (and check the commits tab to see your changes!). There's a pull request button near the top of the page, and after clicking you can add a title and explanations of your changes. After submitting, it may take a while for people to review and accept your changes. Poke people. Make sure they check it out. Check out Github's <a href="http://help.github.com/send-pull-requests/">help page</a> on the pull requests.