@icon("uid://dnj0aatchqrxp")
class_name DurableEntity3D
extends Entity3D


@export_group("Self Damage")
@export var account_for_damage_taken: bool = true
@export var account_for_damage_dealt: bool = true
@export_subgroup("Bonus", "self_damage")
@export var self_damage_on_damage_taken: float
@export var self_damage_on_damage_dealt: float

@onready var health: HealthComponent = %Health


func _on_hurtbox_damage_taken(amount: float, source: HitComponent3D):
	health.decrease(self_damage_on_damage_taken
		+ (amount if account_for_damage_taken else 0.0))
	super(amount, source)


func _on_hitbox_hit(hurt_component: HurtComponent3D):
	health.decrease(self_damage_on_damage_dealt
		+ (hitbox.damage if account_for_damage_dealt else 0.0))
	super(hurt_component)


func _on_health_minimum_value_reached():
	destroy()
