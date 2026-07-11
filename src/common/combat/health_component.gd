@icon("uid://ouljbstk6cey")
class_name HealthComponent
extends Node


signal value_changed(new_value: float)
signal value_increased(by_amount: float)
signal value_decreased(by_amount: float)
signal maximum_value_reached()
signal minimum_value_reached()

enum ModifyOperation {
	INCREASE = 1,
	DECREASE = -1,
	}

@export_group("Start", "start")
@export var start_ratio: float = 0.0
@export var start_bonus: float = 1.0
@export_group("Limits", "value")
@export var value_min: float = 0
@export var value_max: float = INF
@export_group("Increase", "increase")
@export var increase_ratio: float = 1.0
@export var increase_threshold: float = 0.0
@export_group("Decrease", "decrease")
@export var decrease_ratio: float = 1.0
@export var decrease_threshold: float = 0.0

var _value: float = 0.0
var value: float:
	set(value): _set_value(value)
	get(): return _value


func _ready():
	reset()


func _set_value(new_value: float, emit_signals: bool = true):
	if is_nan(new_value):
		return
	
	new_value = clampf(new_value, value_min, value_max)
	
	if value == new_value:
		return
	
	var value_old := value
	_value = new_value
	
	if not emit_signals:
		return
	
	value_changed.emit(value)
	if value > value_old:
		value_increased.emit(value - value_old)
		if value == value_max:
			maximum_value_reached.emit()
	else:
		value_decreased.emit(value_old - value)
		if value == value_min:
			minimum_value_reached.emit()


func reset():
	var start_base := value_max * start_ratio
	
	if is_nan(start_base):
		start_base = 0.0
	
	_set_value(start_base + start_bonus, false)


func modify(operation: ModifyOperation, amount: float, threshold: float = 0.0,
	ratio: float = 1.0) -> float:
	if amount <= 0 or amount <= threshold:
		return 0
	
	amount = clampf(amount * ratio, 0, INF)
	
	match operation:
		ModifyOperation.INCREASE: value += amount
		ModifyOperation.DECREASE: value -= amount
	
	return amount


func increase(amount: float) -> float:
	return modify(ModifyOperation.INCREASE, amount, increase_threshold, increase_ratio)


func decrease(amount: float) -> float:
	return modify(ModifyOperation.DECREASE, amount, decrease_threshold, decrease_ratio)
