# The RailsBridge Documentation Project

[![Build Status](https://travis-ci.org/railsbridge/docs.png)](https://travis-ci.org/railsbridge/docs)

## Overview

This is a Sinatra app, deployed at <http://docs.railsbridge.org>. The RailsBridge documentation project is home to a few subprojects, including the RailsBridge installfest instructions, which leads students through the various complicated setup instructions for getting Ruby, Rails, Git, etc. installed on their computer (whatever combination of computer, OS, and version they happened to bring to the workshop!), as well as the RailsBridge workshop "Suggestotron" curriculum.

Each subproject (a "site") comprises files stored under the "sites" directory; for instance, the installfest instructions are located at ROOT/sites/en/installfest, while the intro rails curriculum can be found under ROOT/sites/en/intro-to-rails. (The "en" means "English" -- see "Locales" below.)

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

## Locales

To serve sites from "sites/en", use `rake run` or a vanilla deploy.

To server sites from another locale (say, "es" or Spanish)...

### Run Localized Site Locally

    $ SITE_LOCALE=es rake run

The server listens on `0.0.0.0:9292`.

Now you have to set up subdomain mappings for the site. If you have Pow, run:

    $ echo 9292 > ~/.pow/railsbridge # works for any subdomain

If you don't have Pow, add the following line to `/etc/hosts`:

    127.0.0.1 es.railsbridge.dev # works for single subdomain

Now you can access `http://es.railsbridge.dev:9292` for debugging.

### Running on a Server

Just make sure the server responds to a locale subdomain: `http://es.railsbridge.org`

### Temporary Testing

Use a `locale` or `l` parameter: `http://docs.railsbridge.org/?l=es`.

Note that in this mode, links are not rewritten, so if they fail you will have to manually add the parameter again.

## Contributing

Check out [CONTRIBUTING.md](CONTRIBUTING.md) to see how to join our [list of contributors](https://github.com/railsbridge/docs/contributors)!

## License

The documentation (including anything under the `sites` subdir as well as some hardcoded text elsewhere) is licensed under a Creative Commons license ([CC-BY,  specifically](http://creativecommons.org/licenses/by/3.0/)), which means you're welcome to share, remix, or use our content commercially. We just ask for attribution.

The code is licensed under an [MIT license](http://opensource.org/licenses/MIT), like Ruby itself. Copyright (c) 2010-2014 by RailsBridge.

## Other Resources

- [StepFile Reference](step_file_reference.md)
- Workshop organizers: See http://docs.railsbridge.org/workshop for example slide decks you can use in your opening/closing presentations.

