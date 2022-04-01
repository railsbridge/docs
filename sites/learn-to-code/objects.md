<!-- next_step "strings" -->

# Objects

An OBJECT is a location in computer memory where you can store DATA (aka VALUES).

There are many kinds of objects, including String, Number, Array, Hash, Time, ... 

(The different kinds of objects are called CLASSES or TYPES. Some day soon you will create your own classes but for now, we will use the built-in ones.)

# Numbers

A NUMBER is what it sounds like.

    10
    -12
    3.14

# Strings

A STRING is an object that's a collection of characters, like a word or a sentence.

    "apple"
    "banana"
    "Cherry Pie"

# Messages and Operators

An object responds to MESSAGES. You send it messages using OPERATORS.

The most powerful operator is DOT. 

On screen she looks like this...

    .

# Dot up close

...but here's what she looks like up close:

![picture of Dot the Operator](img/dot.jpg)

# Dot's job

Dot can send any message she likes, by name, to any object.

    "apple".upcase

The `upcase` message turns `"apple"` into `"APPLE"`.
    
# Other Operators

There are other operators, like PLUS (`+`) and TIMES (`*`), but they only send one message each.

And remember, Dot is more powerful than any other operator!

    2 + 7

is the same as

    2.+ 7

Both send the message `+` to the object `2`.

# Return Values

Every time an object receives a message, it returns a response.

The response is also called the VALUE or the RETURN VALUE.

You can think of it as the answer to a question. 

    2 + 2    # Question: What is 2 + 2?
    4        # Answer: 4

    "apple".upcase  
    # Q: What is the upcase of the string "apple"?
    
    "APPLE"         
    # A: the string "APPLE"

