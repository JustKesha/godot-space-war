@icon("uid://b4gim56t7ug4b")
class_name Player3D
extends Combatant3D


@onready var score: ScoreComponent = %Score
@onready var controller: CombatantPlayerController = %Controller


func _ready():
	super()
	Events.player_spawned.emit(self)


func _dispose():
	if Game.current_level:
		Game.current_level.players.dispose(self)
	else:
		super()


func destroy():
	super()
	var killer_signature := Utils.get_instance_signature(_last_damage_source)
	Events.player_destroyed.emit(self, killer_signature)
