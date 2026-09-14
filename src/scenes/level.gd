@icon("uid://r2615y8g1wmf")
class_name Level
extends Node3D


@export_group("Drift", "drift")
@export var drift_enabled: bool
@export var drift_direction: Vector3 = Vector3.BACK
@export var drift_speed: float = 1.0
@export_subgroup("Affect Ratio", "drift_affect_ratio")
@export var drift_affect_ratio_projectiles: float = 1.0
@export var drift_affect_ratio_obstacles: float = 1.0
@export var drift_affect_ratio_combatants: float = 1.0

@onready var hud: HUD = %HUD
@onready var projectiles: InstancePoolManager3D = %Projectiles
@onready var obstacles: InstancePoolManager3D = %Obstacles
@onready var combatants: InstancePoolManager3D = %Combatants
@onready var players: InstanceManager3D = %Players
@onready var wave_manager: WaveManager3D = %WaveManager


func _ready():
	Game.current_level = self


func _physics_process(delta: float):
	_apply_drift(delta)


func _apply_drift(delta: float):
	if not drift_enabled or drift_speed < 0:
		return
	
	var speed := drift_direction * drift_speed * delta
	
	if drift_affect_ratio_projectiles != 0:
		for projectile: Projectile3D in projectiles.active_instances:
			projectile.position += speed * drift_affect_ratio_projectiles
	
	if drift_affect_ratio_obstacles != 0:
		for obstacle: Obstacle3D in obstacles.active_instances:
			obstacle.position += speed * drift_affect_ratio_obstacles
	
	if drift_affect_ratio_combatants != 0:
		for combatant: Combatant3D in combatants.active_instances:
			combatant.position += speed * drift_affect_ratio_combatants


func get_projectiles(exclude_teams: Array[CombatArea3D.Team] = []) -> Array[Projectile3D]:
	var out: Array[Projectile3D]
	out.assign(
		projectiles.active_instances if exclude_teams.is_empty() else
		projectiles.active_instances.filter(func(p): return not exclude_teams.has(p.team))
		)
	return out


func get_obstacles(exclude_teams: Array[CombatArea3D.Team] = []) -> Array[Obstacle3D]:
	var out: Array[Obstacle3D]
	out.assign(
		obstacles.active_instances if exclude_teams.is_empty() else
		obstacles.active_instances.filter(func(o): return not exclude_teams.has(o.team))
		)
	return out


func get_combatants(exclude_teams: Array[CombatArea3D.Team] = []) -> Array[Combatant3D]:
	var out: Array[Combatant3D]
	out.assign(
		combatants.active_instances if exclude_teams.is_empty() else
		combatants.active_instances.filter(func(c): return not exclude_teams.has(c.team))
		)
	return out


func get_players(exclude_teams: Array[CombatArea3D.Team] = []) -> Array[Player3D]:
	var out: Array[Player3D]
	out.assign(
		players.active_instances if exclude_teams.is_empty() else
		players.active_instances.filter(func(p): return not exclude_teams.has(p.team))
		)
	return out


func clean():
	projectiles.trim()
	obstacles.trim()
	combatants.trim()


func clear():
	projectiles.clear()
	obstacles.clear()
	combatants.clear()
	players.clear()


func reset():
	clear()
	wave_manager.progress = 0


func restart():
	get_tree().reload_current_scene.call_deferred()
