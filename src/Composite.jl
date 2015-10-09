"A module for function composition."
module Composite

import Base.call, Base.%, Base.<, Base.>, Base.^


export AbstractCallable, Callable, 
    AbstractCompositionMethod,  SequentialComposition, ConcurrentComposition, CompositeFunction,
    call, ∘, %, <, >, ^, dup


abstract AbstractCallable
typealias Callable Union{AbstractCallable,Function}


abstract AbstractCompositionMethod
abstract SequentialComposition <: AbstractCompositionMethod
abstract ConcurrentComposition <: AbstractCompositionMethod

dup( x ) = ( x, x )

immutable CompositeFunction{ First <: Callable, Second <: Callable, Method <: AbstractCompositionMethod } <: AbstractCallable
    first::First
    second::Second
end

call{ First, Second, Xs }( f::CompositeFunction{First,Second,SequentialComposition }, xs::Xs ... ) = f.first( f.second( xs ... ) ... )
call{ First, Second, X, Xs }( f::CompositeFunction{ First,Second,ConcurrentComposition}, x::X, xs::Xs ... ) = tuple( f.first( x ), f.second( xs ... ) ... )





comp( f, g ) = CompositeFunction{typeof(f),typeof(g),SequentialComposition}( f, g )
comp( f, g, h, hs ... ) = comp( comp( f,  g ), h, hs ... )
∘{ F <: Callable, G <: Callable }( f::F, g::G, hs ... ) = comp( f, g, hs ... )


split( f, g ) = CompositeFunction{typeof(f),typeof(g),ConcurrentComposition}( f, g )
split( f, g, h, hs ... ) = split( split( f, g ), h, hs ... )
%{F<:Callable,G<:Callable}( f::F, g::G, hs ... ) = split( f, g, hs ... )




fan( f, g ) = (f % g ) ∘ dup
fan( f, g , h, hs ... ) = fan( f, fan( g, h, hs ... ))
^{F<:Callable,G<:Callable}( f::F, g::G, hs ... ) = fan( f, g, hs ... )


abstract AbstractPacking
abstract Left <: AbstractPacking
abstract Right <: AbstractPacking

immutable PartialApplication{F <: Callable, Packing <: AbstractPacking} <: AbstractCallable
    callable::F
    args::Tuple
end

call{F}( f::PartialApplication{F,Left}, xs ... ) = f.callable( f.args ..., xs ... )
call{F}( f::PartialApplication{F,Right}, xs ... ) = f.callable( xs ..., f.args ... )

partial{F <: Callable }( f::F, xs ... ) = PartialApplication{F,Left}( f, tuple( xs ... ))
rpartial{F <: Callable }( f::F, xs ... ) = PartialApplication{F,Right}( f, tuple( xs ... ))

<{F <: Callable}( f::F, xs ... ) = partial( f, xs ... )
>{F <: Callable}( f::F, xs ... ) = rpartial( f, xs ... )







end # module
