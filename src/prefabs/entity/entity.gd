@icon("uid://u45ctku6sbsn")
class_name Entity3D
extends Node3D


signal team_changed
signal destroyed

@export var team: CombatArea3D.Team:
	set(value):
		var team_old := team
		team = value
		if is_node_ready():
			_update_team()
		else:
			_update_team.call_deferred()
		if team != team_old:
			team_changed.emit()
@export_group("Self Destruct", "destroy")
@export var destroy_on_damage_taken: bool = true
@export var destroy_on_damage_dealt: bool = true

@onready var movement: MovementComponent3D = %Movement
@onready var hitbox: HitComponent3D = %Hitbox
@onready var hitbox_collider: CollisionShape3D = %Hitbox/Collider
@onready var hurtbox: HurtComponent3D = %Hurtbox
@onready var hurtbox_collider: CollisionShape3D = %Hurtbox/Collider


func _on_hurtbox_damage_taken(_amount: float, _source: HitComponent3D):
	if destroy_on_damage_taken: destroy()


func _on_hitbox_hit(_hurt_component: HurtComponent3D):
	if destroy_on_damage_dealt: destroy()


func _update_team():
	if hitbox: hitbox.team = team
	if hurtbox: hurtbox.team = team


func apply_preset(preset: EntityPreset3D):
	if preset: preset.apply(self)


func destroy():
	queue_free()
	destroyed.emit()
