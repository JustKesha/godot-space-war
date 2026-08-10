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

@onready var projectiles: NodePoolManager3D = %Projectiles
@onready var obstacles: NodePoolManager3D = %Obstacles
@onready var combatants: NodePoolManager3D = %Combatants
@onready var wave_manager: WaveManager = %WaveManager


func _ready():
	Game.current_level = self


func _physics_process(delta: float):
	_apply_drift(delta)


func _apply_drift(delta: float):
	if not drift_enabled or drift_speed < 0:
		return
	
	var speed := drift_direction * drift_speed * delta
	
	if drift_affect_ratio_projectiles != 0:
		for projectile: Projectile3D in projectiles.active_nodes:
			projectile.position += speed * drift_affect_ratio_projectiles
	
	if drift_affect_ratio_obstacles != 0:
		for obstacle: Obstacle3D in obstacles.active_nodes:
			obstacle.position += speed * drift_affect_ratio_obstacles
	
	if drift_affect_ratio_combatants != 0:
		for combatant: Combatant3D in combatants.active_nodes:
			combatant.position += speed * drift_affect_ratio_combatants


func clean():
	projectiles.trim()
	obstacles.trim()


func clear():
	projectiles.clear()
	obstacles.clear()
