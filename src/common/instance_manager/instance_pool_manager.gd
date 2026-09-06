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
var _active_nodes_peak: float
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
	if auto_trim_enabled and active_instances.size() > _active_nodes_peak:
		_active_nodes_peak = clamp(active_instances.size(), pool_size_min, pool_size_max)
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
	
	_set_node_active(old_instance, true)
	instance_activated.emit(old_instance)
	
	return old_instance


func _dispose(node: Node3D):
	if pooled_instances.size() >= pool_size_max:
		super(node)
		return
	
	if not node in pooled_instances:
		pooled_instances.append(node)
		_set_node_active(node, false)
		instance_dispoed.emit(node)
		instance_pooled.emit(node)


static func _set_node_active(node: Node3D, active: bool = true):
	if active:
		node.process_mode = Node3D.PROCESS_MODE_INHERIT
		node.show()
	else:
		node.set_deferred("process_mode", Node3D.PROCESS_MODE_DISABLED)
		node.hide.call_deferred()


func trim(limit: int = -1) -> int:
	if limit < 0:
		limit = pool_size_min
	
	limit = clamp(limit, 0, pool_size_max)
	
	var trimmed := 0
	
	while pooled_instances.size() > limit:
		var excess_node = pooled_instances.pop_back()
		if is_instance_valid(excess_node):
			excess_node.queue_free()
			trimmed += 1
	
	pool_trimmed.emit(trimmed)
	if pooled_instances.is_empty():
		pool_emptied.emit()
	return trimmed
