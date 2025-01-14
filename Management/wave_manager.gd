extends Node2D
class_name WaveManager

const _GREEN_ENEMY: PackedScene = preload("res://Enemies/enemy_green.tscn")
const _YELLOW_ENEMY: PackedScene = preload("res://Enemies/enemy_yellow.tscn")
const _PURPLE_ENEMY: PackedScene = preload("res://Enemies/enemy_purple.tscn")

var _waves_dict: Dictionary = {
	1: {
		"wave_time": 20,
		"wave_amount": 1,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "easy"
	},
	2: {
		"wave_time": 25,
		"wave_amount": 2,
		"wave_spawn_cooldown": 5,
		"spots_amount": [2, 4],
		"wave_difficulty": "easy_to_medium"
	},
	3: {
		"wave_time": 30,
		"wave_amount": 3,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "easy_to_medium"
	},
	4: {
		"wave_time": 35,
		"wave_amount": 4,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "medium"
	},
	5:{
		"wave_time": 40,
		"wave_amount": 5,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "medium"
	},
	6: {
		"wave_time": 45,
		"wave_amount": 6,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "medium_to_hard"
	},
	7: {
		"wave_time": 50,
		"wave_amount": 6,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "medium_to_hard"
	},
	8: {
		"wave_time": 60,
		"wave_amount": 6,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "hard"
	},
	9: {
		"wave_time": 65,
		"wave_amount": 6,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "hard"
	}, 
	10: {
		"wave_time": 70,
		"wave_amount": 6,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "hard"
	}
}

var _current_wave: int = 1

@export_category("Objects")
@export var _wave_timer: Timer
@export var _wave_spawner_timer: Timer
@export var _interface: CanvasLayer = null

func _ready() -> void:
	_wave_spawner_timer.start(_waves_dict[_current_wave]["wave_spawn_cooldown"])
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
		var _selected_childrens: Array = []
		for _children in _spot.get_children():
			_childrens.append(_children)
			
		var _amount_list : Array = _waves_dict[_current_wave]["spots_amount"]
		var _selected_amount: int = randi_range(_amount_list[0], _amount_list[1])
		for _i in _selected_amount:
			var _index: int = randi() % _childrens.size()
			var _selected_spot: Node2D = _childrens[_index]
			_selected_childrens.append(_selected_spot)
			_childrens.remove_at(_index)
			
		for _spawner in _selected_childrens:
			_spawn_enemy(_spawner)
			pass


func _spawn_enemy(_spawner: Node2D) -> void:
	var _enemy: Enemy = null
	var _randf: float = randf()
	var _difficulty : String = _waves_dict[_current_wave]["wave_difficulty"]
	match _difficulty:
		"easy":
			_enemy = _GREEN_ENEMY.instantiate()
		"easy_to_medium":
			if _randf <= 0.7: 
				_enemy = _GREEN_ENEMY.instantiate()
			else:
				_enemy = _YELLOW_ENEMY.instantiate()
		"medium":
			if _randf <= 0.5: 
				_enemy = _GREEN_ENEMY.instantiate()
			else:
				_enemy = _YELLOW_ENEMY.instantiate()
		"medium_to_hard":
			if _randf <= 0.4: 
				_enemy = _GREEN_ENEMY.instantiate()
			elif _randf > 0.4 and _randf <= 0.9:
				_enemy = _YELLOW_ENEMY.instantiate()
			else:
				_enemy = _PURPLE_ENEMY.instantiate() 
		"hard":
			if _randf <= 0.2: 
				_enemy = _GREEN_ENEMY.instantiate()
			elif _randf > 0.2 and _randf <= 0.8:
				_enemy = _YELLOW_ENEMY.instantiate()
			else:
				_enemy = _PURPLE_ENEMY.instantiate() 
	_enemy.global_position = _spawner.global_position
	get_parent().call_deferred("add_child", _enemy)


func _on_current_time_timer_timeout():
	_interface.update_wave_and_time_label(_current_wave, _wave_timer.time_left)
