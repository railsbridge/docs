!SLIDE subsection
# Ruby Programming for Beginners

!SLIDE
## Language/Library/Framework

A **language** is a set of code that can be used to create an application.

* Ruby, Java, C/C++, etc.

A **library** is a collection of resuable code to accomplish a generic activity.

* Gems: XML parser, spell checker, etc.

A **framework** is collection of resuable code to facilitate development of a particular product or solution.

* Ruby on Rails, Zend Framework (PHP), ASP.Net (C#), etc.

<!SLIDE subsection incremental>
## Ruby Philosophy

```
I believe people want to express themselves when they program.
  
They don't want to fight with the language.

Programming languages must feel natural to programmers.

I tried to make people enjoy programming and concentrate on the fun and creative part of programming when they use Ruby.
```
 -- [Matz](http://linuxdevcenter.com/pub/a/linux/2001/11/29/ruby.html) (Yukihiro Matsumoto), Ruby creator

!SLIDE bullets
## The Ruby Language

Ruby is a **interpreted language**.

  * Don't require a compiler.
  * Run "on the fly" (via a **interpreter**)
  * Easy to change frequently

Other interpreted languages include **Python**, **Perl**, and **JavaScript**.

!SLIDE centereverything

!SLIDE subsection

# Let's start coding!

!SLIDE bullets
## Open Your Terminal

* Windows: **git bash** ![](img/git_bash.png)
* Mac: **Terminal.app** ![](img/mac_terminal_sm.png)
* Ubuntu/Linux: **Terminal**, **xterm**, etc.

!SLIDE
## Prompt

* Terminals show a line of text when you login & after a command finishes
* It's called the `prompt`, and customarily ends with a dollar sign

Whenever instructions start with `"$ "`, type the rest of the line into terminal.

Let's give the terminal a `command`, to open Interactive Ruby (IRB)

```bash
  $ irb
```

!SLIDE commandline
## irb: Interactive Ruby

IRB has its own prompt, which customarily ends with `>`

```
  $ irb
  >
```

You can use `Control-D` to exit IRB any time.
Or type `exit` on its own line.

```ruby
  > exit
  $ 
```

Now you're back to the terminal's prompt.

    Windows Users! Some people have experienced trouble with backspace, delete, and arrow keys working properly in irb - what a pain! If you run into this problem, use this command instead to launch irb.

    $ irb --noreadline

!SLIDE
## Variables

* A variable holds information.
* We give it a name so we can refer to it
* The info it holds can be changed

```
  $ irb
  > my_variable = 5
  => 5
  > another_variable = "hi"
  => "hi"
  > my_variable = 10
  => 10
```

Giving a variable value via the `=` sign is called **assignment**. In the above examples, we are assigning `my_variable` to `5` and `my_other_variable` to `"hi"`.

!SLIDE
## Variables
### Variable Assignment

Variables are assigned using a single equals sign (`=`).

The **right side** of the equals sign is evaluated first, then the value is assigned to the variable named on the **left side** of the equal sign.

```ruby
  apples = 5
  bananas = 10 + 5
  fruits = 2 + apples + bananas
  bananas = fruits - apples
```

!SLIDE !bullets
## Variables
### Variable Naming

Create a variable whose name has:

* all letters (like 'folders')

* all numbers like '2000'

* an underscore (like `first_name`)
  
* a dash (like 'last-name')
  
* a number anywhere (like `y2k`)

* a number at the start (like '101dalmations')

* a number at the end  (like 'starwars2')

What did you learn?


!SLIDE bullets
## Data types

Variables can hold many types of information, including:

* String (`"Parturient Purus"`, `'Adipiscing Mollis Tellus'`)
* Numbers (integer/float; `1`, `1.5`)
* Boolean (`true`/`false`)
* Object (Collection, etc.)

!SLIDE bullets
## Data types
### String

A string is text. It must be wrapped in a matched pair of quotation marks.

```ruby
  $ irb
  > 'Single quotes work'
  => "Single quotes work"
  > "Double quotes work"
  => "Double quotes work"
  > "Start and end have to match'
  ">
```
  
What is happening on the last two lines?  How would you solve it?


### exercise
* Create variables called first_name, last_name, and favorite_color.
* Assign the variables to strings.

!SLIDE
## Data types
### Numbers

Numbers without decimal points are called **integers** and numbers with decimal points are called **floats**.

Examples of integers:	

* 0
* -105
* 898989898
* 2

Examples of floats:	

* .0.0
* -105.56
* .33
* .00004

You can perform operations on both types of numbers with these characters: +, -, /, *
	
### exercises	
* Try dividing an integer by an integer. Try dividing an integer by a float. How are the results different? 
* Create two integer variables called num1 and num2 and assign them your favorite numbers.
* Next, compute the sum, difference, quotient, and product of these two numbers and assign these values to variables called sum, difference, quotient, and product, respectively.

!SLIDE
## Data types
### Boolean

A boolean is one of only two possible values: `true` or `false`.

```
  > 1 + 1 == 2
  => true
  > 1 + 1 == 0
  => false
```

( `==` means "is equal to". _More on that later._)

### exercises 
* Create a variable named favorite_color and assign it to your favorite color.
* Create a variable named not_favorite_color and assign it to a different color.
* Test to see if these variables are equal.

!SLIDE
## Operators

Operators are used to manipulate variables and values.

    > my_variable = 5
    => 5
    > my_variable + 2
    => 7
    > my_variable * 3
    => 15

    > string_one = "this is a string."
    => "this is a string."
    > string_two = " this is also a string."
    => " this is also a string."
    > string_one + string_two
    => "this is a string. this is also a string."

### exercises 

* Create variables for your **first name** and **last name** as well as **favorite colour**
* Print out a sentence that reads "Hi, my name is (first name) (last name) and my favorite color is (favorite color)."
* Extra: string concatenation with `#{}` 

!SLIDE
## Conditionals

Do something only if a condition is true

    > age = 15
    => 15
    > if age >= 12
    ?> puts "teenager!"
    ?> end
    => "teenager!"

... or **else**

    > if age >= 12
    ?> puts "teenager!"
    ?> else
    ?> puts "child!"
    ?> end

!SLIDE
## Loop

Repeately do something a certain number of times

    > 3.times do
    ?> puts "hello"
    ?> end
    "hello"
    "hello"
    "hello"
    => 3

### exercises

* Create a loop that counts from `0` to `10`
* Hint: use a variable

!SLIDE
## Collection
### Array

An array is a list.

Array is defined between **square brackets** (`[`, `]`). A comma separates each **element**.

    > fruits = ["kiwi", "strawberry", "plum"]
    => ["kiwi", "strawberry", "plum"]

### exercises	
* Make your own array and name it `grocery_list`.
* Include at least 5 items from your grocery list in the array.

!SLIDE
## Collection
### Array
#### Indexing

Elements of an array are stored in order. Each can be accessed by its `index`. In programming, array index **start at 0**.

    > fruits[0]
    => "kiwi"
    > fruits[1]
    => "strawberry"
    > fruits[2]
    => "plum"

### exercises	

* Use your `grocery_list` from previous exercises
* Print out the element at index 0, 3, and 5

!SLIDE
## Collection
### Hash

Hash is defined between **curly braces** (`{`, `}`). A comma separates each **entry**. A entry is consist of a **key** and a **value**, separated by a "arrow" (`=>`).

    > provinces = { "BC" => "British Columbia", "AB" => "Alberta" }
    => {"BC"=>"British Columbia", "AB"=>"Alberta"}

Hash is alos known as **dictionary** or **associative array**. The keys within a hash must be unique.

### exercises

* Create a hash for all of Canadian provinces

!SLIDE
## Collection 
### Hash
#### Hash Access

Entries in a hash can be accessed by their key:

    > provinces["AB"]
    => "Alberta"

### exercises

* Try assigning a different value to an existing entry
* Try assigning a value to an non-existing entry

!SLIDE
## Methods

A **method** is a sequence of instructions that accomplishes a specific purpose.

The act of getting the method to perform its job is call **invoking** (or **calling**) it. Some methods **returns** a value:

    secret = rand()

Some methods while does not return anything, perform other functions instead:

    puts(secret)

Method is a great way of collecting useful sets of instructions and reuse them later.

Method is defined between `def` and `end`:

    def say_something()
      puts("Hello World!")
    end

To call the methods:

    say_something()

### exercises

* Create a method that prints "Hi, my name is (my name)."

!SLIDE
## Methods
### Method Parameters

The build-in `puts` method accepts a **parameter**. A parameter is a piece of information **passed into** the method.

To define a methods that accept a parameter:

    def say_text(input)
        puts(input)
    end

Additional parameters are separated by comma (`,`):

    def say_two_things(input1, input2)
        puts(input1)
        puts(input2)
    end

Inside the method, parameters are just like variables.

### exercises

* Create a method that takes a `name` parameter and prints "Hi, my name is (the name parameter)."

!SLIDE
## Methods
### Method Return

A method can optionally **return** something. The build-int `rand` method returns a random number between 0 and 1. When a method returns, its execution is also terminated. What the method returns is called the **return value** of a method.

To return from a method:

    def hello()
      return "Hello World!"
    end
    
    def age()
      return 28
    end
    
    def weight(age)
      if age < 10
        return 5
      else
        return 10
      end
    end

The return value can be assigned, and used just like any other values:

    my_text = hello()
    my_age = age()

!SLIDE
## Objects

An **object** is a entity that contains **attributes** and **methods**. The attributes of an object describe its properties, and the methods of an object describe the actions the object can perform.

We interact with objects via the **dot notation**. For example:

    puts plane.altitude
    plane.call_sign = "oceanic 815"
    plane.take_off()

!SLIDE
## Objects
### Objects in Ruby

All the data-types in Ruby are objects.

**Array** (http://www.ruby-doc.org/core-1.9.3/Array.html)

    [7,1,0,3,4].length
    [1,2,3].concat([4,5,6])
    [1,2,8,3,6,3,1,9,8].uniq.sort

**Hash** (http://www.ruby-doc.org/core-1.9.3/Hash.html)

    { name: "Billy", age: 27 }.empty?

**String** (http://www.ruby-doc.org/core-1.9.3/String.html)

    "My Name is ".concat("Billy")

**Integer** (http://www.ruby-doc.org/core-1.9.3/Integer.html)

    13.even?

!SLIDE
## Class

A **class** is the blueprint that we use to create objects. An object created from a class is called a **instance** of that class.

A class is defined between `class` and `end`:

    class Plane
      attr_accessor :altitude
      attr_accessor :call_sign
      
      def take_off
        puts "#{self.call_sign} is taking off"
      end
      
      def land
        puts "#{self.call_sign} is landing"
      end
      
      def report
        puts "Current altitude: #{self.altitude}"
      end
    end

In the above example:

* The class is called "Plane"
* A "Plane" has two properties: `altitude` and `call_sign`
* A "Plane" can `take_off`, `land`, and `report`

To actually create a "Plane":

    plane1 = Plane.new
    plane1.altitude = 500
    plane1.call_sign = "oceanic 815"
    plane1.take_off

!SLIDE
## Class
### Inheritance

Inheritance is the mean by which one class extends the functionalities/properties of another. The class the new class is based on is called the **parent**, and the new class is called the **child**.

The child has all the attributes and methods of its parent, as well as any additional attributes and methods that the child defines. The parent on the other hand, does not gain any additional attributes and methods from its child.

Inheritance is achieved with the `<` symbol:

    class Jet < Plane
      attr_accessor :weapon
      
      def fire
        puts "#{self.call_sign} is firing #{self.weapon}"
      end
    end
    
    plane2 = Jet.new
    plane2.weapon = "guns"
    plane2.altitude = 6000
    plane2.call_sign = "Maverick"
    plane2.report

!SLIDE
# Running Your Code

!SLIDE subsection
## Interpreter

Ruby is an interpreted language. Its code can't run by the computer directly.  It first must go through a Ruby interpreter.

The most common interpreter is Matz's Ruby Interpreter ("MRI").  There are many others.

There are various ways to run code through a Ruby interpreter. We were using IRB earlier and now we will use a file.

!SLIDE
## Running code from a file
### Create the file

* Why use a file? What's different from, say, irb?

Note which folder your terminal is currently in, this is your `working directory`

In your text editor, create a file named `hello.rb` inside your working directory.

    puts "Hello, World!"

## Running code from a file
### Run the saved code

We can tell the ruby interpreter to run our code:

    $ ruby hello.rb
    Hello World!

## Running code from a file
### Commandline Arguments (ARGV)

The `ARGV` variable is a special array that's available to the script when it's run from the commandline.

Change your code to:

    puts "Hello, #{ARGV.first}!"

... and run it:

    $ ruby hello.rb Alice
    Hello, Alice!

### exercises

* What happen if you now run your script without a argument?
* What can you do to make you script work both with and without argument?

!SLIDE
# Let's Create Projects!

!SLIDE
## Project 1:
### [Personal Chef Lab](http://tutorials.jumpstartlab.com/projects/ruby_in_100_minutes.html)
_(start at "4. Objects, Attributes, and Methods")_

Topics:

* Commandline program. Practice in Ruby syntax and OOP concepts, and creating commandline programs.

* Explore strings: concatenation, manipulation, interpolation, coersion.

* Symbols, nil, basic math operators, blocks, method chaining, passing parameters to methods, iteration, branching, conditionals & conditional looping.

!SLIDE
## Project 2:
### [Encryptor Lab](http://tutorials.jumpstartlab.com/projects/encryptor.html)

Topics:

* Commandline program.  Reinforce skills learned in Personal Chef.

* Explore how to manipulate arrays, do more elaborate strings manipulations, refactor code, take advantage of character mapping, and  access the filesystem from within code.


!SLIDE
## Project 3:
### [Event Manager Lab](http://tutorials.jumpstartlab.com/projects/eventmanager.html)

Topics:

* Commandline program. Reusing others code & data, refactoring your own code & cleaning up data, writing custom code to solve requirements.

* Gems, `initialize` method, parameters, file input/output, processing/sanitizing data, looping, conditional branching, using file-based data storage (CSV, XML, JSON), accessing an external API, nils, DRY principle, constants, sort_by, more string manipulations.


!SLIDE
## Project 4:
### Testing & More

A follow-up to EventManager focusing more on Ruby object decomposition and working with Command Line Interfaces and program control flow.

4. [Testing](http://tutorials.jumpstartlab.com/topics/internal_testing/rspec_and_bdd.html) Topics: TDD, BDD, Rspec
_(stop at "Exceptions")_
4. [Event Reporter Lab](http://tutorials.jumpstartlab.com/projects/event_reporter.html) Topics: Object decomposition, working with Command Line Interfaces, and program control flow. Continues project created in Event Manager lab.

6. [Rspec](http://tutorials.jumpstartlab.com/topics/internal_testing/rspec_practices.html )
