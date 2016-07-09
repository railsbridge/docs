<!-- next_step "logic" -->

# Input and Output

* Computers have many senses -- keyboard, mouse, network card, digital camera, etc. Collectively, these are called INPUT.

* Computers can also express themselves in many ways -- text, graphics, sound, network, printers, etc. Collectively, these are called OUTPUT.

* Input and Output together are called **I/O**.

# Terminal I/O

* In Ruby, 
    * `puts` means "print a line to the terminal"
    * `gets` means "read a line from the terminal"

* `gets` reads all the characters from the keyboard and puts them into a new string, until you press RETURN

# LAB: Hello, friend!

1. Open `hello.rb` in your text editor
2. Change it to contain the following code:

        puts "What is your name?"
        name = gets
        puts "Hello, " + name + "!"

3. Save the file and switch back to the terminal
4. Run the program using `ruby hello.rb`
5. Type in your name and press the RETURN (or ENTER) key

What happens? Is this what you expected?

# Yikes!

* Uh-oh! We've got trouble... what is that exclamation point doing way down there?

* The first thing to do is DON'T PANIC!
* You are *totally* going to figure this out.
* And even if you don't, you haven't actually broken anything.
* In fact, it's really hard to break a computer, so just stay calm.

# Breathe

* In through the nose...
* Out through the mouth...
* In through the nose...
* Ahhhhhhhh.

# Let's fix this

* Have you figured out what the problem is?
* If not, I'll tell you on the next slide.
* Take a second and try to figure it out first. I'll wait.

# The newline character

* Here's a fun fact:
* In addition to letters, numbers, and punctuation, computers also store other keys inside strings
* Among these CONTROL CHARACTERS is the one that represents the RETURN KEY
* This character's name is NEWLINE
* Every time you use `gets`, Ruby reads *all* the characters, *including the newline*!

# Strip it

* Fortunately, there's an easy fix
* If you send the message `strip` to a string, it will remove all SPACES and NEWLINES from both ends

# LAB: fixing Hello, Friend

* Change the program to look like this:

        puts "What is your name?"
        name = gets.strip
        puts "Hello, " + name + "!"

* Run it and make sure it works OK

# LAB: Capitalization

* What happens if you type your name in all lowercase?
* Make the program capitalize your name for you even if you forget.

# LAB: Crazy Name

* Now go crazy and make it do all sorts of silly things to your name!

# LAB: Full Name

* Write a program named `name.rb` that asks two things:
  1. Your first name
  2. Your last name
* Then it says hello to the user by her *full name*.
* Run the program by typing `ruby name.rb` on the command line.

# CONGRATULATIONS!

> You just wrote a program!

You are now officially a coder. HIGH FIVE!

# Lab: Name Length

* Change `name.rb` so it also prints the number of characters in the user's name.
* For instance:

        What is your first name?
        Alex
        What is your last name?
        Chaffee
        Hello, Alex Chaffee! 
        Your name is 11 characters long.


