@icon("uid://bhlnckexct6l6")
class_name ShootComponent3D
extends Node3D
## Modular component for handling [Projectile3D] shooting.


## Emitted when a [method shoot] call resultes in at least 1 projectile spawned.
signal fired()
## Emitted when a projectile is spawned.
## [br][br][b]Note:[/b] Can fire multiple times per one [method shoot] call.
## See [member fire_mode] and [signal fired].
signal shot_fired(projectile: Projectile3D)
## Emitted when the firing cooldown starts.
signal cooldown_started(duration: float)
## Emitted when the firing cooldown ends.
signal cooldown_ended()

enum FireMode {
	## Fires in all [member directions] at once.
	SIMULTANEOUS,
	## Cycles through [member directions] one by one per [method shoot] call
	## (ascending).
	SEQUENTIAL,
	## Picks a random direction from the [member directions] list every
	## [method shoot] call.
	RANDOM,
	}

## The [ProjectilePreset3D] resource deck used to determine which projectile
## preset to draw next.
@export var projectiles: WeightedResourceDeck
## The team each fired projecitle is assigned to.
@export var team: CombatArea3D.Team
## Determines the behavior of the [method shoot] method.
@export var fire_mode: FireMode
## If [code]true[/code], the component enters a continuous shooting loop,
## calling [method shoot] every time the [signal cooldown_ended] is emited.
## [br][br][b]Note:[/b] The [member cooldown] must be greater than [code]0[/code]
## in order for this to work.
@export var auto_shoot: bool = false:
	set(value):
		if auto_shoot == value:
			return
		auto_shoot = value
		if auto_shoot:
			shoot.call_deferred()
## If [code]false[/code], will ignore any internal or external [method shoot] calls.
@export var enabled: bool = true:
	set(value):
		if enabled == value:
			return
		enabled = value
		if auto_shoot:
			shoot.call_deferred()
@export_group("Directions")
## List of direction vectors used for targeting projectiles.
@export var directions: Array[Vector3] = [Vector3.FORWARD]
## If [code]true[/code], vectors in the directions array are relative to the
## [ShootComponent3D]'s rotation.
@export var directions_relative: bool = true
@export_group("Offset")
## The spawn position displacement relative to the [ShootComponent3D].
@export var offset: Vector3
## If [code]true[/code], the [member offset] is transformed by the [ShootComponent3D]'s
## basis (rotates with the node).
@export var offset_local: bool = true
@export_group("Cooldown")
## The (default) minimum rest time-frame (in seconds) required between two successful
## [method shoot] calls. [br][br][b]Note:[/b] This can be by-passed, see [method shoot].
## Setting this anywhere below [code]0.05[/code] is not recommended, see [member Timer.wait_time].
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
## Returns [code]true[/code] if the internal cooldown timer is currently running.
## See [member cooldown].
var on_cooldown: bool:
	get():
		if not _cooldown_timer:
			return false
		return _cooldown_timer.time_left > 0
## Determines the maximum number of successful [method shoot] calls possible per
## second. This is a computed property - modifying it automatically updates the
## [member cooldown]. If the [member cooldown] is [code]0[/code] will return
## [code]INF[/code]. [br][br][b]Note:[/b] The [member fire_rate]/[member cooldown]
## restriction can be by-passed, see [method shoot]. Setting this anywhere above
## [code]20[/code] is not recommended, see [member Timer.wait_time].
var fire_rate: float:
	get():
		return 1.0 / cooldown if cooldown > 0 else INF
	set(value):
		cooldown = 1.0 / value if value > 0 else INF


func _ready():
	if auto_shoot:
		shoot.call_deferred()


func _init_cooldown_timer():
	if _cooldown_timer:
		return
	_cooldown_timer = Timer.new()
	_cooldown_timer.one_shot = true
	_cooldown_timer.name = 'Cooldown'
	add_child(_cooldown_timer)


func _on_cooldown_end():
	cooldown_ended.emit()
	if auto_shoot: shoot()


func _on_cooldown_time_updated():
	if not _cooldown_timer:
		_init_cooldown_timer()
	if cooldown > 0:
		if _cooldown_timer.time_left > cooldown:
			set_on_cooldown()
		elif auto_shoot:
			shoot()


func _get_next_projectile_preset() -> ProjectilePreset3D:
	if not projectiles:
		return null
	return projectiles.draw_next() as ProjectilePreset3D


func _to_world_direction(local_dir: Vector3) -> Vector3:
	var normalized_local := local_dir.normalized()
	
	if directions_relative:
		return normalized_local * global_transform.basis.get_rotation_quaternion()
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
	var origin := global_transform.origin
	if offset_local:
		return origin + (global_transform.basis * offset)
	return origin + offset


func _fire_projectile(preset: ProjectilePreset3D,
	pos: Vector3, dir: Vector3) -> Projectile3D:
	if not Game.current_level:
		push_warning("Failed to create a new projectile instance.
			Current level is not fully loaded.")
		return null
	
	var spawn_transform := Transform3D(Basis.looking_at(dir), pos)
	var projectile := Game.current_level.projectiles.new(spawn_transform) as Projectile3D
	
	if not projectile:
		push_error("Failed to create a new projectile instance.")
		return null
	
	projectile.team = team
	projectile.movement.position = pos
	projectile.apply_preset(preset)
	
	shot_fired.emit(projectile)
	
	return projectile


## Returns [code]true[/code] if the component is capable of successfully
## processing to a [method shoot] call.
func can_shoot(ignore_cooldown: bool = false) -> bool:
	return enabled and is_node_ready() and (not on_cooldown or ignore_cooldown)


## Spawns [Projectile3D] instances with given [param preset] based on the
## component configuration; See [member fire_mode].
## If [param preset] is [code]null[/code], will draw the next preset from the
## [member projectiles] deck.
## If [param cooldown_time] is below [code]0[/code], will default to [member cooldown].
## If [param cooldown_time] is [code]0[/code], no cooldown will be applied.
## If successful, will emit [signal fired] and return an array of [Projectile3D]
## instances spawned, otherwise will return an empty array.
## [br][br][b]Note:[/b] Will fail if [method can_shoot] returns [code]false[/code].
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
		var projectile := _fire_projectile(preset, pos, dir)
		if projectile:
			output.append(projectile)
	
	if cooldown_time != 0:
		set_on_cooldown(cooldown_time)
	
	if not output.is_empty():
		fired.emit()
	
	return output


## Puts the component on hold for the specified [param cooldown_duration] (seconds).
## During this hold period any [method shoot] calls will be ignored, unless
## manually by-passed.
## If [param cooldown_duration] is below or equal to [code]0[/code],
## will default to [member cooldown].
## Emits [signal cooldown_started] & [signal cooldown_ended].
func set_on_cooldown(cooldown_duration: float = -1):
	if cooldown_duration <= 0:
		cooldown_duration = cooldown
	if cooldown_duration <= 0:
		return
	if not _cooldown_timer:
		_init_cooldown_timer()
	
	_cooldown_timer.start(cooldown_duration)
	cooldown_started.emit(cooldown_duration)


## Stops the cooldown timer early and emits [signal cooldown_ended].
## See [method set_on_cooldown].
func reset_cooldown():
	if not on_cooldown:
		return
	_cooldown_timer.stop()
	_on_cooldown_end()
