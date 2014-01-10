# The Railsbridge Documentation Project

[![Build Status](https://travis-ci.org/railsbridge/docs.png)](https://travis-ci.org/railsbridge/docs)

## Overview

This is a Sinatra app, deployed at <http://docs.railsbridge.org>. The RailsBridge documentation project is home to a few subprojects, including the RailsBridge installfest instructions, which leads students through the various complicated setup instructions for getting Ruby, Rails, Git, etc. installed on their computer (whatever combination of computer, OS, and version they happened to bring to the workshop!), as well as the RailsBridge workshop "Suggestotron" curriculum.

Each subproject (a "site") comprises files stored under the "sites" directory; for instance, the installfest instructions are located at ROOT/sites/installfest, while the intro rails curriculum can be found under ROOT/sites/intro-to-rails.

These files can be in any of these formats:

* `.step` for [StepFile](step_file_reference.md)
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

Check out [CONTRIBUTING.md](CONTRIBUTING.md) to see how to join our [list of contributors](https://github.com/railsbridge/docs/contributors)!

## License

The documentation (including anything under the `sites` subdir as well as some hardcoded text elsewhere) is licensed under a Creative Commons license ([CC-BY,  specifically](http://creativecommons.org/licenses/by/3.0/)), which means you're welcome to share, remix, or use our content commercially. We just ask for attribution.

The code is licensed under an [MIT license](http://opensource.org/licenses/MIT), like Ruby itself. Copyright (c) 2010-2014 by RailsBridge.

## Other Resources

- Workship Organizers see [WORKSHOP.md](WORKSHOP.md)
- [StepFile Reference](step_file_reference.md)

