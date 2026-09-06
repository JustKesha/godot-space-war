@icon("uid://buwc32hqkdtgd")
class_name Obstacle3D
extends DurableEntity3D


@export var difficulty: float

@onready var sprite: AnimatedSprite3D = %Sprite


func _dispose():
	if Game.current_level:
		Game.current_level.obstacles.dispose(self)
	else:
		super()
