@icon("uid://1gmraidhgeij")
class_name WaveManager
extends Node3D


signal wave_spawned(wave: Wave)
signal all_waves_spawned()

@export var seed_string: String:
	set(value):
		seed_string = value
		
		if len(seed_string) > 0:
			_rng.seed = seed_string.hash()
		else:
			_rng.randomize()
@export var disabled: bool:
	set(value):
		disabled = value
		_update_wave_timer_state()
@export_group("Waves", "waves")
@export var waves_available: Array[Wave]
@export var waves_team: CombatArea3D.Team
@export var waves_total: int = -1
@export_group("Spawn")
@export var bounds: AABB
@export var step: Vector3
@export_group("Auto Spawn", "auto_spawn")
@export var auto_spawn_delay: float = 1.0:
	set(value):
		auto_spawn_delay = value
		_update_wave_timer_state()
@export var auto_spawn_enabled: bool:
	set(value):
		auto_spawn_enabled = value
		_update_wave_timer_state()

var _wave_timer: Timer = Timer.new()
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var waves_spawned: int:
	set(value):
		value = clamp(value, 0, INF)
		
		if value == waves_spawned:
			return
		
		var waves_spawned_before := waves_spawned
		waves_spawned = value
		
		if( waves_total > 0
			and waves_spawned >= waves_total and waves_spawned_before < waves_total ):
			all_waves_spawned.emit()
var progress: float:
	set(value):
		if waves_total <= 0:
			return
		
		if value >= 1.0:
			waves_spawned = waves_total
		elif value <= 0.0 or is_nan(value):
			waves_spawned = 0
		else:
			waves_spawned = floori(value * waves_total)
	get():
		if waves_total <= 0:
			return 1.0
		
		return clampf(float(waves_spawned) / float(waves_total), 0.0, 1.0)


func _init():
	_wave_timer.name = 'AutoSpawnTimer'
	_wave_timer.wait_time = auto_spawn_delay
	_wave_timer.timeout.connect(_on_wave_timer_timeout)
	add_child(_wave_timer)


func _update_wave_timer_state():
	var wave_timer_active := auto_spawn_enabled and not disabled
	
	_wave_timer.wait_time = auto_spawn_delay
	_wave_timer.paused = not wave_timer_active
	
	if wave_timer_active and (
		_wave_timer.is_stopped() or _wave_timer.time_left > _wave_timer.wait_time
		):
		_wave_timer.start.call_deferred()


func _on_wave_timer_timeout():
	if waves_spawned < waves_total or waves_total < 0:
		spawn_next_wave()


func _get_next_wave() -> Wave:
	if disabled:
		return null
	if waves_available.is_empty():
		push_error("No available waves found.")
		return null
	
	return waves_available[_rng.randi_range(0, waves_available.size() - 1)]
 

func _calculate_wave_offset(wave_bounds: AABB) -> Vector3:
	var min_x = bounds.position.x
	var max_x = bounds.position.x + bounds.size.x - wave_bounds.size.x
	var min_y = bounds.position.y
	var max_y = bounds.position.y + bounds.size.y - wave_bounds.size.y
	var min_z = bounds.position.z
	var max_z = bounds.position.z + bounds.size.z - wave_bounds.size.z
	var final_x = _rng.randf_range(min_x, max_x)
	var final_y = _rng.randf_range(min_y, max_y)
	var final_z = _rng.randf_range(min_z, max_z)
	
	return Vector3(
		snapped(final_x, step.x) - wave_bounds.position.x,
		snapped(final_y, step.y) - wave_bounds.position.y,
		snapped(final_z, step.z) - wave_bounds.position.z,
	)


func spawn_wave_section(wave_section: WaveSection,
	wave_offset: Vector3 = Vector3.ZERO) -> Obstacle3D:
	if disabled:
		return null
	if not Game.current_level:
		push_error("Trying to spawn a wave section while current level is not fully loaded.")
		return null
	if not wave_section or not wave_section.obstacle:
		push_warning("Trying to spawn an empty wave section.")
		return null
	
	var obstacle_position := global_position + wave_offset + wave_section.position
	var obstacle_transform := Transform3D(transform.basis, obstacle_position)
	var obstacle := Game.current_level.obstacles.new(obstacle_transform) as Obstacle3D
	
	obstacle.team = waves_team
	obstacle.apply_preset(wave_section.obstacle)
	
	return obstacle


func spawn_wave(wave: Wave) -> bool:
	if disabled:
		return false
	if not Game.current_level:
		push_error("Trying to spawn a wave while current level is not fully loaded.")
		return false
	if not wave:
		push_warning("Trying to spawn a null wave.")
		return false
	if wave.sections.is_empty():
		push_warning("Trying to spawn an empty wave.")
		return false
	
	var wave_offset := _calculate_wave_offset(wave.bounds)
	
	for wave_section in wave.sections:
		spawn_wave_section(wave_section, wave_offset)
	
	waves_spawned += 1
	wave_spawned.emit(wave)
	return true


func spawn_next_wave() -> Wave:
	if disabled:
		return null
	var next_wave := _get_next_wave()
	spawn_wave(next_wave)
	return next_wave
