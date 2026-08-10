@icon("uid://bn07h1m08qxrv")
class_name CombatantPreset3D
extends ObstaclePreset3D


const IS_COMBATANT: bool = true

@export_group("Gun", "gun")
@export var gun_projectiles: WeightedResourceDeck
@export var gun_fire_mode := ShootComponent3D.FireMode.SIMULTANEOUS
@export var gun_auto_shoot: bool = true
@export_subgroup("Directions", "gun")
@export var gun_directions: Array[Vector3] = [Vector3.FORWARD]
@export var gun_directions_relative: bool = true
@export_subgroup("Offset", "gun")
@export var gun_offset: Vector3
@export var gun_offset_local: bool = true
@export_subgroup("Cooldown", "gun")
@export var gun_cooldown: float = 1.0


func apply(entity: Entity3D) -> bool:
	var combatant := entity as Combatant3D
	
	if not combatant:
		push_error("Could not apply preset. Recieved entity is not a combatant.")
		return false
	
	combatant.gun.projectiles = gun_projectiles
	combatant.gun.fire_mode = gun_fire_mode
	combatant.gun.auto_shoot = gun_auto_shoot
	combatant.gun.directions = gun_directions
	combatant.gun.directions_relative = gun_directions_relative
	combatant.gun.offset = gun_offset
	combatant.gun.offset_local = gun_offset_local
	combatant.gun.cooldown = gun_cooldown
	
	return super(entity)
