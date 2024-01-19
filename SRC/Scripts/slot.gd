extends TextureRect

signal slotEntered(slot)
signal slotExited(slot)

@onready var statusFilter = $StatusFilter

var slotID
var isHovering := false
enum States {DEFAULT, TAKEN, OPEN}
var state = States.DEFAULT
var itemStored = null

func setColor(aState = States.DEFAULT) -> void:
	match aState:
		States.DEFAULT:
			statusFilter.color = Color(Color.GRAY, 0.0)
		States.TAKEN:
			statusFilter.color = Color(Color.RED, 0.2)
		States.OPEN:
			statusFilter.color = Color(Color.GREEN, 0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_global_rect().has_point(get_global_mouse_position()):
		if not isHovering:
			isHovering = true
			emit_signal("slotEntered", self)
	else:
		if isHovering:
			isHovering = false
			emit_signal("slotExited", self)
