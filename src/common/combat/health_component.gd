@icon("uid://ouljbstk6cey")
class_name HealthComponent
extends Node


signal health_changed(new_value: float)
signal health_increased(by_amount: float)
signal health_decreased(by_amount: float)

enum ModifyOperation {
	INCREASE = 1,
	DECREASE = -1,
	}

@export var start_ratio: float = 1.0
@export_group("Limits", "points")
@export var points_min: float = 0
@export var points_max: float = INF
@export_group("Increase", "increase")
@export var increase_ratio: float = 1.0
@export var increase_threshold: float = 0.0
@export_group("Decrease", "decrease")
@export var decrease_ratio: float = 1.0
@export var decrease_threshold: float = 0.0

var _start_ratio_applied: bool
var points: float = 1.0:
	set(value):
		value = clampf(value, points_min, points_max)
		if points == value:
			return
		
		var points_old := points
		points = value
		
		if not _start_ratio_applied:
			return
		
		health_changed.emit(points)
		if points > points_old:
			health_increased.emit(points - points_old)
		else:
			health_decreased.emit(points_old - points)


func _ready():
	if is_finite(points_max):
		points = points_max * start_ratio
	else:
		points = start_ratio
	_start_ratio_applied = true


func modify(operation: ModifyOperation, amount: float, threshold: float = 0.0,
	ratio: float = 1.0) -> float:
	if amount <= 0 or amount <= threshold:
		return 0
	
	amount = clampf(amount * ratio, 0, INF)
	
	match operation:
		ModifyOperation.INCREASE: points += amount
		ModifyOperation.DECREASE: points -= amount
	
	return amount


func increase(amount: float) -> float:
	return modify(ModifyOperation.INCREASE, amount, increase_threshold, increase_ratio)


func decrease(amount: float) -> float:
	return modify(ModifyOperation.DECREASE, amount, decrease_threshold, decrease_ratio)
