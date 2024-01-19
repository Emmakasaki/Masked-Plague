extends Camera3D

# Properties
var CamTarg: Node3D = null
var follow_speed: float = 5.0
var offset: Vector3

func _ready():
	CamTarg = get_parent().get_node("CharacterBody3D")
	offset = Vector3(0,2,2)

func _process(delta):
	self.transform.origin = lerp(self.transform.origin, CamTarg.transform.origin + offset, follow_speed * delta)
