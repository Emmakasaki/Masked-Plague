extends Node

var itemData := {}
var itemGridData := {}
@onready var itemDataPath = "res://SRC/Data/itemData.json"


# Called when the node enters the scene tree for the first time.
func _ready():
	loadData(itemDataPath)
	setGridData()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func loadData(path):
	if not FileAccess.file_exists(path):
		print("Itemn data not found")
	var itemDataFile = FileAccess.open(path, FileAccess.READ)
	itemData = JSON.parse_string(itemDataFile.get_as_text())
	itemDataFile.close()
	print(itemData)

func setGridData():
	for item in itemData.keys():
		var tempGridArray := []
		for point in itemData[item]["Grid"].split("/"):
			tempGridArray.push_back(point.split(","))
		itemGridData[item] = tempGridArray
	print(itemGridData)
