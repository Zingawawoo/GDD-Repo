extends Node2D

@onready var ball: Node = $Ball
@onready var score_label: Label = $CanvasLayer/ScoreLabel

var score_left: int = 0
var score_right : int = 0

func _ready() -> void:
	# connect ball signals
	ball.scored_left.connect(_on_scored_left)
	ball.scored_right.connect(_on_scored_right)
	
	# ensure paddles know where the ball is 
	pass

func _on_scored_left() -> void:
	score_left += 1
	_update_score()
	
func _on_scored_right() -> void:
	score_right += 1
	_update_score()
	
func _update_score() -> void:
	score_label.text = "%d : %d" % [score_left, score_right]
