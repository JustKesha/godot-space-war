class_name NodePoolManager3D
extends NodeManager3D
## Pools [Node3D] instances to minimize runtime instantiation overhead.


@export_group("Pool Size", "pool_size")
@export var pool_size_min: int = 10
@export var pool_size_max: int = 100
@export_subgroup("Dynamic Cap", "dynamic_cap")
@export var dynamic_cap_enabled: bool = false
@export var dynamic_cap_delay: float = 10.0

var _pool_cap: int:
	set(value):
		if _pool_cap != value:
			_pool_cap = value
			trim_pool()
	get():
		if dynamic_cap_enabled:
			return _pool_cap
		return pool_size_max
var _active_nodes_last_peak_time: float
var pooled_nodes: Array[Node3D]


func _get_new_instance(parent: Node3D) -> Node3D:
	clean()
	_update_pool_cap()
	
	if pooled_nodes.is_empty():
		return super(parent)
	
	var old_node := pooled_nodes.pop_back() as Node3D
	
	_set_node_parent(old_node, parent)
	_set_node_active(old_node, true)
	
	return old_node


func _dispose(node: Node3D):
	clean()
	
	if pooled_nodes.size() >= _pool_cap:
		super(node)
		return
	
	if not node in pooled_nodes:
		pooled_nodes.append(node)
		_set_node_active(node, false)


func _update_pool_cap():
	if not dynamic_cap_enabled:
		return
	
	if active_nodes.size() > _pool_cap:
		_pool_cap = clamp(active_nodes.size(), pool_size_min, pool_size_max)
		_active_nodes_last_peak_time = _now()


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


static func _now() -> float:
	return Time.get_ticks_msec() / 1000.0


func clear():
	super()
	trim_pool(0)


func clean(forced: bool = false):
	if forced or has_stagnated():
		trim_pool()


func has_stagnated() -> bool:
	return _now() - _active_nodes_last_peak_time > dynamic_cap_delay


func trim_pool(limit: int = -1):
	if limit < 0:
		limit = pool_size_min
	
	limit = clamp(limit, 0, _pool_cap)
	
	while pooled_nodes.size() > limit:
		var excess_node = pooled_nodes.pop_back()
		if is_instance_valid(excess_node):
			excess_node.queue_free()
		print('TRIM TRIM TRIM')
	
	_active_nodes_last_peak_time = _now()
