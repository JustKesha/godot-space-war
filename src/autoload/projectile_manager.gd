@icon("uid://c0hhedisi05ok")
class_name ProjectileManager3D
extends Node3D
## Manager responsible for instantiating, configuring and managing [Projectile3D]s.


const PROJECTILE: PackedScene = preload("uid://d0qrugthumeui")


## Instantiates and returns a default [Projectile3D].
func create_projectile() -> Projectile3D:
	var projectile := PROJECTILE.instantiate() as Projectile3D
	
	assert(projectile, "Could not instantiate PROJECTILE as a Projectile3D.")
	
	return projectile


## Spawns in a new [Projectile3D] using given [param preset].
## If no [param host] is specified, defaults to this manager.
func spawn(preset: ProjectilePreset3D = null, pos := Vector3.ZERO,
	dir := Vector3.FORWARD, team := CombatArea3D.Team.Neutral,
	host: Node = null) -> Projectile3D:
	if not host:
		host = self
	
	var projectile := create_projectile()
	
	host.add_child(projectile)
	projectile.apply_preset(preset)
	
	projectile.team = team
	projectile.movement.position = pos
	projectile.movement.direction = dir
	
	return projectile
