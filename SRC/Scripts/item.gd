extends Node2D

@onready var iconRectPath = $Icon

var itemID : int
var itemGrids := []
var selected = false
var gridAnchor = null



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	
func loadItem(itemID : int):
	var iconPath = "res://Assets/Placeholders/" + DataHandler.itemData[str(itemID)]["Name"] + ".png"
	iconRectPath.texture = load(iconPath)
	for grid in DataHandler.itemGridData[str(itemID)]:
		var converterArray := []
		for i in grid:
			converterArray.push_back(int(i))
		itemGrids.push_back(converterArray)
		
func rotateItem():
	for grid in itemGrids:
		var tempY = grid[0]
		grid[0] = -grid[1]
		grid[1] = tempY
	rotation_degrees += 90
	if rotation_degrees >= 360:
		rotation_degrees = 0
		
func _snap_to(destination:Vector2):
	var tween = get_tree().create_tween()
	if int(rotation_degrees) % 100 == 0:
		destination += iconRectPath.size/2
	else:
		var tempXYSwitch = Vector2(iconRectPath.size.y, iconRectPath.size.x)
		destination += tempXYSwitch/2
	tween.tween_property(self, "global_position", destination, 0.10).set_trans(Tween.TRANS_SINE)
	selected = false
	
	
