@icon("uid://c0hhedisi05ok")
class_name Projectile3D
extends Node3D


@export var team: CombatArea3D.Team:
	set(value):
		team = value
		if is_node_ready():
			_update_team()
		else:
			_update_team.call_deferred()
@export var destroy_on_hit: bool = true

@onready var movement: MovementComponent3D = %Movement
@onready var mesh: MeshInstance3D = %Mesh
@onready var hitbox: HitComponent3D = %Hitbox
@onready var hitbox_collider: CollisionShape3D = %Hitbox/Collider
@onready var hurtbox: HurtComponent3D = %Hurtbox
@onready var hurtbox_collider: CollisionShape3D = %Hurtbox/Collider


func _on_hitbox_hit(_hurt_component: HurtComponent3D):
	if destroy_on_hit: destroy()


func _on_hurtbox_damage_taken(_amount: float, _source: HitComponent3D):
	destroy()


func _update_team():
	if hitbox: hitbox.team = team
	if hurtbox: hurtbox.team = team


func apply_preset(preset: ProjectilePreset3D):
	if preset:
		preset.apply(self)


func destroy():
	queue_free()
