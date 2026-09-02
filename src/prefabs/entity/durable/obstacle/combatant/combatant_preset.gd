@icon("uid://bn07h1m08qxrv")
class_name CombatantPreset3D
extends ObstaclePreset3D


@export_group("Gun", "gun")
@export var gun_projectiles: WeightedResourceDeck:
	set(value):
		if gun_projectiles and gun_projectiles.changed.is_connected(_on_changed):
			gun_projectiles.changed.disconnect(_on_changed)
		gun_projectiles = value
		_on_changed()
		if gun_projectiles and not gun_projectiles.changed.is_connected(_on_changed):
			gun_projectiles.changed.connect(_on_changed)
@export var gun_fire_mode := ShootComponent3D.FireMode.SIMULTANEOUS:
	set(value):
		if gun_fire_mode == value:
			return
		gun_fire_mode = value
		_on_changed()
@export var gun_auto_shoot: bool = true:
	set(value):
		if gun_auto_shoot == value:
			return
		gun_auto_shoot = value
		_on_changed()
@export_subgroup("Directions", "gun")
@export var gun_directions: Array[Vector3] = [Vector3.FORWARD]:
	set(value):
		if gun_directions == value:
			return
		gun_directions = value
		_on_changed()
@export var gun_directions_relative: bool = true:
	set(value):
		if gun_directions_relative == value:
			return
		gun_directions_relative = value
		_on_changed()
@export_subgroup("Offset", "gun")
@export var gun_offset: Vector3:
	set(value):
		if gun_offset == value:
			return
		gun_offset = value
		_on_changed()
@export var gun_offset_local: bool = true:
	set(value):
		if gun_offset_local == value:
			return
		gun_offset_local = value
		_on_changed()
@export_subgroup("Cooldown", "gun")
@export var gun_cooldown: float = 1.0:
	set(value):
		if gun_cooldown == value:
			return
		gun_cooldown = value
		_on_changed()


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
