class_name HUDProgressSection
extends HUDSection


@onready var bar: Label = %Bar
@onready var info: Label = %Info


func _ready():
	Events.wave_spawned.connect(_on_wave_spawned)
	super()


func _on_wave_spawned(_wave: Wave):
	show()
	update()


func _on_updated():
	var progress := ( 
		Game.current_level.wave_manager.progress
		if is_instance_valid(Game.current_level) else 0.0
		)
	
	bar.text = Utils.get_ascii_progress_bar(progress, 20, "█", "░")
	info.text = str(int(progress * 100)) + '%'
