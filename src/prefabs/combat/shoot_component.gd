@icon("uid://bhlnckexct6l6")
class_name ShootComponent3D
extends Node3D


signal shot_fired(projectile: Projectile3D)
signal cooldown_started(duration: float)
signal cooldown_ended()

@export var projectiles: WeightedResourceDeck
@export var team: CombatArea3D.Team
@export var cooldown: float = 1.0:
	set(value):
		if cooldown == value:
			return
		cooldown = clampf(value, 0, INF)
		if is_node_ready():
			_on_cooldown_time_updated()
		else:
			_on_cooldown_time_updated.call_deferred()
@export var auto_shoot: bool = false:
	set(value):
		auto_shoot = value
		if auto_shoot: shoot()
@export var enabled: bool = true:
	set(value):
		enabled = value
		if auto_shoot: shoot()

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
	if not _cooldown_timer:
		_cooldown_timer = Timer.new()
		_cooldown_timer.one_shot = true
		add_child(_cooldown_timer)
	if auto_shoot: shoot()


func _on_cooldown_end():
	cooldown_ended.emit()
	if auto_shoot: shoot()


func _on_cooldown_time_updated():
	if cooldown > 0 and _cooldown_timer.time_left > cooldown:
		set_on_cooldown()


func _get_next_projectile_preset() -> ProjectilePreset3D:
	return projectiles.draw_next() as ProjectilePreset3D


func get_shoot_direction() -> Vector3:
	return -global_transform.basis.z.normalized()


func get_shoot_position() -> Vector3:
	return global_position


func can_shoot(ignore_cooldown: bool = false) -> bool:
	return enabled and is_node_ready() and (not on_cooldown or ignore_cooldown)


func shoot(preset: ProjectilePreset3D = null, cooldown_time: float = -1,
	ignore_cooldown: bool = false) -> Projectile3D:
	if not can_shoot(ignore_cooldown):
		return null
	if not preset:
		preset = _get_next_projectile_preset()
	if not preset:
		push_warning("Recieved a null projectile preset.")
		return null
	
	var projectile := ProjectileManager.spawn(preset, get_shoot_position(),
		get_shoot_direction(), team)
	
	if cooldown_time != 0:
		set_on_cooldown(cooldown_time)
	
	shot_fired.emit(projectile)
	return projectile


func set_on_cooldown(cooldown_duration: float = -1):
	if not _cooldown_timer:
		return
	if cooldown_duration <= 0:
		cooldown_duration = cooldown
	if cooldown_duration <= 0:
		return
	
	_cooldown_timer.start(cooldown_duration)
	cooldown_started.emit(cooldown_duration)


func reset_cooldown():
	if not on_cooldown:
		return
	_cooldown_timer.stop()
	_on_cooldown_end()
