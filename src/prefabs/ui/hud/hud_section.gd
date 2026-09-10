@icon("uid://deu2pgbsv51jr")
@abstract
class_name HUDSection
extends Control


signal updated

@export var start_visibility: bool = true
@export_group("Update", "update")
@export var update_on_ready: bool = true
@export var update_on_visibility_changed: bool = true


func _ready():
	visible = start_visibility
	if update_on_ready:
		update()
	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed():
	if update_on_visibility_changed:
		update()


func _on_updated():
	pass


func update():
	if not is_inside_tree() or not is_instance_valid(Game.current_level):
		return
	_on_updated()
	updated.emit()
