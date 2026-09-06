@icon("uid://c5qmnd3ynrlhn")
class_name Combatant3D
extends Obstacle3D


@onready var gun: ShootComponent3D = %Gun


func _ready():
	super()
	gun.reset_cooldown()


func _update_team():
	super()
	if gun: gun.team = team


func _dispose():
	if Game.current_level:
		Game.current_level.combatants.dispose(self)
	else:
		super()


func _on_projectile_fired(projectile: Projectile3D):
	if is_instance_valid(projectile):
		projectile.set_signature(get_signature())
