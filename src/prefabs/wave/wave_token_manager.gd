class_name WaveTokenManager3D
extends WaveManager3D


@export_group("Difficulty", "difficulty")
@export var difficulty_curve: Curve
@export var difficulty_floor: float = 0.1
@export var difficulty_multiplier: float = 1.0
@export_group("Tokens", "tokens")
@export var tokens_min: float = 0.0
@export var tokens_max: float = INF
@export var tokens_start: float

var waves_affordable: Array[Wave]
var tokens: float:
	set(value):
		if value == tokens:
			return
		tokens = clampf(value, tokens_min, tokens_max)
		_update_waves_affordable()
var tokens_ratio: float:
	set(value):
		if is_nan(value):
			return
		var max_ref := tokens_max
		if is_inf(max_ref):
			var difficulties := _get_available_wave_difficulties()
			max_ref = (difficulties.max()
				if not difficulties.is_empty() else 0.0)
		var total_range := max_ref - tokens_min
		var target_ratio := clampf(value, 0.0, 1.0)
		
		tokens = tokens_min + (target_ratio * total_range)
	get():
		var max_ref := tokens_max
		if is_inf(max_ref):
			var difficulties := _get_available_wave_difficulties()
			max_ref = (difficulties.max()
				if not difficulties.is_empty() else 0.0)
		var total_range := max_ref - tokens_min
		if total_range <= 0.0:
			return 0.0
		
		return clampf((tokens - tokens_min) / total_range, 0.0, 1.0)


func _ready():
	super()
	tokens = tokens_start
	_update_waves_affordable()


func _get_next_wave() -> Wave:
	var total_weight := 0.0
	var weights: Array[float] = []
	
	for wave in waves_affordable:
		var weight := wave.difficulty
		weights.append(weight)
		total_weight += weight
	
	var roll := _rng.randf_range(0.0, total_weight)
	var current_sum := 0.0
	
	for i in range(waves_affordable.size()):
		current_sum += weights[i]
		if roll <= current_sum:
			return waves_affordable[i]
	
	return null


func _get_available_wave_difficulties() -> Array[float]:
	var difficulties: Array[float]
	for wave in waves_available:
		if wave: difficulties.append(wave.difficulty)
	return difficulties


func _get_token_cashback(wave: Wave) ->  float:
	var difficulties := _get_available_wave_difficulties()
	var difficulty_min := (
		difficulties.min() as float
		if not difficulties.is_empty() else 0.0)
	var difficulty_max := (
		difficulties.max() as float
		if not difficulties.is_empty() else 0.0)
	var difficulty_range := difficulty_max - difficulty_min
	var difficulty_curve_value := difficulty_curve.sample(progress) if difficulty_curve else progress
	var difficulty := max(difficulty_curve_value * difficulty_multiplier, difficulty_floor) as float
	
	var wave_difficulty := wave.difficulty if wave else 0.0
	var wave_weight := (wave_difficulty - difficulty_min) / difficulty_range if difficulty_range > 0.0 else 0.5
	
	var cashback_min := difficulty_min * difficulty
	var cashback_max := difficulty_max * difficulty
	
	return lerp(cashback_max, cashback_min, wave_weight)


func _update_waves_affordable():
	waves_affordable.clear()
	for wave in waves_available:
		if wave and wave.difficulty <= tokens:
			waves_affordable.append(wave)


func spawn_wave(wave: Wave) -> bool:
	if not wave:
		push_warning("Trying to spawn a null wave.")
		return false
	tokens += _get_token_cashback(wave) - wave.difficulty
	return super(wave)


func spawn_next_wave() -> Wave:
	if waves_affordable.is_empty():
		tokens += _get_token_cashback(null)
		return null
	return super()
