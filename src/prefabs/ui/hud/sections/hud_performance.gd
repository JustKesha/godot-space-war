class_name HUDPerformanceSection
extends HUDSection


@onready var fps: Label = %FPS


func _on_updated():
	fps.text = "FPS: " + str(int(Engine.get_frames_per_second()))
