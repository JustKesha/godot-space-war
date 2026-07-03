@icon("uid://dfehrdx4gp2g2")
class_name ProjectilePreset3D
extends Resource


@export var mesh: Mesh:
	set(value):
		if mesh and mesh.changed.is_connected(_on_changed):
			mesh.changed.disconnect(_on_changed)
		mesh = value
		_on_changed()
		if mesh and not mesh.changed.is_connected(_on_changed):
			mesh.changed.connect(_on_changed)
@export_group("Movement")
@export var speed: float:
	set(value):
		if speed == value:
			return
		speed = value
		_on_changed()
@export_group("Damage")
@export var destroy_on_hit: bool = true:
	set(value):
		if destroy_on_hit == value:
			return
		destroy_on_hit = value
		_on_changed()
@export_subgroup("Hitbox", "hitbox")
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
@export_subgroup("Hurtbox", "hurtbox")
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


func _on_changed():
	changed.emit()


func apply(projectile: Projectile3D) -> bool:
	if not projectile or not projectile.is_node_ready():
		return false
	
	projectile.mesh.mesh = mesh
	
	projectile.movement.speed = speed
	
	projectile.destroy_on_hit = destroy_on_hit
	projectile.hitbox_collider.shape = hitbox_collider_shape
	projectile.hitbox.damage = hitbox_damage
	projectile.hurtbox_collider.shape = hurtbox_collider_shape
	projectile.hurtbox.damage_detection_threshold = hurtbox_damage_detection_threshold
	
	return true
