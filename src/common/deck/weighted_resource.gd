@icon("uid://dvlkiys0peqr7")
class_name WeightedResource
extends Resource
## Generic data container that pairs an asset with a numerical generation weight.
##
## Used by queue systems to determine the frequency and appearance order of elements.


## The relative frequency multiplier of this element within a generation pool.
@export var weight: int
## The underlying resource data being wrapped.
@export var value: Resource
