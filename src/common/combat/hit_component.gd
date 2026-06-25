@icon("uid://clnmc1wtig47a")
class_name HitComponent3D
extends CombatArea3D


signal hit(hurt_component: HurtComponent3D)
signal damage_changed(new_damage: float)

@export var damage: float:
	set(value):
		if value == damage:
			return
		damage = value
		damage_changed.emit(damage)


func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D):
	var hurt_component := area as HurtComponent3D
	
	if can_damage(hurt_component):
		apply_hit(hurt_component)


func can_damage(hurt_component: HurtComponent3D) -> bool:
	if not hurt_component or hurt_component.team == team:
		return false
	
	return true


func apply_hit(hurt_component: HurtComponent3D):
	if not hurt_component:
		return
	
	hurt_component.take_damage(damage, self)
	hit.emit(hurt_component)
