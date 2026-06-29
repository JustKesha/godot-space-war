@icon("uid://dfehrdx4gp2g2")
class_name ProjectilePreset3D
extends Resource


@export var mesh: Mesh
@export_group("Movement")
@export var speed: float
@export_group("Damage")
@export var team: CombatArea3D.Team
@export_subgroup("Hitbox", "hitbox")
@export var hitbox_collider_shape: Shape3D
@export var hitbox_damage: float
@export_subgroup("Hurtbox", "hurtbox")
@export var hurtbox_collider_shape: Shape3D
@export var hurtbox_damage_detection_threshold: float


func apply(projectile: Projectile3D) -> bool:
	if not projectile or not projectile.is_node_ready():
		return false
	
	projectile.mesh.mesh = mesh
	
	projectile.movement.speed = speed
	
	projectile.team = team
	projectile.hitbox_collider.shape = hitbox_collider_shape
	projectile.hitbox.damage = hitbox_damage
	projectile.hurtbox_collider.shape = hurtbox_collider_shape
	projectile.hurtbox.damage_detection_threshold = hurtbox_damage_detection_threshold
	
	return true
