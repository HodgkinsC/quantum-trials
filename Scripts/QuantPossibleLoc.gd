extends VisibleOnScreenNotifier3D

@export var viewed : bool
var current : bool

func _ready() -> void:
	connect("screen_entered", cantgo)
	connect("screen_exited", cango)

func cantgo():
	viewed = true
	#get_parent().possiblelocations.erase(visible)

func cango():
	viewed = false
	if current:
		get_parent().move.emit()
	#get_parent().possiblelocations.append(visible)
