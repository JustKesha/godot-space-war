@icon("uid://dfehrdx4gp2g2")
class_name ProjectilePreset3D
extends Resource


@export var mesh: Mesh
@export var hitbox_collider_shape: Shape3D
@export var damage: float
@export var speed: float


func apply(projectile: Projectile3D) -> bool:
	if not projectile or not projectile.is_node_ready():
		return false
	
	projectile.mesh.mesh = mesh
	projectile.hitbox.damage = damage
	projectile.movement.speed = speed
	projectile.collider.shape = hitbox_collider_shape
	
	return true
