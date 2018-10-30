<!-- next_step "the_command_line" -->

# Nil

*nil* is a magic object

# There Is No Spoon

![](img/spoon.jpg)

*nil* is the object that means "there is no object"

# Experiment

    fruit = "apple"
    fruit = nil
    fruit.reverse

*Read the error!*

# Errors are good

They tell you

* you made a mistake
* what that mistake was
* (sometimes) how to fix it

Interpret this error:

    fruit.reverse
    NoMethodError: undefined method `reverse' for nil:NilClass

# Fail Fast, Fail Often

* Ruby has a "fail fast" philosophy
* Is this a good idea?
* Why or why not?


