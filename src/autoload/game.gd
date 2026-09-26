@icon("uid://bj4owk0up2q8v")
extends Node


signal pause_changed()

enum DebugMode { OFF, FEW, ALL }

var paused: bool:
	set(value):
		if value == paused:
			return
		paused = value
		get_tree().paused = paused
		pause_changed.emit()
var debug_mode: DebugMode:
	set(value):
		debug_mode = value
		_apply_debug()
var show_debug_hints: bool:
	set(value):
		if value == show_debug_hints:
			return
		show_debug_hints = value
		
		get_tree().debug_collisions_hint = show_debug_hints
		get_tree().debug_navigation_hint = show_debug_hints
		get_tree().debug_paths_hint = show_debug_hints
		
		Utils.update_debug_hints(get_tree().root)
var current_level: Level:
	set(value):
		current_level = value
		_apply_debug()


func _init():
	self.process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent):
	if not current_level:
		return
	
	if event.is_action_pressed('restart'):
		current_level.restart()
	if event.is_action_pressed('pause'):
		paused = not paused
	elif event.is_action_pressed('debug_all'):
		debug_mode = DebugMode.ALL if debug_mode != DebugMode.ALL else DebugMode.OFF
	elif event.is_action_pressed('debug_few'):
		debug_mode = DebugMode.FEW if debug_mode != DebugMode.FEW else DebugMode.OFF


func _apply_debug():
	if not current_level:
		return
	
	match debug_mode:
		DebugMode.OFF:
			current_level.hud.debug.hide()
			show_debug_hints = false
		DebugMode.FEW:
			current_level.hud.debug.show()
			current_level.hud.debug_performance.show()
			current_level.hud.debug_entities.hide()
			show_debug_hints = false
		DebugMode.ALL:
			current_level.hud.debug.show()
			current_level.hud.debug_performance.show()
			current_level.hud.debug_entities.show()
			show_debug_hints = true
