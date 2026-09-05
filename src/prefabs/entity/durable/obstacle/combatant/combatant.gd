@icon("uid://c5qmnd3ynrlhn")
class_name Combatant3D
extends Obstacle3D


@onready var gun: ShootComponent3D = %Gun


func _ready():
	gun.reset_cooldown()
	super()


func _update_team():
	if gun: gun.team = team
	super()


func _dispose():
	if Game.current_level:
		Game.current_level.combatants.kill(self)
	else:
		super()
