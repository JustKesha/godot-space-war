@icon("uid://b77w112m7u70u")
class_name NodeManager3D
extends Node3D
## Manages and keeps track of [Node3D] instances.
##
## [b]Note:[/b] This class extends [Node3D] instead of [Node] only
## because of the specifics of the current project. It can be easily changed
## into a more generic "NodeManager" or even "NodeManager2D" as it does not
## require or use any dimension-specific logic.


signal node_spawned(node: Node3D)
signal node_killed(node: Node3D)

@export var packed_scene: PackedScene
@export var host: Node3D

var active_nodes: Array[Node3D]


func _ready():
	assert(packed_scene, "The packed_scene is not assigned.")


func _get_new_instance(parent: Node3D) -> Node3D:
	if not packed_scene:
		push_error("The packed_scene is not assigned.")
		return null
	
	var new_node := packed_scene.instantiate() as Node3D
	
	if not new_node:
		push_error("The assigned packed_scene is not a Node3D.")
		return null
	
	parent.add_child(new_node)
	
	return new_node


func _dispose(node: Node3D):
	if not is_instance_valid(node):
		return
	
	node.queue_free()
	node_killed.emit(node)


func new(spawn_transform: Transform3D, parent: Node3D = null) -> Node3D:
	if not is_instance_valid(parent):
		parent = host if is_instance_valid(host) else self
	
	var new_node := _get_new_instance(parent)
	
	if not new_node:
		return null
	
	new_node.global_transform = spawn_transform
	
	active_nodes.append(new_node)
	node_spawned.emit(new_node)
	
	return new_node


func kill(node: Node3D):
	if node in active_nodes:
		active_nodes.erase(node)
	_dispose(node)


func clear():
	var targets := active_nodes.duplicate()
	for node in targets:
		kill(node)
