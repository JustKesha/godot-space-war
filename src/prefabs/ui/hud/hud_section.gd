@icon("uid://deu2pgbsv51jr")
@abstract
class_name HUDSection
extends Control


signal updated

@export var start_visibility: bool = true
@export_group("Update", "update")
@export var update_while_hidden: bool
@export var update_on_ready: bool = true
@export var update_on_visibility_changed: bool = true
@export var update_on_interval_sec: float = -1

var time_since_update: float:
	set(value):
		if value == time_since_update:
			return
		time_since_update = value
		if( update_on_interval_sec >= 0.0
			and time_since_update >= update_on_interval_sec ):
			update()


func _ready():
	visible = start_visibility
	if update_on_ready:
		update()
	visibility_changed.connect(_on_visibility_changed)


func _process(delta: float):
	if is_visible_in_tree():
		time_since_update += delta


func _on_visibility_changed():
	if update_on_visibility_changed:
		update()


func _on_updated():
	pass


func can_update() -> bool:
	if not update_while_hidden and not is_visible_in_tree():
		return false
	return is_inside_tree() and is_instance_valid(Game.current_level)


func update():
	if not can_update():
		return
	time_since_update = 0.0
	_on_updated()
	updated.emit()
	print('HUD SECTION UPDATED: ', name)
