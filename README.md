# Grade Calculator
Flexible language for defining grades calculations.

## How to use
Consider the following input:
```
# Assign values to variables
e1=8
e2=6
e3=4
t=6
re=6

# Publish these variables
pub(e1)
pub(e2)
pub(e3)
pub(t)
pub(re)

# Returns the smaller expression *in a symbolic way*
smaller=min(e1,e2,e3)

# Substitute the *variable* on the left by the right one
# *ONLY* expressions that return identifiers should be 
# used on the left side
sub(smaller,re)

# Calculate the final grade
fg=(3*(2*e1+2*e2+3*e3)/7+t)/4
pub(fg)
```

Parsing:
```
parser = GradeCalculatorParser.new
scope = TopLevel.new

parser.parse(input).eval(scope)

scope.published_variables["e1"] # => 8.0
scope.symbols["e1"] # => 8.0

scope.published_variables["e2"] # => 6.0
scope.symbols["e2"] # => 6.0

scope.published_variables["e3"] # => 4.0
scope.symbols["e3"] # => 4.0

scope.published_variables["t"] # => 6.0
scope.symbols["t"] # => 6.0

scope.published_variables["re"] # => 6.0
scope.symbols["re"] # => 6.0

scope.symbols["smaller"] # => identificador "e3"

scope.published_variables["fg"] # => 6.428571428571429
scope.symbols["fg"] # => 6.428571428571429
```
