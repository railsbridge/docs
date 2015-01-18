# StepFile Reference

A StepFile is a [DSL](http://en.wikipedia.org/wiki/domain+specific+language) for describing a series of instructions, possibly nested inside other instructions. Technically speaking it is an *internal Ruby DSL* which means it parses as Ruby code. Nested blocks use Ruby's do..end structures, named options use Ruby's hash syntax, and string options may use any of Ruby's myriad string formats (double-quote, single-quote, here doc, percent-q, etc.)

Here Docs are especially useful with `message`s since you can just dump in markdown between `<<-MARKDOWN` and `MARKDOWN` declarations.

## steps

* steps support nested content via `do` and `end`
* indents the nested block content
* inside the nested block, the step count is reset, then resumes afterwards, e.g.

        Step 1: steal underpants
        Step 2: do the hokey pokey
          | Step 1: put your left foot in
          | Step 2: take your left foot out
          | Step 3: put your left foot in again
          | Step 4: shake it all about
        Step 3: profit!

`step "name"`

  * creates a new step heading
  * maintains a count of steps at the same level
  * prefixes name with e.g. "Step 1:"

`goals do`

  * a titled, formatted list of goals

`goal "text"`

  * an individual goal (marked up with \<li\>)
  * text can be markdown

`steps do`

  * a titled, formatted list of steps

`explanation do`

  * a titled, formatted block for a summary of what the student just did

`link "name"`

  * links to a step whose file name is `filename`

`next_step "name"`

  * makes a new step named "Next Step:"
  * links to a step whose file name is `filename`

`option "name"`

  * creates a step which is named "Option 1: foo" instead "Step 1: foo"
  * supports nested blocks, which reset the step count again

`insert "filename"`

  * inserts the contents of one file inside another
  * a way to do "partials"
  * current limitations:
    * only works with `.step` files
    * inserted file must be in same directory as inserting file
    * prepends an underscore to the file name

## messages

`message "text"`

  * makes a paragraph of text anywhere in the document
  * the text parameter is passed through a Markdown converter

`important "text"`

  * like a message, but called out in a red box

`tip "name" do`

  * called out in a blue box
  * the name is *not* markdown, but is an optional bold title for the tip box
  * content should be inside a nested block

## special

Special elements do *not* format their text as Markdown.

`console "text"`

  * indicates that the student should type something in the terminal
  * says "type this in the terminal:" and then puts the text in a `pre` block
  * [should this be named `terminal` or `type` instead?]

`result "text"`

  * indicates that the student should see some output in the terminal
  * says "expected result:" and then puts the text in a `pre` block

`verify`

`verify "name"`

  * usually contains `console` and `result` notes
  * kind of like a step, but doesn't increment the number count

`irb "text"`

  * like "console" but indicates that the student should type something into irb


## erector elements

StepFile is an [Erector](https://github.com/erector/erector)-based DSL, so if you want to insert HTML tags or other stuff, use the appropriate Erector methods, e.g.

    step "figure out your OS version" do
      message "Mac OS has code names, including:"
      table do
        tr do
         th "Leopard"
         td "OS X 10.5"
        end
        tr do
         th "Snow Leopard"
         td "OS X 10.6"
        end
      end
    end
