@icon("uid://cgbekgdgiu8l1")
class_name HUD
extends CanvasLayer


@onready var progress_section: Control = %Progress
@onready var progress_bar: Label = %ProgressBar
@onready var progress_info: Label = %ProgressInfo


func _init():
	Events.wave_spawned.connect(_on_wave_spawned)


func _ready():
	progress_section.hide()


func _on_wave_spawned(_wave: Wave):
	update_progress_section()


func update_progress_section():
	if not Game.current_level:
		return
	
	var progress := Game.current_level.wave_manager.progress
	
	progress_bar.text = Utils.get_ascii_progress_bar(progress, 20, "█", "░")
	progress_info.text = str(int(progress * 100)) + '%'
	progress_section.show()
