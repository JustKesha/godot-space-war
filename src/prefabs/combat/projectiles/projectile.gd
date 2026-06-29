@icon("uid://c0hhedisi05ok")
class_name Projectile3D
extends Node3D


@export var speed: float
@export var direction: Vector3

@onready var mesh: MeshInstance3D = %Mesh
@onready var hitbox: HitComponent3D = %Hitbox


func _physics_process(delta: float):
	_move(delta)


func _on_hitbox_hit(_hurt_component: HurtComponent3D):
	destroy()


func _move(delta: float):
	global_position += direction * delta * speed


func destroy():
	queue_free()
