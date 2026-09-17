class_name HUDPlayersSection
extends HUDSection


@export var player_section_packed_scene: PackedScene

var player_sections: Dictionary[int, HUDPlayerSection]


func _ready():
	Events.player_spawned.connect(_on_player_spawned)
	Events.player_destroyed.connect(_on_player_destroyed)
	super()


func _on_player_spawned(player: Player3D):
	add_player_section.call_deferred(player)


func _on_player_destroyed(player: Player3D, _killer_signature: int):
	remove_player_section(player)


func _on_updated():
	for player in Game.current_level.get_players():
		add_player_section(player)


func _remove_section(section_key: int):
	var player_section := player_sections.get(section_key) as HUDPlayerSection
	
	if not player_section:
		return
	
	player_sections.erase(section_key)
	player_section.queue_free()


func has_player_section(player: Player3D) -> bool:
	if not is_instance_valid(player):
		return false
	var player_key := Utils.get_instance_signature(player)
	if player_sections.keys().has(player_key):
		return true
	return false


func get_player_section(player: Player3D) -> HUDPlayerSection:
	if not is_instance_valid(player):
		return null
	var player_key := Utils.get_instance_signature(player)
	return player_sections.get(player_key)


func add_player_section(player: Player3D) -> HUDPlayerSection:
	if not is_instance_valid(player):
		return null
	if has_player_section(player):
		return get_player_section(player)
	
	if( not player_section_packed_scene or
		not player_section_packed_scene.can_instantiate() ):
		return null
	
	var new_player_key := Utils.get_instance_signature(player)
	var new_player_section := player_section_packed_scene.instantiate() as HUDPlayerSection
	
	player_sections[new_player_key] = new_player_section
	
	new_player_section.name = player.name
	new_player_section.player = player
	add_child(new_player_section)
	
	return new_player_section


func remove_player_section(player: Player3D) -> bool:
	if not is_instance_valid(player):
		return false
	
	var player_section := get_player_section(player)
	
	if not player_section:
		return false
	
	var player_key := Utils.get_instance_signature(player)
	
	_remove_section(player_key)
	
	return true


func clear():
	for section_key in player_sections.keys():
		_remove_section(section_key)
