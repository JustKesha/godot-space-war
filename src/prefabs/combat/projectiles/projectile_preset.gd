@icon("uid://dfehrdx4gp2g2")
class_name ProjectilePreset3D
extends Resource


@export var mesh: Mesh
@export var damage: float
@export var speed: float


func apply(projectile: Projectile3D) -> bool:
	if not projectile or not projectile.is_node_ready():
		return false
	
	projectile.mesh.mesh = mesh
	projectile.hitbox.damage = damage
	projectile.speed = speed
	
	return true
