@icon("uid://8tsxkpn1ryfe")
class_name ObstaclePreset3D
extends DurableEntityPreset3D


@export var difficulty: float = 1.0:
	set(value):
		if difficulty == value:
			return
		difficulty = value
		_on_changed()
@export_group("Sprite", "sprite")
@export var sprite_frames: SpriteFrames:
	set(value):
		if sprite_frames and sprite_frames.changed.is_connected(_on_changed):
			sprite_frames.changed.disconnect(_on_changed)
		sprite_frames = value
		_on_changed()
		if sprite_frames and not sprite_frames.changed.is_connected(_on_changed):
			sprite_frames.changed.connect(_on_changed)
@export var sprite_billboard := BaseMaterial3D.BillboardMode.BILLBOARD_FIXED_Y:
	set(value):
		if sprite_billboard == value:
			return
		sprite_billboard = value
		_on_changed()


func apply(entity: Entity3D) -> bool:
	var obstacle := entity as Obstacle3D
	
	if not obstacle:
		push_error("Could not apply preset. Recieved entity is not an obstacle.")
		return false
	
	obstacle.sprite.sprite_frames = sprite_frames
	obstacle.sprite.billboard = sprite_billboard
	
	return super(entity)
