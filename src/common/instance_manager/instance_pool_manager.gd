class_name InstancePoolManager3D
extends InstanceManager3D
## Pools [PackedScene] ([Node3D]) instances to minimize runtime instantiation overhead.
##
## TASK Pre-instantiation up to [member pool_size_min] amount.

signal instance_activated(instance: Node3D)
signal instance_pooled(instance: Node3D)
signal pool_trimmed(instances_trimmed: int)
signal pool_emptied()

@export_group("Pool Size", "pool_size")
@export var pool_size_min: int = 10
@export var pool_size_max: int = 100
@export_group("Auto Trim", "auto_trim")
@export var auto_trim_enabled: bool = true
@export var auto_trim_delay: float = 10.0

var _trim_timer: Timer
var _active_instances_peak: float
var pooled_instances: Array[Node3D]


func _ready():
	super()
	_init_trim_timer()


func _init_trim_timer():
	_trim_timer = Timer.new()
	_trim_timer.name = "TrimTimer"
	_trim_timer.timeout.connect(trim)
	add_child(_trim_timer)


func _update_trim_timer():
	if auto_trim_enabled and active_instances.size() > _active_instances_peak:
		_active_instances_peak = clamp(active_instances.size(), pool_size_min, pool_size_max)
		_trim_timer.start(auto_trim_delay)


func _get_new_instance() -> Node3D:
	_update_trim_timer()
	
	if pooled_instances.is_empty():
		return super()
	
	var old_instance := pooled_instances.pop_back() as Node3D
	
	if not is_instance_valid(old_instance) or not old_instance.is_inside_tree():
		push_error("The pool contained an invalid instance of a Node3D,
			or the instance was pooled before it could get into the scene tree.")
		return null
	
	old_instance._ready.call_deferred()
	
	_set_instance_active(old_instance, true)
	instance_activated.emit(old_instance)
	
	return old_instance


func _dispose(instance: Node3D):
	if pooled_instances.size() >= pool_size_max:
		super(instance)
		return
	
	if not instance in pooled_instances:
		pooled_instances.append(instance)
		_set_instance_active(instance, false)
		instance_dispoed.emit(instance)
		instance_pooled.emit(instance)


static func _set_instance_active(instance: Node3D, active: bool = true):
	if active:
		instance.process_mode = Node3D.PROCESS_MODE_INHERIT
		instance.show()
	else:
		instance.set_deferred("process_mode", Node3D.PROCESS_MODE_DISABLED)
		instance.hide.call_deferred()


func get_all_instances() -> Array[Node3D]:
	var all_instances: Array[Node3D] = active_instances.duplicate()
	all_instances.append_array(pooled_instances)
	return all_instances


func get_total_instance_count() -> int:
	return len(active_instances) + len(pooled_instances)


func trim(limit: int = -1) -> int:
	if limit < 0:
		limit = pool_size_min
	
	limit = clamp(limit, 0, pool_size_max)
	
	var trimmed := 0
	
	while pooled_instances.size() > limit:
		var excess_instance = pooled_instances.pop_back()
		if is_instance_valid(excess_instance):
			excess_instance.queue_free()
			trimmed += 1
	
	pool_trimmed.emit(trimmed)
	if pooled_instances.is_empty():
		pool_emptied.emit()
	return trimmed
