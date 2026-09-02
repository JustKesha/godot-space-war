@icon("uid://dk1xubitf0jf0")
class_name PlayerPreset3D
extends CombatantPreset3D


@export_group("Controller", "controller")
@export var controller_controls: Dictionary[CombatantPlayerController.Controls, String] = {
	CombatantPlayerController.Controls.LEFT: "ui_left",
	CombatantPlayerController.Controls.RIGHT: "ui_right",
	CombatantPlayerController.Controls.UP: "ui_up",
	CombatantPlayerController.Controls.DOWN: "ui_down",
	CombatantPlayerController.Controls.SHOOT: "ui_accept",
	}:
	set(value):
		if controller_controls == value:
			return
		controller_controls = value
		_on_changed()
@export var controller_disabled: bool:
	set(value):
		if controller_disabled == value:
			return
		controller_disabled = value
		_on_changed()


func apply(entity: Entity3D) -> bool:
	var player := entity as Player3D
	
	if not player:
		push_error("Could not apply preset. Recieved entity is not a player.")
		return false
	
	player.controller.controls = controller_controls
	player.controller.disabled = controller_disabled
	
	return super(entity)
