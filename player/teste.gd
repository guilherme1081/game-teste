extends CharacterBody2D

var moviment_speed: int = 200
var direction = Vector2()

func _physics_process(delta):
	moviment()

func get_direction():
	pass

func moviment():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")

	velocity = Vector2(x_mov, y_mov).normalized()*moviment_speed

	move_and_slide()
