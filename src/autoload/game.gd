@icon("uid://bj4owk0up2q8v")
extends Node


var current_level: Level


func _input(event: InputEvent):
	if current_level:
		if event.is_action_pressed('restart'):
			current_level.restart()
