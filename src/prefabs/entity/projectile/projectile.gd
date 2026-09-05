@icon("uid://c0hhedisi05ok")
class_name Projectile3D
extends Entity3D


@onready var mesh: MeshInstance3D = %Mesh


func _dispose():
	if Game.current_level:
		Game.current_level.projectiles.kill(self)
	else:
		super()
