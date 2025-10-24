extends StaticBody3D

signal use

@export var pos : Vector3

var objects : Array

func _ready() -> void:
	use.connect(activate)
	$PlrDetect.connect("body_entered", add_object)
	$PlrDetect.connect("body_exited", remove_object)

func activate():
	get_parent().get_parent().teleport(get_parent(), objects)

func add_object(body):
	if body.is_in_group("Element"):
		objects.append(body)

func remove_object(body):
	if body.is_in_group("Element"):
		objects.remove_at(objects.find(body))
