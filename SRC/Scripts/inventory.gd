extends Control


@onready var slotScene = preload("res://SRC/Scenes/slot.tscn")
@onready var gridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer

var gridArray := []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(64):
		createSlot()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func createSlot():
	var newSlot = slotScene.instantiate()
	newSlot.slotID = gridArray.size()
	gridContainer.add_child(newSlot)
	newSlot.slotEntered.connect(_on_slot_mouse_entered)
	newSlot.slotExited.connect(_on_slot_mouse_exited)
	
func _on_slot_mouse_entered(aSlot):
	aSlot.set_color(aSlot.States.TAKEN)
	
func _on_slot_mouse_exited(aSlot):
	aSlot.set_color(aSlot.States.OPEN)
	
