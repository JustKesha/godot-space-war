@icon("uid://cgbekgdgiu8l1")
class_name HUD
extends CanvasLayer


@onready var progress: HUDProgressSection = %Progress
@onready var players: HUDPlayersSection = %Players
@onready var pause: HUDPauseSection = $Pause
@onready var debug: VBoxContainer = %Debug
@onready var debug_performance: HUDPerformanceSection = %Performance
@onready var debug_entities: HUDEntitiesSection = %Entities
@onready var build: VBoxContainer = %Build
@onready var build_version: Label = %Version


func _ready():
	var game_version := ProjectSettings.get_setting("application/config/version") as String
	if game_version:
		build_version.text = "v" + game_version
