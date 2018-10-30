<!-- next_step "hashes" -->

# ARGV

There is a magic array named `ARGV`. 

It contains the *command line arguments* to the program.

If the user types:

    ruby hello.rb Alice Bob

then ARGV contains:

    ["Alice", "Bob"]

# Why ARGV?

ARGV is a historical name. It means "Argument Vector" and has been around since the early 1970s.

# Command-Line Hello

Change `hello.rb` to contain:

    puts "Hello, " + ARGV[0]

and run it a few times, e.g.

    ruby hello.rb Alice

# LAB: Hello, Everyone!

Change `hello.rb` to say hello to *every one* of its command line arguments.

For instance:

    ruby hello.rb Alice Bob Charlie
    Hello, Alice!
    Hello, Bob!
    Hello, Charlie!

# LAB: Add

Write a program named `add.rb` that adds all of its command line arguments together.

e.g.

    ruby add.rb 1 2 3
    6

Do you remember how to convert a string to an integer?



