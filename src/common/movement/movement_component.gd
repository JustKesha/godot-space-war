@icon("uid://boghheyoneo3j")
class_name MovementComponent3D
extends Node


@export var actor: Node3D
@export var speed: float
@export var direction: Vector3 = Vector3.FORWARD
@export var account_for_rotation: bool = true
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
var basis: Basis:
	set(value):
		if not actor:
			push_warning("Trying to access basis on a null actor.")
			return
		if use_global_position:
			actor.global_transform.basis = value
		else:
			actor.transform.basis = value
	get():
		if not actor:
			push_warning("Trying to access basis on a null actor.")
			return Basis.IDENTITY
		if use_global_position:
			return actor.global_transform.basis
		return actor.transform.basis


func _ready():
	if not actor:
		actor = get_parent() as Node3D


func _physics_process(delta: float):
	if not disabled:
		_move(delta)


func _get_next_position(delta: float) -> Vector3:
	return position + speed * delta * get_world_direction()


func _move(delta: float):
	if not actor:
		return
	
	position = _get_next_position(delta)


func get_world_direction() -> Vector3:
	if not actor or not account_for_rotation:
		return direction.normalized()
	
	return (basis * direction).normalized()
