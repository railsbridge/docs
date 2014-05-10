<!-- next_step "variables" -->

# Numbers

The following operations work on numbers:

  * + -- addition
  * - -- subtraction
  * * -- multiplication
  * / -- division
  * % -- modulus
  * ** -- exponentiation

# LAB: Playing With Numbers

Answer the following questions using irb:

* How many seconds are in an hour?
* How many minutes are in a week?
* How many seconds old are you?
* How many years old is someone who is 1 billion seconds old?

# Order of operations

Q: What is 1 plus 2 times 3?

# Order of operations

Q: What is 1 plus 2 times 3?

A: *It depends!*

  * `(1 + 2) * 3` is 9
  * `1 + (2 * 3)` is 7

# Parentheses Are Free

When in doubt, use parentheses!

# Strings vs. Numbers

Hmmm....

    1 + 2
    "1" + "2"
    "1 + 2"

# Strings plus Numbers

Hmmm again...

    "1" + 2

Uh-oh!

    TypeError: can't convert Fixnum into String

The problem is that Strings and Numbers are different TYPES, aka different CLASSES.

Don't panic! The solution is easy.

# Type Conversion

Numbers know a message that converts them into strings. `to_s` means "to string".

    "1" + 2.to_s

Likewise, strings know a message that converts them into numbers.

    1 + "2".to_i

`to_i` means "to integer".

Try this in irb!

# Advanced Number Theory (optional)

# WTFixnum?

The error said `can't convert Fixnum into String`.

Q: What is a Fixnum?

A: It's one type of number.

# Math is hard

There are many types of numbers!

Each is useful in different situations.

Without getting into too much detail, the two main number types in Ruby are:

* `Fixnum` - for *integers* like 12 or -1023
* `Float` - for *decimals* like 3.14

(Other number types include Complex, Rational, and Bignum.)

# Number to Number

You can convert from one type of number to another by sending a message:

* `to_i` turns a Float into a Fixnum
* `to_f` turns a Fixnum into a Float

Try this:

    3.to_f
    3.14.to_i

# String to Number

`to_f` and `to_i` also work on Strings:

    "3.14".to_f
    "3.14".to_i

and `to_s` works on numbers:

    3.14.to_s

# Arithmetic

Try this in irb:

    1 + 2
    3 - 4
    5 * 6
    7 / 8

Whoa! What just happened?

# Integer Arithmetic

7 and 8 are *Integers*

so the result is an Integer

7/8 is somewhere between 0 and 1

but there is no integer between 0 and 1

so the computer has to *round down* to 0

# Floating Point Arithmetic

    7.0/8.0

7.0 and 8.0 are *Floats*

so the result is a Float

and `0.875` can fit in a float

# Okay, that's enough math!

