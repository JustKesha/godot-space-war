@icon("uid://c0hhedisi05ok")
class_name Projectile3D
extends Node3D


@onready var movement: MovementComponent3D = %Movement
@onready var mesh: MeshInstance3D = %Mesh
@onready var hitbox: HitComponent3D = %Hitbox


func _on_hitbox_hit(_hurt_component: HurtComponent3D):
	destroy()


func destroy():
	queue_free()
