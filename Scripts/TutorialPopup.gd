extends Area3D

@export var screentime : int
@export var text : String
@export var repeats : bool
var done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/Label.text = text

func _on_body_entered(body: Node3D) -> void:
	if !done and repeats: done = true
	
	if body.is_in_group("Player") and !done:
		done = true
		$Control.visible = true
		await get_tree().create_timer(screentime).timeout
		$Control.visible = false
