@icon("uid://cgbekgdgiu8l1")
class_name HUD
extends CanvasLayer


@onready var progress: HUDProgressSection = %Progress
@onready var debug: Control = %Debug
@onready var debug_performance: HUDPerformanceSection = %Performance
@onready var debug_entities: HUDEntitiesSection = %Entities
