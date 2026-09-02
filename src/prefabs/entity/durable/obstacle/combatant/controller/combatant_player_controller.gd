class_name CombatantPlayerController
extends CombatantController


enum Controls {
	LEFT,
	RIGHT,
	UP,
	DOWN,
	SHOOT,
	}

@export var controls: Dictionary[Controls, String] = {
	Controls.LEFT: "ui_left",
	Controls.RIGHT: "ui_right",
	Controls.UP: "ui_up",
	Controls.DOWN: "ui_down",
	Controls.SHOOT: "ui_accept",
	}


func _input(_event: InputEvent):
	if not disabled:
		update()


func get_input_vector() -> Vector2:
	return Vector2(
		(1.0 if controls.has(Controls.RIGHT) and Input.is_action_pressed(controls[Controls.RIGHT]) else 0.0) -
		(1.0 if controls.has(Controls.LEFT) and Input.is_action_pressed(controls[Controls.LEFT]) else 0.0),
		(1.0 if controls.has(Controls.UP) and Input.is_action_pressed(controls[Controls.UP]) else 0.0) -
		(1.0 if controls.has(Controls.DOWN) and Input.is_action_pressed(controls[Controls.DOWN]) else 0.0),
		)


func get_movement_direction() -> Vector3:
	var input_direction := get_input_vector()
	return Vector3(input_direction.x, input_direction.y, 0.0)


func get_shooting_state() -> bool:
	return controls.has(Controls.SHOOT) and Input.is_action_pressed(controls[Controls.SHOOT])
