@icon("uid://dfehrdx4gp2g2")
class_name ProjectilePreset3D
extends EntityPreset3D


@export var mesh: Mesh:
	set(value):
		if mesh and mesh.changed.is_connected(_on_changed):
			mesh.changed.disconnect(_on_changed)
		mesh = value
		_on_changed()
		if mesh and not mesh.changed.is_connected(_on_changed):
			mesh.changed.connect(_on_changed)


func _on_applied(entity: Entity3D) -> bool:
	var projectile := entity as Projectile3D
	
	if not projectile:
		push_warning("Could not apply preset. Recieved entity is not a projectile.")
	
	projectile.mesh.mesh = mesh
	
	return true
