class_name HUDEntitiesSection
extends HUDSection


@onready var entities: Label = %Entities
@onready var projectiles: Label = %Projectiles
@onready var obstacles: Label = %Obstacles
@onready var combatants: Label = %Combatants


func _ready():
	Events.entity_spawned.connect(_on_entity_spawned)
	Events.entity_destroyed.connect(_on_entity_destroyed)
	super()


func _on_entity_spawned(_entity: Entity3D):
	update()


func _on_entity_destroyed(_entity: Entity3D, _killer_signature: int):
	update()


func _on_updated():
	var level := Game.current_level
	
	entities.text = "Entities: " + str(get_tree().get_node_count_in_group("entities"))
	projectiles.text = "Projectiles: " + str(level.projectiles.get_total_instance_count())
	obstacles.text = "Obstacles: " + str(level.obstacles.get_total_instance_count())
	combatants.text = "Combatants: " + str(level.combatants.get_total_instance_count())
