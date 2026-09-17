@icon("uid://b4gim56t7ug4b")
class_name Player3D
extends Combatant3D


@onready var score: ScoreComponent = %Score
@onready var controller: CombatantPlayerController = %Controller


func _dispose():
	if Game.current_level:
		Game.current_level.players.dispose(self)
	else:
		super()
