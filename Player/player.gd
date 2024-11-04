extends CharacterBody2D
class_name Player

@export_category("Variables")
@export var _move_speed: float = 256.0

func _ready():
	global.player = self

func _physics_process(_delta):
	_move()

func _move() -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * _move_speed
	move_and_slide()
