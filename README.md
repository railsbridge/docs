# The Railsbridge Documentation Project

[![Build Status](https://travis-ci.org/railsbridge/docs.png)](https://travis-ci.org/railsbridge/docs)

## Overview

This is a Sinatra app, deployed at <http://docs.railsbridge.org>. The RailsBridge documentation project is home to a few subprojects, including the RailsBridge installfest instructions, which leads students through the various complicated setup instructions for getting Ruby, Rails, Git, etc. installed on their computer (whatever combination of computer, OS, and version they happened to bring to the workshop!), as well as the RailsBridge workshop "Suggestotron" curriculum.

Each subproject (a "site") comprises files stored under the "sites" directory; for instance, the installfest instructions are located at ROOT/sites/installfest, while the intro rails curriculum can be found under ROOT/sites/intro-to-rails.

These files can be in any of these formats:

* `.step` for [StepFile](//github.com/railsbridge/docs/blob/master/step_file_reference.md)
* `.md` for [Markdown](http://daringfireball.net/projects/markdown/syntax)
* `.mw` for MediaWiki (temporary)
* `.deck.md` for [deck.rb](https://github.com/alexch/deck.rb)

(If multiple files exist with the same base name, `.step` is preferred over `.md`, and `.md` over `.mw`.)

## Usage

    bundle install
    rake run

If the above fails (say, because `rerun` doesn't work on your system), try

    rackup
    
Then open <http://localhost:9292> in a web browser, and verify that you can navigate the installfest slides.

## Contributing

Check out [CONTRIBUTING.md](//github.com/railsbridge/docs/blob/master/CONTRIBUTING.md) to see how to join our [list of contributors](https://github.com/railsbridge/docs/contributors)!

## Resources

- Workship Organizers see [WORKSHOP.md](//github.com/railsbridge/docs/blob/master/WORKSHOP.md)
- [StepFile Reference](//github.com/railsbridge/docs/blob/master/step_file_reference.md)

# Credits

some icons from https://github.com/kennethreitz/open-icons