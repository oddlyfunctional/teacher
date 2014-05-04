# Teacher Language
Flexible language for defining grades calculations.

## How to use
Let's say you have some really complex calculations to do for every student:
there's three exams (e1, e2 and e3), a homework (hw) and a replacement exam 
(re) that replaces the lowest score. The final grade (fg) is given by the
following calculation: ```fg=(3*(2*e1+2*e2+3*e3)/7+hw)/4```.

Example:

| e1  | e2  | e3  | re  | hw  | fg   |
| --- | --- | --- | --- | --- | ---- |
| 8.0 | 6.0 | 4.0 | 6.0 | 6.0 | 6.43 |

How could you describe this problem in a clear, flexible way? Would you 
simply hard-code this particular solution? What if any user of your system 
could create their own arbitrary solution?

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
require 'csv'

teacher = Teacher::Base.new

teacher.run(File.read("example.teacher"))
scope = teacher.scope

CSV.generate do |csv|
  csv << scope.published_variables.keys
  csv << scope.published_variables.values
end

# => e1, e2, e3, hw, re, fg
#    8.0,6.0,4.0,6.0,6.0,6.428571428571429

scope.published_variables # => {"e1"=>8.0,
                          #     "e2"=>6.0,
                          #     "e3"=>4.0,
                          #     "hw"=>6.0,
                          #     "re"=>6.0,
                          #     "fg"=>6.428571428571429}
                          
scope.symbols # => { ...
              #     "e1"=>8.0,
              #     "e2"=>6.0,
              #     "e3"=>6.0,
              #     "hw"=>6.0,
              #     "re"=>6.0,
              #     "smaller"=> Identifier (e3 = 4.0),
              #     "fg"=>6.428571428571429}
```
