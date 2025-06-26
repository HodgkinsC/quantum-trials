extends CSGBox3D

@export var locations : PackedVector3Array
@export var rotations : PackedVector3Array
@onready var notif = $VisibleOnScreenNotifier3D

func _ready():
	notif.connect("screen_exited", change)

func change():
	var rand = randi_range(0, locations.size()-1)
	position = locations.get(rand)
	rotation_degrees = rotations.get(rand)
