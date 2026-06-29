@icon("uid://c0hhedisi05ok")
class_name Projectile3D
extends Node3D


@export var destroy_on_hit: bool = true

@onready var movement: MovementComponent3D = %Movement
@onready var mesh: MeshInstance3D = %Mesh
@onready var hitbox: HitComponent3D = %Hitbox
@onready var hitbox_collider: CollisionShape3D = %Hitbox/Collider
@onready var hurtbox: HurtComponent3D = %Hurtbox
@onready var hurtbox_collider: CollisionShape3D = %Hurtbox/Collider

var team: CombatArea3D.Team:
	get():
		if hitbox: return hitbox.team
		if hurtbox: return hurtbox.team
		push_warning("Trying to access team on a null hitbox/hurtbox.")
		return CombatArea3D.Team.Neutral
	set(value):
		if not hitbox and not hitbox:
			push_warning("Trying to access team on a null hitbox/hurtbox.")
			return
		if hitbox: hitbox.team = value
		if hurtbox: hurtbox.team = value


func _on_hitbox_hit(_hurt_component: HurtComponent3D):
	if destroy_on_hit: destroy()


func _on_hurtbox_damage_taken(_amount: float, _source: HitComponent3D):
	destroy()


func destroy():
	queue_free()
