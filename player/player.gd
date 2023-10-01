extends CharacterBody2D

@onready var sprite = $"AnimatedSprite2D"

# Variáveis de movimento
const base_moviment_speed: int = 120
var moviment_speed: int = 120


var last_direction = 1 # 1: left, 2: right, 3: front, 4: back
var idle_anim = {
	1: 'idle_left',
	2: 'idle_left',
	3: 'idle_front',
	4: 'idle_back'
}

# Variáveis de dash
const dash_cooldown: float = 3 # Em segundos
const dash_multiplier: float = 5
var dash_timer: float = dash_cooldown
var has_dash: int  = 0
var dash_duration: float = 0

# Processos
func _process(delta):
	if dash_timer <= 0:
		has_dash = 1
	else:
		dash_timer -= delta
		
	if dash_duration > 0:
		dash_duration -= delta

func _physics_process(delta):
	moviment()

# métodos
func moviment():
	""""Função responsável por toda a movimentação do player"""
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var dash_pressed = Input.get_action_strength("dash")
	# Avalia a direção em que o personagem está
	# E roda a animação equivalente.
	# A animação para right e left é a mesma, basta usar um flip_h 
	# para inverter o personagem.
	if x_mov == 1:
		sprite.play("run_left")
		sprite.flip_h = false
		last_direction = 1
	elif x_mov == -1:
		sprite.flip_h = true
		sprite.play('run_left')
		last_direction = 2
	elif y_mov == 1:
		sprite.play('run_front')
		last_direction = 3
		
	elif y_mov == -1:
		sprite.play('run_back')
		last_direction = 4
	elif y_mov == 0 && x_mov == 0:
		sprite.play(idle_anim[last_direction])
	
	if Input.is_action_pressed("dash"):
		if has_dash:
			has_dash = 0
			dash_timer = dash_cooldown
			dash_duration = 0.5
	
	if dash_duration > 0:
		sprite.play('dash_left')
	velocity = Vector2(x_mov, y_mov).normalized()*moviment_speed + Vector2(x_mov, y_mov).normalized()*base_moviment_speed*dash_duration*dash_multiplier
	

		
	
	move_and_slide()
	print(dash_duration)
