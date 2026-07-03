@icon("uid://dvlkiys0peqr7")
class_name WeightedResource
extends Resource
## Generic data container that pairs an asset with a numerical generation weight.
##
## Used by queue systems to determine the frequency and appearance order of elements.


## The relative frequency multiplier of this element within a generation pool.
@export var weight: int = 1:
	set(value):
		if weight == value:
			return
		weight = value
		_on_changed()
## The underlying resource data being wrapped.
@export var value: Resource:
	set(v):
		if value and value.changed.is_connected(_on_changed):
			value.changed.disconnect(_on_changed)
		value = v
		if value and not value.changed.is_connected(_on_changed):
			value.changed.connect(_on_changed)
		_on_changed()


func _on_changed():
	changed.emit()
