@icon("uid://ds8sj13kypxe")
class_name EntityPreset3D
extends Resource


signal applied

@export_group("Scale", "scale")
@export var scale_vector: Vector3 = Vector3.ONE
@export var scale_multiplier: float = 1.0
@export_group("Self Destruct", "destroy")
@export var destroy_on_damage_taken: bool:
	set(value):
		if destroy_on_damage_taken == value:
			return
		destroy_on_damage_taken = value
		_on_changed()
@export var destroy_on_damage_dealt: bool:
	set(value):
		if destroy_on_damage_dealt == value:
			return
		destroy_on_damage_dealt = value
		_on_changed()
@export_group("Movement")
@export var speed: float:
	set(value):
		if speed == value:
			return
		speed = value
		_on_changed()
@export_group("Hurtbox", "hurtbox")
@export var hurtbox_collider_shape: Shape3D:
	set(value):
		if hurtbox_collider_shape and hurtbox_collider_shape.changed.is_connected(_on_changed):
			hurtbox_collider_shape.changed.disconnect(_on_changed)
		hurtbox_collider_shape = value
		_on_changed()
		if hurtbox_collider_shape and not hurtbox_collider_shape.changed.is_connected(_on_changed):
			hurtbox_collider_shape.changed.connect(_on_changed)
@export var hurtbox_damage_detection_threshold: float:
	set(value):
		if hurtbox_damage_detection_threshold == value:
			return
		hurtbox_damage_detection_threshold = value
		_on_changed()
@export_group("Hitbox", "hitbox")
@export var hitbox_collider_shape: Shape3D:
	set(value):
		if hitbox_collider_shape and hitbox_collider_shape.changed.is_connected(_on_changed):
			hitbox_collider_shape.changed.disconnect(_on_changed)
		hitbox_collider_shape = value
		_on_changed()
		if hitbox_collider_shape and not hitbox_collider_shape.changed.is_connected(_on_changed):
			hitbox_collider_shape.changed.connect(_on_changed)
@export var hitbox_damage: float:
	set(value):
		if hitbox_damage == value:
			return
		hitbox_damage = value
		_on_changed()


func _on_changed():
	changed.emit()


func apply(entity: Entity3D) -> bool:
	if not entity:
		push_warning("Could not apply preset. Recieved an invalid entity.")
		return false
	if not entity.is_node_ready():
		push_warning("Could not apply preset. Recieved entity node is not ready.")
		return false
	
	entity.scale = scale_vector * scale_multiplier
	
	entity.destroy_on_damage_taken = destroy_on_damage_taken
	entity.destroy_on_damage_dealt = destroy_on_damage_dealt
	
	entity.movement.speed = speed
	
	entity.hitbox_collider.shape = hitbox_collider_shape
	entity.hitbox.damage = hitbox_damage
	
	entity.hurtbox_collider.shape = hurtbox_collider_shape
	entity.hurtbox.damage_detection_threshold = hurtbox_damage_detection_threshold
	
	applied.emit()
	
	return true
