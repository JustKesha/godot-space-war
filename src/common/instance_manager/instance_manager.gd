@icon("uid://b77w112m7u70u")
class_name InstanceManager3D
extends Node3D
## Manages and keeps track of [PackedScene] ([Node3D]) instances.
##
## [b]Note:[/b] This class extends [Node3D] instead of [Node] only
## because of the specifics of the current project. It can be easily changed
## into a "InstanceManager2D" or even a more generic "InstanceManager" as it does not
## require or use any dimension-specific logic.


signal instance_spawned(instance: Node3D)
signal instance_dispoed(instance: Node3D)
signal all_instances_dispoed()

@export var packed_scene: PackedScene
@export var default_parent: Node3D

var active_instances: Array[Node3D]


func _ready():
	assert(packed_scene, "The packed_scene is not assigned.")


func _get_new_instance() -> Node3D:
	if not packed_scene:
		push_error("The packed_scene is not assigned.")
		return null
	
	var new_instance := packed_scene.instantiate() as Node3D
	
	if not new_instance:
		push_error("The assigned packed_scene is not a Node3D.")
		return null
	
	return new_instance


func _set_instance_parent(instance: Node3D, parent: Node3D = null):
	if not is_instance_valid(parent):
		parent = default_parent if is_instance_valid(default_parent) else self
	
	if instance.is_inside_tree():
		instance.reparent(parent)
	else:
		parent.add_child(instance)


func _dispose(instance: Node3D):
	if not is_instance_valid(instance):
		return
	
	instance.queue_free()
	instance_dispoed.emit(instance)


func new(spawn_transform: Transform3D, parent: Node3D = null) -> Node3D:
	var new_instance := _get_new_instance()
	
	if not is_instance_valid(new_instance):
		return null
	
	new_instance.global_transform = spawn_transform
	
	_set_instance_parent(new_instance, parent)
	
	active_instances.append(new_instance)
	instance_spawned.emit(new_instance)
	
	return new_instance


func dispose(instance: Node3D):
	if instance in active_instances:
		active_instances.erase(instance)
	_dispose(instance)
	if active_instances.is_empty():
		all_instances_dispoed.emit()


func clear():
	var instances := active_instances.duplicate()
	for instance in instances:
		dispose(instance)
