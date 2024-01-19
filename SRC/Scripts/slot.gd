extends TextureRect

signal slotEntered(slot)
signal slotExited(slot)

@onready var statusFilter = $StatusFilter

var slotID
var isHovering := false
enum States {DEFAULT, TAKEN, OPEN}
var state = States.DEFAULT
var itemStored = null

func setColor(aState = States.DEFAULT):
	match aState:
		States.DEFAULT:
			statusFilter.color = Color(Color.WHITE, 0.0)
		States.TAKEN:
			statusFilter.color = Color(Color.RED, 0.0)
		States.OPEN:
			statusFilter.color = Color(Color.GREEN, 0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
