# Reflections on Advent of Code & Julia

## Day 4

Different approaches you could take to each exercise.

- parsimonious built-in code for achieving a fast result for the problem
- robust functions for modularity and composability


Frustrations w/ my own performance

- data management in Julia; so much of the exercise is just figuring out what data type I should be working with, converting between data types, and so on. 
  It leaves less room to enjoy the built-in tools of the language on its own terms.
  Or should I just be converting more problems into data structures that the language is good for, not data structures that the problem calls for...? (This is the answer.)


## Day 4:

- we want each function to be only responsible for itself, 
  but the recursion made it so that we needed to manage some state
- ordinarily I think recursive functions will call themselves until their _return values_
  satisfy some condition, not until their arguments do.
  When it's the arguments, you end up with mutated data that you either need to copy
  or deal with in some other way.
