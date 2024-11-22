extends Node2D
class_name BaseWeapon

var _is_attacking: bool = false

@export_category("Variables")
@export var _attack_damage: int
#@export var _attack_cooldown: float

@export_category("Objects")
@export var _attack_timer: Timer
@export var _animation: AnimationPlayer
@export var _detectionArea: Area2D

func _on_detection_area_body_entered(_body) -> void:
	if _is_attacking:
		return
	
	if _body is Enemy:
		_detectionArea.set_deferred("monitoring", false)
		_animation.play("attack")
		_attack_timer.start()
		_is_attacking = true

func _on_attack_timer_timeout() -> void:
	_is_attacking = false
	_detectionArea.set_deferred("monitoring", true)


func _on_attack_area_body_entered(_body):
	if _body is Enemy:
		_body.update_health(_attack_damage)
