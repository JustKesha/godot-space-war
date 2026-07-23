@icon("uid://buwc32hqkdtgd")
class_name Obstacle3D
extends DurableEntity3D


@onready var sprite: AnimatedSprite3D = %Sprite


func destroy():
	if not Game.current_level:
		return super()
	
	Game.current_level.obstacles.kill(self)
	destroyed.emit()
