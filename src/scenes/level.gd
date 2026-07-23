@icon("uid://r2615y8g1wmf")
class_name Level
extends Node3D


@onready var projectiles: NodePoolManager3D = %Projectiles
@onready var obstacles: NodePoolManager3D = %Obstacles


func _ready():
	Game.current_level = self


func clean():
	projectiles.trim()


func clear():
	projectiles.clear()
