@icon("uid://cswgyovsmhj7i")
class_name Utils
extends Node


# --- Strings ------------------------------------------------------------------

static func get_ascii_progress_bar(
	progress: float,
	width: int = 10,
	char_fill: String = "#",
	char_empty: String = "-",
	bracket_left: String = "",
	bracket_right: String = "",
	) -> String:
	progress = clampf(progress, 0.0, 1.0)
	
	var count_fill := int(progress * width)
	var count_empty := width - count_fill
	var track_filled := char_fill.repeat(count_fill)
	var track_empty := char_empty.repeat(count_empty)
	
	return bracket_left + track_filled + track_empty + bracket_right


static func format_number(value: float, max_decimals: int = -1,
	round_to_nearest: bool = true, inf_str: String = "INF") -> String:
	if is_inf(value):
		return ("" if value > 0 else "-") + inf_str
	if max_decimals >= 0:
		if round_to_nearest:
			value = snappedf(value, pow(10, -max_decimals))
		else:
			var multiplier: float = pow(10, max_decimals)
			value = floorf(value * multiplier) / multiplier
	
	if is_equal_approx(value, round(value)):
		return str(int(value))
	return str(value)


# --- Nodes --------------------------------------------------------------------

static func update_debug_hints(node: Node, recursive: bool = true):
	if not is_instance_valid(node) or not node.is_inside_tree():
		return
	
	var is_hint_node: bool = (
		node is CollisionShape2D or
		node is CollisionPolygon2D or
		node is CollisionShape3D or
		node is CollisionPolygon3D or
		node is NavigationRegion2D or
		node is NavigationRegion3D or
		node is Path2D or
		node is Path3D
		)
	
	if is_hint_node:
		var parent := node.get_parent()
		if parent:
			parent.remove_child(node)
			parent.add_child(node)
	
	if recursive:
		for child in node.get_children():
			update_debug_hints(child, true)


# --- Instance Signatures ------------------------------------------------------

const SIGNATURE_META_NAME: String = "signature"


static func get_instance_signature(instance: Node) -> int:
	if is_instance_valid(instance):
		return instance.get_meta(SIGNATURE_META_NAME, 0)
	return -1


static func set_instance_signature(instance: Node, signature: int):
	if is_instance_valid(instance):
		instance.set_meta(SIGNATURE_META_NAME, signature)


static func generate_instance_signature(instance: Node) -> int:
	if is_instance_valid(instance) and instance.is_inside_tree():
		return int(
			str(instance.get_instance_id()) +
			str(instance.get_tree().get_frame())
			)
	return -1


static func generate_and_set_instance_signature(instance: Node):
	set_instance_signature(instance, generate_instance_signature(instance))


static func has_signature(instance: Node) -> bool:
	if not is_instance_valid(instance):
		return false
	return instance.has_meta(SIGNATURE_META_NAME)


static func clear_signature(instance: Node):
	if is_instance_valid(instance):
		instance.remove_meta(SIGNATURE_META_NAME)


static func sign_instance(instance: Node, signer: Node):
	set_instance_signature(instance, get_instance_signature(signer))


static func match_signatures(signature_a: int, signature_b: int) -> bool:
	if signature_a + signature_b <= 0:
		return false
	return signature_a == signature_b


static func match_instance_signatures(instance_a: Node, instance_b: Node) -> bool:
	if not has_signature(instance_a) or not has_signature(instance_b):
		return false
	return match_signatures(
		get_instance_signature(instance_a),
		get_instance_signature(instance_b),
	)
