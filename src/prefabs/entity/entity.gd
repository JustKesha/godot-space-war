@icon("uid://u45ctku6sbsn")
class_name Entity3D
extends Area3D


signal team_changed
signal destroyed(killer_signature: int)

@export var team: CombatArea3D.Team:
	set(value):
		var team_old := team
		team = value
		if is_node_ready():
			_update_team()
		if team != team_old:
			team_changed.emit()
@export var collision_enabled: bool = true:
	set(value):
		collision_enabled = value
		if is_node_ready():
			_update_collision()
@export_group("Self Destruct", "destroy")
@export var destroy_on_damage_taken: bool = true
@export var destroy_on_damage_dealt: bool = true

@onready var collider: CollisionShape3D = %Collider
@onready var movement: MovementComponent3D = %Movement
@onready var hitbox: HitComponent3D = %Hitbox
@onready var hitbox_collider: CollisionShape3D = %Hitbox/Collider
@onready var hurtbox: HurtComponent3D = %Hurtbox
@onready var hurtbox_collider: CollisionShape3D = %Hurtbox/Collider

var was_destroyed: bool
var _last_damage_source: HitComponent3D


func _ready():
	was_destroyed = false
	_last_damage_source = null
	_update_signature()
	_update_team()
	_update_collision()
	Events.entity_spawned.emit(self)


func _on_hurtbox_damage_taken(_amount: float, source: HitComponent3D):
	_last_damage_source = source
	if destroy_on_damage_taken: destroy()


func _on_hitbox_hit(_hurt_component: HurtComponent3D):
	if destroy_on_damage_dealt: destroy()


func _remove_signature():
	Utils.clear_signature(self)
	Utils.clear_signature(hitbox)


func _update_signature():
	if not Utils.has_signature(self):
		Utils.generate_and_set_instance_signature(self)
	Utils.sign_instance.call_deferred(hitbox, self)


func _update_team():
	if hitbox: hitbox.team = team
	if hurtbox: hurtbox.team = team


func _update_collision():
	if hitbox: hitbox.set_deferred("monitoring", collision_enabled)
	if hurtbox: hurtbox.set_deferred("monitorable", collision_enabled)


func _dispose():
	queue_free()


func destroy():
	if was_destroyed:
		return
	
	was_destroyed = true
	collision_enabled = false
	
	_remove_signature.call_deferred()
	_dispose()
	
	var killer_signature := Utils.get_instance_signature(_last_damage_source)
	
	destroyed.emit(killer_signature)
	Events.entity_destroyed.emit(self, killer_signature)


func get_signature() -> int:
	return Utils.get_instance_signature(self)


func set_signature(new_signature: int):
	Utils.set_instance_signature(self, new_signature)
	_update_signature()


func apply_preset(preset: EntityPreset3D):
	if preset: preset.apply(self)
