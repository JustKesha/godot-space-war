@icon("uid://boghheyoneo3j")
class_name MovementComponent3D
extends Node


@export var actor: Node3D
@export var speed: float
@export var direction: Vector3
@export var use_global_position: bool = true
@export var disabled: bool

var position: Vector3:
	set(value):
		if not actor:
			push_warning("Trying to access position on a null actor.")
			return
		
		if use_global_position:
			actor.global_position = value
		else:
			actor.position = value
	get():
		if not actor:
			push_warning("Trying to access position on a null actor.")
			return Vector3.ZERO
		
		return actor.global_position if use_global_position else actor.position


func _physics_process(delta: float):
	if not disabled:
		_move(delta)


func _get_next_position(delta: float) -> Vector3:
	return position + direction * speed * delta


func _move(delta: float):
	if not actor:
		return
	
	position = _get_next_position(delta)
