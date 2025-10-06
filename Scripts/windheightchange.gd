extends AudioStreamPlayer

@export var max_height : float
@export var min_height : float
@export var max_volume : float
@export var min_volume : float

func _process(_delta: float) -> void:
	if Global.player.global_position.y >= max_height:
		volume_db = max_volume
	elif Global.player.global_position.y <= min_height:
		volume_db = min_volume
	elif Global.player.global_position.y > min_height and Global.player.global_position.y < max_height:
		volume_db = (((Global.player.global_position.y - min_height) * (max_volume - min_volume)) / (max_height - min_height)) + min_volume # Crazy equation.
	
