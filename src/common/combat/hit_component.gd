@icon("uid://c0hhedisi05ok")
class_name HitComponent3D
extends CombatArea3D


signal hit(hurt_component: HurtComponent3D)
signal team_changed(new_team: Team)
signal damage_changed(new_damage: float)

@export var team: Team:
	set(value):
		if value == team:
			return
		team = value
		team_changed.emit(team)
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
	
	if not hurt_component:
		return
	
	hurt_component.take_damage(damage, self)
	hit.emit(hurt_component)
