#Chess
---------------------
This is a two player chess game with the standard rules (including castling, en passant,
pawn promotion etc). It was built following the TDD mantra.

#Installation
---------------------
With Ruby installed, open the command line, navigate to where you want to store
the file and enter the following:
```
git clone https://github.com/IvyMic/chess.git
cd chess
ruby lib/play_chess.rb

```

##Pre thoughts
---------------------

I'm really excited about this, but I know it is is going to be hard.
There are so many little nuances I have to think about.

Things I'm concerned about:
1) The King. It affects the game in so many different ways
2) Special moves that deviate from the norm.
3) I don't quite know whether to use inheritance or composition for the pieces
4) The pawn, en passant and promotion.
5) castling
6) how to limit moves where there is a piece in between the target destination

Things im confident on:
1) The knight.
2) I've read up on object oriented programming more, and I have a quite good idea
  on how I want to structure this (except for inheritance vs composition)

##Post thoughts
---------------------

This project started well. Having read 'Practical Object-Oriented Design in Ruby'
by S. Metz, I had a pretty good picture in my head and direction on how I wanted
to structure the project. My main take away from the book was abstraction, ensuring
each individual class knew only as much as it should. For example, the pawn class
should have no concept of whether the pawn is in check or not. This methodology
allows for the game to be 'future-proof', which means I can easily add/remove
features.

I knew early on that there would be a lot of repetition with pieces and
to keep my code DRY I would have to use some techniques. I read [a great article](https://medium.com/aviabird/ruby-composition-over-inheritance-3ff786ad9e5d) on composition and why it sometimes should be favoured over inheritance. However,
considering that a pawn is_a piece I decided to go with inheritance. I then also
noticed that a lot of the moves were similar (except for the knight, the awkward pawn,
and the king) and so I decided to create a mixin.

Everything was going well until it came to my check mate function. I need some way
to clone the game state, see if any move could be made, and return to the original
game state if the player was not in check. My original clone, I now know, was not
'deep' enough:

```
a = [1,2]
b = a
a.delete(2)
a
#=> [1]
b
#=> [1]

#but for complex objects, dup wont work either
a = Object.new
def a.foo; :foo end
p a.foo
# => :foo
b = a.dup
p b.foo
# => results in a no method error
```
I found a solution online where you use a trick known as 'Object Marshalling'
where you turn an object into a stream of characters:
`complex_copy = Marshal.load( Marshal.dump(complex) )`.
This seemed to work, when suddenly previous methods of mine (which had passed
comprehensive tests) starting failing. I was so confused, and went over those methods
extensively(all of them looked fine). It turns out that, according to a kind person I asked at a hackathon, because I was using this technique multiple times (and incorrectly), it was caching the results, and so when checking to see if someone was in checkmate I would occasionally get a false positive.

This 'Object Marshalling' technique was new to me and I used it without fully
understanding it, that was bad practice on my part. So I looked around online
and found this [really helpful article](http://thingsaaronmade.com/blog/ruby-shallow-copy-surprise.html). Here,
there is a quote from the G. Brown, author of 'Ruby Best Practices':
>The solution is usually to avoid copying in the first place. Write your functions in such a way that you consciously decide whether or not they should have side effects, and document them as such.

Reading this, I realised I didn't need to clone the game state at all. All I really
wanted to some form of undo function, and so I created one quite simply. This made
everything else easier, and was particularly useful for things like castling.

All in all I am really really proud of this project, I completed my objective and
also learned so much along the way. When trying to debug the cloning problem,
I came across a gem called 'Pry' and although I didn't use it to fix my bug,
I can certainly see its uses and will add it to my debugging toolkit.

Also, I'm particularly proud on how I've set out the structure. This means that,
without too much effort, I can add a simple AI that one could play against. The AI
could make a valid move each turn, or it can even prioritise a killing move etc
etc.


##Things to improve on
---------------------
1) Learn about a technique fully before utilising it.
2) Trust the TDD process.
