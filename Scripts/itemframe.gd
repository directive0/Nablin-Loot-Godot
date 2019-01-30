extends Sprite

var item
var items = []
var itemdata
var itemno
var itemsprite = []
var score
var noitems
var orbfound = false
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# load our sprites for our objects in the frame.
	itemsprite.append(load("res://pip.png"))
	itemsprite.append(load("res://purse.png"))
	itemsprite.append(load("res://flask.png"))
	itemsprite.append(load("res://assets/mushroom/Item Mushroom.png"))
	itemsprite.append(load("res://assets/crystal/Item Crystal Ball.png"))
	
	score = get_parent().get_node("score")
	
	#items 
	#0	name
	#1 - score value
	#2 - effect
	#3 - sprite
	itemdata = [["Pip",100,0,itemsprite[0],load("res://pipsmall.png")],\
	["Purse",500,1,itemsprite[1],load("res://pursesmall.png")],\
	["Flask",150,2,itemsprite[2],load("res://flasksmall.png")],\
	["Mushroom",250,3,itemsprite[3],load("res://assets/mushroom/Item Mushroom Small.png")],\
	["Orb",10000,3,itemsprite[4],load("res://assets/crystal/Item Crystal Ball Small.png")]
	]
	
	
	# Called every time the node is added to the scene.
	# Initialization here

func _process(delta):
	noitems = items.size()
	$Label.set_text(str(noitems))
	if noitems > 0:
		var topitem = items[-1]
		$item.set_texture(topitem[3])
		$item.set_visible(true)
	else:
		$item.set_visible(false)

func pickup(item):
	var thisitem
	var getsound = get_tree().get_nodes_in_group("player")[0].get_node("get")
	getsound._set_playing(true)
	if item == "mushroom":
		global.lastnight["mushrooms"] += 1
		thisitem = itemdata[3]
	 
	if item == "orb":
		thisitem = itemdata[4]
	
	# add the data for this item to the itembank
	items.append(thisitem)
	score.newitem(thisitem[1])
	
func get_itemsprites():
	return itemsprite

func item_left():
	if noitems > 0:
		var register = items.pop_front()
		items.push_back(register)

func item_right():
	if noitems > 0:
		var register = items.pop_back()
		items.push_front(register)

func get_item():
	
	if noitems > 0:
		return items[-1]
	else:
		return "none"
	
func use_item():

	var item_to_use = items.pop_back()

	return item_to_use

func newitem():
	# pick a number
	if global.situation["night"] == 2:
		itemno = randi() % 4 + 0
	else:
		itemno = randi() % 3 + 0
	
	if itemno == 0:
		global.lastnight["pips"] += 1
	if itemno == 1:
		global.lastnight["purses"] += 1
	if itemno == 2:
		global.lastnight["flasks"] += 1
	if itemno == 3:
		if orbfound == false:
			orbfound = true
			itemno = 4
		#global.lastnight["mushrooms"] += 1
			global.lastnight["orbfound"] = true
		else:
			itemno = 3
	
	print("from newitem in itemframe: ", global.lastnight)
	#use the number to read data from the databank
	var thisitem = itemdata[itemno]
	
	
	# add the data for this item to the itembank
	items.append(thisitem)
	
	# add the score amount to the score counter
	score.newitem(thisitem[1])
	