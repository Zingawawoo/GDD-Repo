extends StaticBody2D

enum PlayerType { PLAYER1, PLAYER2, AI }

@export var player_type: PlayerType = PlayerType.PLAYER1
@export var speed: float = 420.0
@export var ai_follow_strength: float = 0.12
@export var paddle_half_h := 40.0  

var _ball: Node2D = null

func _ready():
	if player_type == PlayerType.AI:
		_ball = get_tree().get_first_node_in_group("ball")

func _physics_process(delta: float) -> void:
	var dy := 0.0
	match player_type:
		PlayerType.PLAYER1:
			dy = Input.get_axis("p1_up", "p1_down") * speed * delta
		PlayerType.PLAYER2:
			dy = Input.get_axis("p2_up", "p2_down") * speed * delta
		PlayerType.AI:
			if _ball:
				var diff := _ball.global_position.y - global_position.y
				var step : float = clamp(diff * ai_follow_strength, -speed * delta, speed * delta)
				dy = step
				
	if dy != 0.0:
		global_position.y += dy

	var h := get_viewport_rect().size.y
	global_position.y = clamp(global_position.y, paddle_half_h, h - paddle_half_h)
