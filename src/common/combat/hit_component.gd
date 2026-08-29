@icon("uid://clnmc1wtig47a")
class_name HitComponent3D
extends CombatArea3D
## Component that deals damage to [HurtComponent3D] nodes when they enter the area.


## Emitted when this [HitComponent3D] hits a [HurtComponent3D] successfully
## (meaning [method can_damage] returns [code]true[/code]),
## or when the [method apply_hit] is called manually.
signal hit(hurt_component: HurtComponent3D)
## Emitted when the [member damage] is changed.
signal damage_changed(new_damage: float)

## The damage amount this [HitComponent3D] will deal on hit.
## See [method apply_hit] and [method HurtComponent3D.take_damage].
@export var damage: float:
	set(value):
		if value == damage:
			return
		damage = value
		damage_changed.emit(damage)
## The maximum number of successful collisions per frame.
## Leave at [code]-1[/code] to remove the limit
@export var hit_limit_per_frame: int = -1

var _frame_hit: int = -1
var _frame_hit_count: int


func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D):
	var hurt_component := area as HurtComponent3D
	
	if can_damage(hurt_component):
		apply_hit(hurt_component)


## Returns [code]true[/code] if this [HitComponent3D] is allowed to damage
## given [param hurt_component].
func can_damage(hurt_component: HurtComponent3D) -> bool:
	if hit_limit_per_frame > 0:
		var current_frame := Engine.get_physics_frames()
		if _frame_hit == current_frame and _frame_hit_count >= hit_limit_per_frame:
			return false
	
	if not hurt_component or hurt_component.team == team:
		return false
	
	return true


## Manually apply the hit effect without waiting for this [HitComponent3D]
## to hit given [param hurt_component].
## [br][br][b]Note:[/b] This will ignore the [method can_damage]'s evaluation.
func apply_hit(hurt_component: HurtComponent3D):
	if not hurt_component:
		return
	
	var current_frame := Engine.get_physics_frames()
	if _frame_hit != current_frame:
		_frame_hit = current_frame
		_frame_hit_count = 0
	_frame_hit_count += 1
	
	hurt_component.take_damage(damage, self)
	hit.emit(hurt_component)
