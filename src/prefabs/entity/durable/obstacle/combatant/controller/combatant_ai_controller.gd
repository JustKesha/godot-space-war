@icon("uid://e673yjoy55c1")
class_name CombatantAIController
extends CombatantController


@export var target: Entity3D
@export var target_alignment_margin: float = 0.5
@export var update_time: float = 1.0:
	set(value):
		update_time = value
		if _update_timer:
			_update_timer.wait_time = update_time
			if _update_timer.time_left > update_time:
				_update_timer.start()

var _update_timer: Timer


func _ready():
	super()
	
	_update_timer = Timer.new()
	_update_timer.name = "UpdateTimer"
	_update_timer.wait_time = update_time
	_update_timer.autostart = true
	_update_timer.one_shot = false
	_update_timer.timeout.connect(_on_update_timer_timeout)
	add_child(_update_timer)


func _on_update_timer_timeout():
	if not disabled:
		update()


func _pick_target(available_targets: Array[Entity3D]) -> Entity3D:
	if not available_targets:
		return null
	return available_targets.pick_random()


func is_valid_target(entity: Entity3D) -> bool:
	if not combatant:
		return false
	return entity and entity.can_process() and entity.team != combatant.team


func is_target_aligned() -> bool:
	return get_alignment_offset(target) <= target_alignment_margin


func get_movement_direction() -> Vector3:
	if not combatant or not target or is_target_aligned():
		return Vector3.ZERO
	
	var target_direction := target.global_position - combatant.global_position
	
	target_direction.z = 0.0
	
	return target_direction.normalized()


func get_shooting_state() -> bool:
	return is_target_aligned()


func get_alignment_offset(from: Entity3D) -> float:
	if not combatant or not from:
		return INF
	
	var player_pos_2d := Vector2(combatant.global_position.x, combatant.global_position.y)
	var target_pos_2d := Vector2(from.global_position.x, from.global_position.y)
	
	var distance_off_match := player_pos_2d.distance_to(target_pos_2d)
	
	return distance_off_match


func get_available_targets() -> Array[Entity3D]:
	if not combatant or not Game.current_level:
		return []
	var available_targets: Array[Entity3D]
	available_targets.assign(Game.current_level.get_obstacles([combatant.team], true))
	return available_targets


func get_next_target() -> Entity3D:
	return _pick_target(get_available_targets())


func switch_target():
	target = get_next_target()


func update_target():
	if not is_valid_target(target):
		switch_target()


func update():
	super()
	update_target()


func reset():
	super()
	target = null
