class_name HUDPlayerSection
extends HUDSection


@export var player: Player3D:
	set(value):
		if value == player:
			return
		_disconnect_signals()
		player = value
		_connect_signals()
		update()

@onready var nickname: Label = %Nickname
@onready var health: Label = %Health
@onready var score: Label = %Score


func _connect_signals():
	if not is_instance_valid(player):
		return
	player.health.value_changed.connect(_on_player_health_changed)
	player.health.maximum_value_changed.connect(update)
	player.score.value_changed.connect(_on_player_score_changed)
	player.destroyed.connect(_on_player_destroyed)
	player.tree_exiting.connect(_on_player_exiting_tree)


func _disconnect_signals():
	if not is_instance_valid(player):
		return
	if player.health.value_changed.is_connected(_on_player_health_changed):
		player.health.value_changed.disconnect(_on_player_health_changed)
	if player.health.maximum_value_changed.is_connected(update):
		player.health.maximum_value_changed.disconnect(update)
	if player.score.value_changed.is_connected(_on_player_score_changed):
		player.score.value_changed.disconnect(_on_player_score_changed)
	if player.destroyed.is_connected(_on_player_destroyed):
		player.destroyed.disconnect(_on_player_destroyed)
	if player.tree_exiting.is_connected(_on_player_exiting_tree):
		player.tree_exiting.disconnect(_on_player_exiting_tree)


func _on_player_score_changed(_new_value: float):
	update()


func _on_player_health_changed(_new_value: float):
	update()


func _on_player_destroyed(_killer_signature: int):
	_disconnect_signals()
	hide()


func _on_player_exiting_tree():
	_disconnect_signals()
	hide()


func _on_updated():
	if not is_instance_valid(player):
		return
	
	var hp := player.health.value
	var hp_max := player.health.value_max
	
	nickname.text = player.name
	score.text = "XP: " + Utils.format_number(player.score.value, 2)
	health.text = (
		"HP: " + Utils.format_number(hp, 2)
		+ (("/" + Utils.format_number(hp_max, 2) if not is_inf(hp_max) else ""))
		)
