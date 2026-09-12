@icon("uid://bj4owk0up2q8v")
extends Node


enum DebugMode { OFF, FEW, ALL }

var debug_mode: DebugMode:
	set(value):
		debug_mode = value
		_apply_debug()
var current_level: Level:
	set(value):
		current_level = value
		_apply_debug()


func _apply_debug():
	if not current_level:
		return
	
	match debug_mode:
		DebugMode.OFF:
			current_level.hud.debug.hide()
		DebugMode.FEW:
			current_level.hud.debug.show()
			current_level.hud.debug_performance.show()
			current_level.hud.debug_entities.hide()
		DebugMode.ALL:
			current_level.hud.debug.show()
			current_level.hud.debug_performance.show()
			current_level.hud.debug_entities.show()


func _input(event: InputEvent):
	if not current_level:
		return
	
	if event.is_action_pressed('restart'):
		current_level.restart()
	elif event.is_action_pressed('debug_all'):
		debug_mode = DebugMode.ALL if debug_mode != DebugMode.ALL else DebugMode.OFF
	elif event.is_action_pressed('debug_few'):
		debug_mode = DebugMode.FEW if debug_mode == DebugMode.OFF else DebugMode.OFF
