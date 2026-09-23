@icon("uid://c8bfxibyer3dt")
class_name EntityBarrier3D
extends Area3D


func _ready():
	self.area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D):
	if area is Entity3D:
		handle_entity_entered(area as Entity3D)


func handle_entity_entered(entity: Entity3D):
	if is_instance_valid(entity):
		entity.destroy()
