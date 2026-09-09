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
