@abstract
@icon("uid://5x0jp48lvjw7")
class_name CombatantController
extends Node


@export var combatant: Combatant3D
@export var disabled: bool


func _ready():
	if not combatant:
		combatant = get_parent() as Combatant3D
	if not combatant:
		push_warning("Combatant is not selected and not found as parent.")
	
	reset.call_deferred()


func get_movement_direction() -> Vector3:
	return Vector3.ZERO


func get_shooting_state() -> bool:
	return false


func update_movement_direction():
	if combatant:
		combatant.movement.direction = get_movement_direction()


func update_shooting_state():
	if combatant:
		combatant.gun.auto_shoot = get_shooting_state()


func update():
	update_movement_direction()
	update_shooting_state()


func reset():
	if combatant:
		combatant.movement.direction = Vector3.ZERO
		combatant.gun.auto_shoot = false
