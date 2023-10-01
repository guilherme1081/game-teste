extends CharacterBody2D

@onready var sprite = $"AnimatedSprite2D"

var moviment_speed: int = 120
var last_direction = 1 # 1: left, 2: right, 3: front, 4: back
var idle_anim = {
	1: 'idle_left',
	2: 'idle_left',
	3: 'idle_front',
	4: 'idle_back'
}
func _physics_process(delta):
	moviment()

func get_direction():
	pass

func moviment():
	""""Função responsável por toda a movimentação do player"""
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")

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
	
	
	velocity = Vector2(x_mov, y_mov).normalized()*moviment_speed
	move_and_slide()

	
