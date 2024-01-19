extends Control


@onready var slotScene = preload("res://SRC/Scenes/slot.tscn")
@onready var gridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var itemScene = preload("res://SRC/Scenes/item.tscn")
@onready var scrollContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
@onready var columnCount = gridContainer.columns

var gridArray := []
var itemHeld = null
var currentSlot = null
var canPlace := false
var iconAnchor: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(90):
		createSlot()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if itemHeld:
		if Input.is_action_just_pressed("rightClick"):
			rotateItem()
		if Input.is_action_just_pressed("leftClick"):
			if scrollContainer.get_global_rect().has_point(get_global_mouse_position()):
				placeItem()
	else:
		if Input.is_action_just_pressed("leftClick"):
			if scrollContainer.get_global_rect().has_point(get_global_mouse_position()):
				pickItem()
	
func createSlot():
	var newSlot = slotScene.instantiate()
	newSlot.slotID = gridArray.size()
	gridArray.push_back(newSlot)
	gridContainer.add_child(newSlot)
	newSlot.slotEntered.connect(_on_slot_mouse_entered)
	newSlot.slotExited.connect(_on_slot_mouse_exited)
	
func _on_slot_mouse_entered(slot):
	iconAnchor = Vector2(10000, 10000)
	currentSlot = slot
	if itemHeld:
		checkSlotAvailability(currentSlot)
		setGrids.call_deferred(currentSlot)
	
func _on_slot_mouse_exited(slot):
	clearGrid()

func checkSlotAvailability(slot):
	for grid in itemHeld.itemGrids:
		var gridToCheck = slot.slotID + grid[0] + grid[1] * columnCount
		var lineSwitchCheck = slot.slotID % columnCount + grid[0]
		if lineSwitchCheck < 0 or lineSwitchCheck >= columnCount:
			canPlace = false
			return
		if gridToCheck < 0 or gridToCheck >= gridArray.size():
			canPlace = false
			return
		if gridArray[gridToCheck].state == gridArray[gridToCheck].States.TAKEN:
			canPlace = false
			return
	canPlace = true
	
func setGrids(slot):
	for grid in itemHeld.itemGrids:
		var gridToCheck = slot.slotID + grid[0] + grid[1] * columnCount
		var lineSwitchCheck = slot.slotID % columnCount + grid[0]
		if gridToCheck < 0 or gridToCheck >= gridArray.size():
			continue
		if lineSwitchCheck < 0 or lineSwitchCheck >= columnCount:
			continue
		
		if canPlace:
			gridArray[gridToCheck].setColor(gridArray[gridToCheck].States.OPEN)
			if grid[1] < iconAnchor.x: 
				iconAnchor.x = grid[1]
			if grid[0] < iconAnchor.y:
				iconAnchor.y = grid[0]
		else:
			gridArray[gridToCheck].setColor(gridArray[gridToCheck].States.TAKEN)
		
func clearGrid():
	for grid in gridArray:
		grid.setColor(grid.States.DEFAULT)

func rotateItem():
	itemHeld.rotateItem()
	clearGrid()
	if currentSlot:
		_on_slot_mouse_entered(currentSlot)

func placeItem():
	if not canPlace or not currentSlot:
		return
		
	var calcGridID = currentSlot .slotID + iconAnchor.x * columnCount + iconAnchor.y
	itemHeld._snap_to(gridArray[calcGridID].global_position)
	itemHeld.get_parent().remove_child(itemHeld)
	gridContainer.add_child(itemHeld)
	itemHeld.global_position = get_global_mouse_position()
	
	itemHeld.gridAnchor = currentSlot
	for grid in itemHeld.itemGrids:
		var gridToCheck = currentSlot.slotID + grid[0] + grid[1] * columnCount
		gridArray[gridToCheck].state = gridArray[gridToCheck].States.TAKEN
		gridArray[gridToCheck].itemStored = itemHeld
	itemHeld = null
	clearGrid()
	
func pickItem():
	if not currentSlot or not currentSlot.itemStored:
		return
	
	itemHeld = currentSlot.itemStored
	itemHeld.selected = true
	itemHeld.get_parent().remove_child(itemHeld)
	add_child(itemHeld)
	itemHeld.global_position = get_global_mouse_position()
	
	for grid in itemHeld.itemGrids:
		var gridToCheck = itemHeld.gridAnchor.slotID + grid[0] + grid[1] * columnCount
		gridArray[gridToCheck].state = gridArray[gridToCheck].States.OPEN
		gridArray[gridToCheck].itemStored = null
		
	checkSlotAvailability(currentSlot)
	setGrids.call_deferred(currentSlot)
		
func _on_spawner_pressed():
	var newItem = itemScene.instantiate()
	add_child(newItem)
	newItem.loadItem(randi_range(1,4))
	newItem.selected = true
	itemHeld = newItem
