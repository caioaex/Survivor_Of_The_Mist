extends CharacterBody2D
class_name Enemy

var _is_dashing: bool = false
var _loading_dash: bool = true
var _previous_character_position: Vector2

@export_category("Variables")
@export var _enemy_type: String = "chase"
@export var _move_speed: float = 192
@export var _dash_speed: float = 768

@export_category("Objects")
@export var _dash_wait_time: Timer
@export var _dash_timer: Timer

func _physics_process(_delta: float) -> void:
	if _loading_dash:
		return
	
	if global.player == null:
		return
	
	var _direction: Vector2 = global_position.direction_to(global.player.global_position)
	var _distance: float = global_position.distance_to(global.player.global_position)
	
	if _distance <= 16.0:
		
		return
	
	match _enemy_type:
		"chase":
			_chase(_direction)
		"chase_and_dash":
			_chase_and_dash(_direction)
			
	move_and_slide()


func _chase(_direction: Vector2) -> void:
	velocity = _direction * _move_speed
	

func _chase_and_dash(_direction: Vector2):
	if not _is_dashing:
		velocity = _direction * _move_speed
	
	if _is_dashing:
		_direction = global_position.direction_to(_previous_character_position)
		velocity = _direction * _dash_speed
		
	return

func _on_range_area_body_entered(_body) -> void:
	if _enemy_type != "chase_and_dash":
		return
		
	if _is_dashing:
		return
	
	if _body is Player:
		_previous_character_position = global.player.global_position
		_dash_wait_time.start()
		_loading_dash = true

func _on_dash_wait_time_timeout() -> void:
	_loading_dash = false
	_is_dashing = true
	_dash_timer.start()

func _on_dash_timer_timeout() -> void:
	_is_dashing = false


func _on_hit_box_area_body_entered(_body) -> void:
	if _body is Player:
		print("Causar dano")
	
