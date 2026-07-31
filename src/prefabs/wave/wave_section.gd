@icon("uid://djvwm5wvb7ejx")
class_name WaveSection
extends Resource


@export var obstacle: ObstaclePreset3D
@export var position: Vector3

var difficulty:
	get():
		if not obstacle:
			return 0
		return obstacle.difficulty
