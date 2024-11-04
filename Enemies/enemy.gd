extends CharacterBody2D
class_name Enemy

@export_category("Variables")
@export var _enemy_type: String = "chase"
@export var _move_speed: float = 192
@export var _dash_speed: float = 768

@export_category("Objects")
@export var _dash_wait_time: Timer

func _physics_process(_delta: float) -> void:
	if global.player == null:
		return
	var _direction: Vector2 = global_position.direction_to(global.player.global_position)
	match _enemy_type:
		"chase":
			_chase(_direction)
		"chase_and_dash":
			_chase_and_dash(_direction)
	move_and_slide()

func _chase(_direction: Vector2) -> void:
	velocity = _direction * _move_speed
	

func _chase_and_dash(_direction: Vector2):
	return


func _on_range_area_body_entered(_body) -> void:
	if _enemy_type != "chase_and_dash":
		return
	
	if _body is Player:
		print("Aqui")


func _on_dash_wait_time_timeout() -> void:
	pass # Replace with function body.
