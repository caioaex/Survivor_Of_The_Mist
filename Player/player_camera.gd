extends Camera2D
class_name PlayerCamera

var _current_stength: float
var _current_length: float

func shake(_stength: float, _length: float) -> void:
	if _current_length != 0:
		return
	
	_current_length = _length
	_current_stength = _stength
	
	while _current_length > 0:
		offset = Vector2(
			randf_range(- _current_stength, + _current_stength),
			randf_range(- _current_stength, + _current_stength)
		)
		_current_length -= get_process_delta_time()
		await get_tree().physics_frame
	
	offset = Vector2.ZERO
	_current_length = 0
	_current_stength = 0
