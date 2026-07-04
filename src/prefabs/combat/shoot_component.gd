@icon("uid://bhlnckexct6l6")
class_name ShootComponent3D
extends Node3D


signal shot_fired(projectile: Projectile3D)

@export var projectiles: WeightedResourceDeck
@export var team: CombatArea3D.Team
@export var enabled: bool = true:
	set(value):
		enabled = value
		_on_enabled_changed()


func _on_enabled_changed(): pass
func _on_shot_fired(): pass


func _get_next_projectile_preset() -> ProjectilePreset3D:
	return projectiles.draw_next() as ProjectilePreset3D


func get_shoot_direction() -> Vector3:
	return -global_transform.basis.z.normalized()


func get_shoot_position() -> Vector3:
	return global_position


func can_shoot() -> bool:
	return enabled


func shoot(preset: ProjectilePreset3D = null) -> Projectile3D:
	if not can_shoot():
		return null
	if not preset:
		preset = _get_next_projectile_preset()
	if not preset:
		push_warning("Recieved a null projectile preset.")
		return null
		
	print('pew!')
	
	var projectile := ProjectileManager.spawn(preset, get_shoot_position(),
		get_shoot_direction(), team)
	
	_on_shot_fired()
	shot_fired.emit(projectile)
	return projectile
