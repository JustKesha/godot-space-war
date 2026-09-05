@icon("uid://buwc32hqkdtgd")
class_name Obstacle3D
extends DurableEntity3D


@onready var sprite: AnimatedSprite3D = %Sprite


func _dispose():
	if Game.current_level:
		Game.current_level.obstacles.kill(self)
	else:
		super()
