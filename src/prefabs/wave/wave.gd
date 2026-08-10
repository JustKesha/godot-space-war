@icon("uid://13dmr7mavy8h")
class_name Wave
extends Resource


@export var sections: Array[WaveSection]

var difficulty: float:
	get():
		var total_difficulty := 0.0
		for section in sections:
			if not section:
				continue
			total_difficulty += section.difficulty
		return total_difficulty
var bounds: AABB:
	get():
		if sections.is_empty():
			return AABB()
		
		var first_valid_pos := Vector3.ZERO
		for obstacle in sections:
			if obstacle:
				first_valid_pos = obstacle.position
				break
		
		var aabb := AABB(first_valid_pos, Vector3.ZERO)
		for obstacle in sections:
			if not obstacle:
				continue
			aabb = aabb.expand(obstacle.position)
		
		return aabb
