<!-- next_step "sinatra" -->

# Functions

* just like a VARIABLE is a name for a chunk of data
* a FUNCTION is a name for a chunk of code
* if you have some code you want to run again and again
  * or just run once, but keep it organized

# For example

Here's a silly function:

    def add x, y
      x + y
    end

* `def` means "define a function"
* `add` is the *name* of the function
* `x, y` are the *parameters* of the function
* `x + y` is the *body* of the function
  * also the *return value*

Lab: write a `multiply` method and use it to multiply 123 * 456

# Rant!!!

    def rant s
      s.upcase.gsub(" ", "") + "!!!"
    end

    puts rant "i like pizza"

Lab: use "rant" to rant about something really important!!!

# Capitalize Just The First Character

    def initial_cap s
      s[0] + s[1,s.length]
    end

    puts initial_cap("smith")
    puts initial_cap("deniro")

Lab: capitalize a few things

# Titleize

    def titleize string
      string.split(' ').map(&:capitalize).join(' ')
    end

* The funny `&:` means "send this message"
* `map(&:capitalize)` means "send the message `capitalize` to every item in the array"

# LAB: titleize your favorite movies


