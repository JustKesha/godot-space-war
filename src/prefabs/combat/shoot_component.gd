@icon("uid://bhlnckexct6l6")
class_name ShootComponent3D
extends Node3D


signal shot_fired(projectile: Projectile3D)
signal cooldown_started(duration: float)
signal cooldown_ended()

enum FireMode {
	SIMULTANEOUS,
	SEQUENTIAL,
	RANDOM,
	}

@export var projectiles: WeightedResourceDeck
@export var team: CombatArea3D.Team
@export var fire_mode: FireMode
@export var auto_shoot: bool = false:
	set(value):
		auto_shoot = value
		if auto_shoot: shoot()
@export var enabled: bool = true:
	set(value):
		enabled = value
		if auto_shoot: shoot()
@export_group("Directions")
@export var directions: Array[Vector3] = [Vector3.FORWARD]
@export var directions_relative: bool = true
@export_group("Offset")
@export var offset: Vector3
@export var offset_local: bool = true
@export_group("Cooldown")
@export var cooldown: float = 1.0:
	set(value):
		if cooldown == value:
			return
		cooldown = clampf(value, 0, INF)
		if is_node_ready():
			_on_cooldown_time_updated()
		else:
			_on_cooldown_time_updated.call_deferred()

var _current_direction_index: int
var _cooldown_timer: Timer:
	set(value):
		if _cooldown_timer and _cooldown_timer.timeout.is_connected(_on_cooldown_end):
			_cooldown_timer.timeout.disconnect(_on_cooldown_end)
		_cooldown_timer = value
		if _cooldown_timer and not _cooldown_timer.timeout.is_connected(_on_cooldown_end):
			_cooldown_timer.timeout.connect(_on_cooldown_end)
var on_cooldown: bool:
	get():
		if not _cooldown_timer:
			return false
		return _cooldown_timer.time_left > 0


func _ready():
	if auto_shoot: shoot()


func _init_cooldown_timer():
	if _cooldown_timer:
		return
	_cooldown_timer = Timer.new()
	_cooldown_timer.one_shot = true
	add_child(_cooldown_timer)


func _on_cooldown_end():
	cooldown_ended.emit()
	if auto_shoot: shoot()


func _on_cooldown_time_updated():
	if cooldown > 0 and _cooldown_timer.time_left > cooldown:
		set_on_cooldown()


func _get_next_projectile_preset() -> ProjectilePreset3D:
	return projectiles.draw_next() as ProjectilePreset3D


func _to_world_direction(local_dir: Vector3) -> Vector3:
	var normalized_local = local_dir.normalized()
	if directions_relative:
		return global_transform.basis * normalized_local
	else:
		return normalized_local


func _get_shoot_directions() -> Array[Vector3]:
	var output: Array[Vector3] = []
	
	if directions.is_empty():
		push_warning("Directions array is empty.")
		return []
	
	match fire_mode:
		FireMode.SIMULTANEOUS:
			for dir in directions:
				output.append(_to_world_direction(dir))
		FireMode.SEQUENTIAL:
			var dir = directions[_current_direction_index]
			output.append(_to_world_direction(dir))
			_current_direction_index = (_current_direction_index + 1) % directions.size()
		FireMode.RANDOM:
			output.append(_to_world_direction(directions.pick_random()))
		_:
			push_warning("Unknown fire mode: ", fire_mode, ".")
	
	return output


func _get_shoot_position() -> Vector3:
	if offset_local:
		return global_transform.origin + (global_transform.basis * offset)
	return offset


func can_shoot(ignore_cooldown: bool = false) -> bool:
	return enabled and is_node_ready() and (not on_cooldown or ignore_cooldown)


func shoot(preset: ProjectilePreset3D = null, cooldown_time: float = -1,
	ignore_cooldown: bool = false) -> Array[Projectile3D]:
	if not can_shoot(ignore_cooldown): 
		return []
	if not preset: 
		preset = _get_next_projectile_preset()
	if not preset: 
		push_warning("Received a null projectile preset.") 
		return []
	
	var output: Array[Projectile3D] = []
	var dirs := _get_shoot_directions()
	var pos := _get_shoot_position()
	
	for dir in dirs:
		var projectile := ProjectileManager.spawn(preset, pos, dir, team)
		if projectile:
			output.append(projectile)
			shot_fired.emit(projectile)
	
	if cooldown_time != 0:
		set_on_cooldown(cooldown_time)
	
	return output


func set_on_cooldown(cooldown_duration: float = -1):
	if cooldown_duration <= 0:
		cooldown_duration = cooldown
	if cooldown_duration <= 0:
		return
	if not _cooldown_timer:
		_init_cooldown_timer()
	
	_cooldown_timer.start(cooldown_duration)
	cooldown_started.emit(cooldown_duration)


func reset_cooldown():
	if not on_cooldown:
		return
	_cooldown_timer.stop()
	_on_cooldown_end()
