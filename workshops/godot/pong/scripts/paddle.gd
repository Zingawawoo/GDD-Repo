extends CharacterBody2D

@export var speed: float = 400.0
@export var is_ai: bool = false
@export var ai_follow_strength: float = 0.12
var _ball: Node2D = null

func _ready():
	# If AI, try to find the ball in parent scene
	if is_ai:
		_ball = get_tree().get_first_node_in_group("ball")
		
func _physics_process(delta: float) -> void:
	var input_dir:= 0.0
	
	if is_ai and _ball:
		# simple AI: move toward ball.y with smoothing and clamp by speed
		var target_y = _ball.global_position.y
		var diff = target_y - global_position.y
		var step = diff * ai_follow_strength
		step = clamp(step, -speed * delta, speed * delta)
		velocity = Vector2(0, step / delta)
	else:
		# right paddle uses p2 inputs
		if Input.is_action_just_pressed("p2_up"): input_dir -= 1.0
		if Input.is_action_just_pressed("p2_down"): input_dir += 1.0
		
		velocity = Vector2(0, input_dir * speed)
		
	move_and_slide()
	_keep_on_screen()
	
func _keep_on_screen() -> void:
	var rect = get_viewport_rect()
	var top = 0.0
	var bottom = rect.size.y
	global_position.y = clamp(global_position.y, top +40.0, bottom - 40.0) # half of paddle height
	
