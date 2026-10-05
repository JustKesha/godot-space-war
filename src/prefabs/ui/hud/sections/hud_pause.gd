class_name HUDPauseSection
extends HUDSection


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Game.pause_changed.connect(update)
	super()


func _on_updated():
	visible = Game.paused
