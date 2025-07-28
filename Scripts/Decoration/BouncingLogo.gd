extends CharacterBody2D

const SPEED = 300

func _ready() -> void:
	velocity = Vector2(1, 1).normalized() * SPEED

func _physics_process(delta: float) -> void:
	var coll = move_and_collide(velocity * delta)
	if coll: velocity = velocity.bounce(coll.get_normal())
