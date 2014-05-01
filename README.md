# Teacher Language
Flexible language for defining grades calculations.

## How to use
Let's say you have three exams (e1, e2 and e3), a replacement exam (re)
that replaces the lowest score and a homework (hw). The final grade (fg)
is given by the following calculation: ```fg=(3*(2*e1+2*e2+3*e3)/7+hw)/4```.

Example:

| e1  | e2  | e3  | re  | hw  | fg   |
| --- | --- | --- | --- | --- | ---- |
| 8.0 | 6.0 | 4.0 | 6.0 | 6.0 | 6.43 |

How can you describe this problem?

Consider the following code:
```
# Assign values to variables
e1=8
e2=6
e3=4
hw=6
re=6

# Publish these variables
pub(e1)
pub(e2)
pub(e3)
pub(hw)
pub(re)

# Returns the smaller expression *in a symbolic way*
smaller=min(e1,e2,e3)

# Substitute the *variable* on the left by the right one
# *ONLY* expressions that return identifiers should be 
# used on the left side
sub(smaller,re)

# Calculate the final grade
fg=(3*(2*e1+2*e2+3*e3)/7+hw)/4
pub(fg)
```

Interpreting the language:
```
require 'teacher'

teacher = Teacher::Base.new

teacher.run(File.read("example.teacher"))
scope = teacher.scope

scope.published_variables["e1"] # => 8.0
scope.symbols["e1"] # => 8.0

scope.published_variables["e2"] # => 6.0
scope.symbols["e2"] # => 6.0

scope.published_variables["e3"] # => 4.0
scope.symbols["e3"] # => 4.0

scope.published_variables["hw"] # => 6.0
scope.symbols["hw"] # => 6.0

scope.published_variables["re"] # => 6.0
scope.symbols["re"] # => 6.0

scope.symbols["smaller"] # => identificador "e3"

scope.published_variables["fg"] # => 6.428571428571429
scope.symbols["fg"] # => 6.428571428571429
```
