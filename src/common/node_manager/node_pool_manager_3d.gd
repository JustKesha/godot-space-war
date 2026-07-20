class_name NodePoolManager3D
extends NodeManager3D
## Pools [Node3D] instances to minimize runtime instantiation overhead.


signal node_activated(node: Node3D)
signal node_pooled(node: Node3D)
signal pool_trimmed(elements_trimmed: int)
signal pool_emptied()

@export_group("Pool Size", "pool_size")
@export var pool_size_min: int = 10
@export var pool_size_max: int = 100
@export_group("Auto Trim", "auto_trim")
@export var auto_trim_enabled: bool = true
@export var auto_trim_delay: float = 10.0

var _trim_timer: Timer
var _active_nodes_peak: float
var pooled_nodes: Array[Node3D]


func _ready():
	super()
	_init_trim_timer()


func _init_trim_timer():
	_trim_timer = Timer.new()
	_trim_timer.timeout.connect(trim)
	add_child(_trim_timer)


func _update_trim_timer():
	if auto_trim_enabled and active_nodes.size() > _active_nodes_peak:
		_active_nodes_peak = clamp(active_nodes.size(), pool_size_min, pool_size_max)
		_trim_timer.start(auto_trim_delay)


func _get_new_instance(parent: Node3D) -> Node3D:
	_update_trim_timer()
	
	if pooled_nodes.is_empty():
		pool_emptied.emit()
		return super(parent)
	
	var old_node := pooled_nodes.pop_back() as Node3D
	
	_set_node_parent(old_node, parent)
	_set_node_active(old_node, true)
	node_activated.emit(old_node)
	
	return old_node


func _dispose(node: Node3D):
	if pooled_nodes.size() >= pool_size_max:
		super(node)
		return
	
	if not node in pooled_nodes:
		pooled_nodes.append(node)
		_set_node_active(node, false)
		node_killed.emit(node)
		node_pooled.emit(node)


static func _set_node_active(node: Node3D, active: bool = true):
	if active:
		node.process_mode = Node3D.PROCESS_MODE_INHERIT
		node.show()
	else:
		node.set_deferred("process_mode", Node3D.PROCESS_MODE_DISABLED)
		node.hide.call_deferred()


static func _set_node_parent(node: Node3D, new_parent: Node3D):
	if node.get_parent() == new_parent:
		return
	
	if node.get_parent():
		node.get_parent().remove_child(node)
	
	if is_instance_valid(new_parent):
		new_parent.add_child(node)


func trim(limit: int = -1) -> int:
	if limit < 0:
		limit = pool_size_min
	
	limit = clamp(limit, 0, pool_size_max)
	
	var trimmed := 0
	
	while pooled_nodes.size() > limit:
		var excess_node = pooled_nodes.pop_back()
		if is_instance_valid(excess_node):
			excess_node.queue_free()
			trimmed += 1
	
	pool_trimmed.emit(trimmed)
	return trimmed
