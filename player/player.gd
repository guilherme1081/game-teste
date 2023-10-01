extends CharacterBody2D

var _state_machine
var _dash_timer

@export_category("Variables")
@export var _moviment_speed: float = 64.0
@export var _friction: float = 0.8
@export var _acceleration: float = 0.4

@export_category("Objects")
@export var _animation_tree: AnimationTree = null

@export_category("Stats")
@export var dash_cdr: float = 3

var _direction = null

const _dash_duration: float = 0.3
var _current_dash_duration: float = 0
var _has_dash: bool = true

func _ready():
	_state_machine = _animation_tree["parameters/playback"]
	_dash_timer = $dash_timer
	
func _physics_process(delta):
	_move()
	_animate()
	_dash()
	move_and_slide()
	
	

func _process(delta):
	if _current_dash_duration > 0:
		_current_dash_duration -= delta
		
		position.x += _direction.x * 3
		position.y += _direction.y * 3
				
func _move() -> void:
	_direction = Vector2(
	Input.get_axis("left", "right"),
	Input.get_axis("up", "down")
)
	
	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/run/blend_position"] = _direction
		_animation_tree["parameters/dash/blend_position"] = _direction
		
		
		velocity.x = lerp(velocity.x, _direction.normalized().x*_moviment_speed, _friction)
		velocity.y = lerp(velocity.y, _direction.normalized().y*_moviment_speed, _friction)
		return
	velocity.x = lerp(velocity.x, _direction.normalized().x*_moviment_speed, _acceleration)
	velocity.y = lerp(velocity.y, _direction.normalized().y*_moviment_speed, _acceleration)
		

func _animate() -> void:
	
	if _current_dash_duration > 0:
		_state_machine.travel("dash")
		return
	if velocity.length() > 8:
		_state_machine.travel("run")
		return
	_state_machine.travel("idle")

func _dash() -> void:
	if Input.is_action_pressed("dash") and _has_dash:
		_has_dash = false
		_current_dash_duration = _dash_duration
		_dash_timer.start(dash_cdr)
	
	


func _on_dash_timer_timeout():
	_has_dash = true
	_moviment_speed = 64
