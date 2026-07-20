@icon("uid://boghheyoneo3j")
class_name MovementComponent3D
extends Node
## Simple kinematic movement component for [Node3D].
##
## Attach to a [Node3D] to control it's position.


## The target node to move. Defaults to the parent node.
@export var actor: Node3D
## [member actor]'s speed in units per second.
@export var speed: float
## Movement direction (in local space). [br][br][b]Note:[/b] The end movement
## direction is calculated using [method get_world_direction].
@export var direction: Vector3 = Vector3.FORWARD
## If [code]true[/code], [member direction] is relative to the [member actor]'s
## orientation, otherwise it is treated as a static vector in world space.
@export var direction_relative: bool = true
## If [code]true[/code], uses [member actor]'s [member Node3D.global_transform],
## otherwise [member Node3D.transform] (relative to parent).
@export var use_global_transform: bool
## Stops processing movement when [code]true[/code].
@export var disabled: bool

## Proxy interface for accessing and modifying the [member actor]'s position
## based on the active coordinate space (see [member use_global_transform]).
var position: Vector3:
	set(value):
		if not actor:
			push_warning("Trying to access position on a null actor.")
			return
		
		if use_global_transform:
			actor.global_position = value
		else:
			actor.position = value
	get():
		if not actor:
			push_warning("Trying to access position on a null actor.")
			return Vector3.ZERO
		
		return actor.global_position if use_global_transform else actor.position
## Proxy interface for accessing and modifying the [member actor]'s basis
## based on the active coordinate space (see [member use_global_transform]).
var basis: Basis:
	set(value):
		if not actor:
			push_warning("Trying to access basis on a null actor.")
			return
		if use_global_transform:
			actor.global_transform.basis = value
		else:
			actor.transform.basis = value
	get():
		if not actor:
			push_warning("Trying to access basis on a null actor.")
			return Basis.IDENTITY
		if use_global_transform:
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


## Returns normalized movement direction in world space.
func get_world_direction() -> Vector3:
	if not actor or not direction_relative:
		return direction.normalized()
	
	return (basis * direction).normalized()
