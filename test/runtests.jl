using Composite
using Base.Test


twice  = (+) ∘ dup
@test twice(  3 ) == 6

square = (*) ∘ dup
@test square( 3 ) == 9

twice_square = twice  ∘ square
@test twice_square( 3 ) == 18

square_twice = square ∘ twice
@test square_twice( 3 ) == 36






twice_and_square = twice ^ square
@test twice_and_square( 3 ) == ( 6, 9 )

twice_first_and_square_second  = twice % square
@test twice_first_and_square_second( 3, 4 ) == (6, 16)

add3 = (+) < 3
@test add3() == 3
@test add3( 4 ) == 7

gt3 = (>) > 3
@test ! gt3( 2 )
@test ! gt3( 3 )
@test gt3( 4 )






