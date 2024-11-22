extends Node2D
class_name WaveManager

var _waves_dict: Dictionary = {
	1: {
		"wave_time": 20,
		"wave_amount": 1,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "easy"
	},
	2: {
		
	},
	3: {
		
	}
}

var _current_wave: int = 1

@export_category("Objects")
@export var _wave_timer: Timer
@export var _wave_spawner_timer: Timer

func _ready() -> void:
	_wave_timer.start(_waves_dict[_current_wave]["wave_time"])
	_spawn_enemies()
	

func _on_wave_timer_timeout() -> void:
	_current_wave += 1
	if _current_wave > 10:
		print("Você venceu!")
		return


func _on_wave_spawn_cooldown_timeout() -> void:
	_spawn_enemies()
	_wave_spawner_timer.start(_waves_dict[_current_wave]["wave_spawn_cooldown"])
	

func _spawn_enemies() -> void:
	var _amount: int = _waves_dict[_current_wave]["wave_amount"]
	var _spots: Array = []
	for _children in get_children():
		if not _children is Timer:
			_spots.append(_children)
			
	var _spawn_spots: Array = []
	for _i in _amount:
		var _index: int = randi() % _spots.size()
		var _selected_spot: Node2D = _spots[_index]
		_spawn_spots.append(_selected_spot)
		_spots.remove_at(_index)
	
	for _spot in _spawn_spots:
		var _childrens: Array = []
		for _children in _spot.get_children():
			_childrens.append(_children)
			
		var _amount_list : Array = _waves_dict[_current_wave]["wave_amount"]
		var _selected_amount: int = randi_range(_amount_list[0], _amount_list[1])
		for _i in _selected_amount:
			var _index: int = randi() % _childrens.size()
