extends CharacterBody2D

var _state_machine

@export_category("Variables")
@export var _moviment_speed: float = 64.0
@export var _friction: float = 0.8
@export var _acceleration: float = 0.4

@export_category("Objects")
@export var _animation_tree: AnimationTree = null

@export_category("Stats")
@export var dash_amount: int = 3

func _ready():
	_state_machine = _animation_tree["parameters/playback"]

func _physics_process(delta):
	_move()
	_animate()
	move_and_slide()

func _move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	

	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/run/blend_position"] = _direction
		
		velocity.x = lerp(velocity.x, _direction.normalized().x*_moviment_speed, _friction)
		velocity.y = lerp(velocity.y, _direction.normalized().y*_moviment_speed, _friction)
		return
	velocity.x = lerp(velocity.x, _direction.normalized().x*_moviment_speed, _acceleration)
	velocity.y = lerp(velocity.y, _direction.normalized().y*_moviment_speed, _acceleration)
		

func _animate() -> void:
	if velocity.length() > 8:
		_state_machine.travel("run")
		return
	_state_machine.travel("idle")
