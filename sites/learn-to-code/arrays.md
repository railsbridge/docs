<!-- next_step "argv" -->

# Arrays

* An ARRAY is a CONTAINER
  * an object that contains other objects
* It's a list of objects

# What makes an array an array

* You can put any objects inside it
* In any order
* They stay in order
* Duplicates are fine

# Creating an array

    ["apple", "banana", "cherry"]

# Array Indexes

* Every slot in the array has a serial number
* You can retrieve any item in an array by its INDEX
* An index is a number from 0 to infinity
  * actually to the size of the array

# Array Indexes Exercise

Try this in IRB:

    fruits = ["apple", "banana", "cherry"]
    fruits[1]

Did you get the result you expected?

Why or why not?

# Start At Zero

When counting, 

humans start at one, 

but **computers start at zero**.

So the first item in an array is number zero, not number one.

# The End

Try this:

    fruits[99]

Did you get the result you expected?

Why or why not?

# Array Methods

    fruits.last
    fruits.first
    fruits.reverse
    fruits.shuffle

# Turning an array into a string

    fruits.join
    fruits.join(" and ")

Note that `to_s` doesn't work right on arrays:

    fruits.to_s
    puts fruits.to_s

# Looping through an array

    fruits.each do |fruit|
      puts fruit
    end

* `each` is like `while` for arrays
* `fruits.each do` means "for each item inside this array, do this"
* `|fruit|` means "put the current item into a variable named `fruit`"
* `puts fruit` means "print out the value of this variable"
* `end` means "we're done with the loop now" :-)

# Lab: reverse fruit

Given this array:

    fruits = ["apple", "banana", "cherry"]

write a program that prints:

    yrrehc
    ananab
    elppa

# Setting items in an array

The `[]` operator works for assignment as well.

    fruits[0] = "Apricot"
    fruits[1] = "Blueberry"

    puts fruits.first

# Checking an array

The `include?` method checks if an object is inside an array or not.

    fruits.include? "apple"
    true
    
    fruits.include? "pizza"
    false

# LAB: enemies list refactoring

I'd like you to **refactor** your old `hello.rb` program to use the `include?` method to check if someone is your enemy.

# TODO: more array labs




