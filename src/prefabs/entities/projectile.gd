@icon("uid://c0hhedisi05ok")
class_name Projectile3D
extends Entity3D


@onready var mesh: MeshInstance3D = %Mesh


func destroy():
	if not Game.current_level:
		return super()
	
	Game.current_level.projectiles.kill(self)
	destroyed.emit()
