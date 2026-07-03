@icon("uid://b808fds8dfmmq")
class_name WeightedResourceDeck
extends Resource
## High-performance, infinite data queue that manages a pre-populated sequence
## of [WeightedResource] objects.
##
## Uses a circular buffer to provide instant look-ahead and mid-queue modification 
## without memory shifting or performance lag. Supports both randomized batch 
## shuffling and strict sequential iteration based on generation weights.


## The number of elements pre-loaded into the queue at all times;
## See [method preview].
@export var queue_size: int = 50:
	set(value):
		queue_size = value
		_on_changed()
## If [code]true[/code], elements for the queue are randomized in batches.
## [br][br][param deck]:    [code]A (weight: 2), B (weight: 1)[/code]
## [br]queue:    [code]A,B,A[/code]    [code]B,A,A[/code]    . . .
## [br][br]If [code]false[/code], they follow an ascending sequence of the [member deck].
## [br][br][param deck]:    [code]A (weight: 2), B (weight: 1)[/code]
## [br]queue:    [code]A,A,B[/code]    [code]A,A,B[/code]    . . .
@export var shuffle: bool = true:
	set(value):
		shuffle = value
		_on_changed()
## The source array of resources and their respective weights for the queue.
@export var deck: Array[WeightedResource]:
	set(value):
		deck = value
		_on_changed()
## If [code]true[/code], automatically calls [method rebuild] whenever this
## resource emits [signal changed]. If [code]false[/code], the active queue will
## not recieve any changed up until the new elements arrive.
## [br][br][b]Note:[/b] This does not apply for the [member deck]'s array
## modifications, only property set calls ([code]property = value[/code]).
@export var auto_rebuild: bool = true:
	set(value):
		auto_rebuild = value
		_on_changed()

var _runtime_buffer: Array[Resource] = []
var _donor_deck: Array[Resource] = []
var _head_index: int = 0
var _sequence_index: int = 0
var _total_deck_weight: int = 0


func _on_changed():
	changed.emit()
	if auto_rebuild: rebuild()


func _pull_next_resource() -> Resource:
	if shuffle:
		if _donor_deck.is_empty():
			_generate_shuffled_donor()
			if _donor_deck.is_empty():
				return null
		return _donor_deck.pop_back()
	else:
		return _get_ordered_resource_at_sequence()


func _generate_shuffled_donor():
	_donor_deck.clear()
	for item in deck:
		if not item or not item.value:
			continue
		for i in range(max(0, item.weight)):
			_donor_deck.append(item.value)
	_donor_deck.shuffle()


func _get_ordered_resource_at_sequence() -> Resource:
	if _total_deck_weight == 0:
		return null
	
	var target_weight_idx = _sequence_index % _total_deck_weight
	_sequence_index += 1
	
	var current_weight_accumulator = 0
	for item in deck:
		if not item or not item.value:
			continue
		current_weight_accumulator += max(0, item.weight)
		if target_weight_idx < current_weight_accumulator:
			return item.value
	
	return null


## Completely clears and rebuilds the resource queue from scratch.
func rebuild():
	_runtime_buffer.clear()
	_donor_deck.clear()
	_head_index = 0
	_sequence_index = 0
	_total_deck_weight = 0
	
	if deck.is_empty() or queue_size <= 0:
		return
	
	for item in deck:
		if item: 
			_total_deck_weight += max(0, item.weight)
	
	_runtime_buffer.resize(queue_size)
	for i in range(queue_size):
		var next_res = _pull_next_resource()
		if not next_res:
			_runtime_buffer.resize(i)
			break
		_runtime_buffer[i] = next_res


## Returns an array containing the specified number of upcoming resources from
## the queue. The returned array length cannot be greater than
## [member queue_size]. Any [param count] value below [code]0[/code] will
## default it to [member queue_size].
func preview(count: int = -1) -> Array[Resource]:
	var preview_list: Array[Resource] = []
	var buffer_size = _runtime_buffer.size()
	
	if buffer_size == 0 and not deck.is_empty() and queue_size > 0:
		rebuild()
		buffer_size = _runtime_buffer.size()
	
	if buffer_size == 0:
		return preview_list
	
	if count < 0:
		count = queue_size
	
	var limit = min(count, buffer_size)
	for i in range(limit):
		var target_idx = (_head_index + i) % buffer_size
		preview_list.append(_runtime_buffer[target_idx])
	
	return preview_list


## Overwrites a specific item in queue at given [param depth_index], where
## [code]0[/code] represents the immediate next item to be drawn. Returns the
## replaced [Resource] object, or [code]null[/code] if the index is out of bounds.
func modify_queue_at(depth_index: int, new_resource: Resource) -> Resource:
	var buffer_size = _runtime_buffer.size()
	if depth_index >= 0 and depth_index < buffer_size:
		var target_idx = (_head_index + depth_index) % buffer_size
		var old_resource = _runtime_buffer[target_idx]
		_runtime_buffer[target_idx] = new_resource
		return old_resource
	return null


## Draws the specified number of resources from the queue.
func draw(count: int = 1) -> Array[Resource]:
	var drawn_items: Array[Resource] = []
	var buffer_size = _runtime_buffer.size()
	
	if buffer_size == 0 and not deck.is_empty() and queue_size > 0:
		rebuild()
		buffer_size = _runtime_buffer.size()
	
	if buffer_size == 0 or count <= 0:
		return drawn_items
	
	for i in range(count):
		var item = _runtime_buffer[_head_index]
		drawn_items.append(item)
		
		var new_item = _pull_next_resource()
		if new_item:
			_runtime_buffer[_head_index] = new_item
			_head_index = (_head_index + 1) % buffer_size
	
	return drawn_items


## Draws a single resource from the queue.
func draw_next() -> Resource:
	var results = draw(1)
	if results.is_empty():
		return null
	return results[0]
