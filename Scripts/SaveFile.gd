extends Node

var file : int = 0
var map = "universe"
var date = "0000–00–00"
var playtime = "13.79 billion years"

func update():
	$Id.text = "Save ID: " + str(file)
	$Map.text = map
	$Date.text = date

func _on_button_pressed() -> void:
	SaveSystem.ready_save(file)
	print(file)
