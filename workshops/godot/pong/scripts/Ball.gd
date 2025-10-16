extends CharacterBody2D

@export var speed: float = 420.0
var direction: Vector2 = Vector2(1,0).rotated(randf() * TAU) # random start

signal scored_left
signal scored_right

func _ready() -> void:
	randomize()
	direction = Vector2(1, 0).rotated(randf_range(-0.4, 0.4)) # slight angle
	direction = direction.normalized()
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision: 
		var n = collision.get_normal()
		direction = direction.bounce(n).normalized()
		# prevent too steep vertical angles
		direction.y = clamp(direction.y, -0.95, 0.95)
		direction = direction.normalized()
		
	_check_goals()
	
func _check_goals() -> void:
	var rect = get_viewport_rect()
	if global_position.x < -10: # passed left edge
		emit_signal("scored_right")
		_reset(false)
	elif global_position.x > rect.size.x + 10: # passed right edge
		emit_signal("scored_left")
		_reset(true)
		
func _reset(toward_right: bool) -> void:
	var rect = get_viewport_rect()
	global_position = rect.size * 0.5
	direction = Vector2(1 if toward_right else -1, 0).rotated(randf_range(-0.35, 0.35)).normalized()
