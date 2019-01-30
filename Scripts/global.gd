extends Node

# holds the main information for the whole game
var situation = {"state" : 0, "score" : 0, "time" : 0, "health" : 9, "night" : 0, "nightswon" : 0}
#{"state" : 0, "score" : 0, "time" : 0, "health" : 9, "night" : 0, "nightswon" : 0}
var situation_default = {"state" : 0, "score" : 0, "time" : 0, "health" : 9, "night" : 0, "nightswon" : 0}
var lastnight = {"flasks":0,"purses":0,"pips":0,"pipused" :0,"flaskused":0,"purseused":0,"orbfound":false,"mushrooms":0,"mushroomused":0}
#{"flasks":0,"purses":0,"pips":0,"pipused" :0,"flaskused":0,"purseused":0,"orbfound":false,"mushrooms":0}
var allnights = {"flasks":0,"purses":0,"pips":0,"pipused" :0,"flaskused":0,"purseused":0,"orbfound":false,"mushrooms":0,"mushroomused":0}
var lastnight_default = {"flasks":0,"purses":0,"pips":0,"pipused" :0,"flaskused":0,"purseused":0,"orbfound":false,"mushrooms":0,"mushroomused":0}
var highscore = 0
var goal

func tally():
	allnights["flasks"] += lastnight["flasks"]
	allnights["purses"] += lastnight["purses"]
	allnights["pips"] += lastnight["pips"]
	allnights["mushrooms"] += lastnight["mushrooms"]
	allnights["flaskused"] += lastnight["flaskused"]
	allnights["purseused"] += lastnight["purseused"]
	allnights["pipused"] += lastnight["pipused"]
	allnights["mushroomused"] += lastnight["purseused"]
	print(allnights)

func fade_check():
	pass

func reset():
	highscore()
	goal = []
	situation = situation_default
	lastnight = lastnight_default

func highscore():
	if situation["score"] > highscore:
		highscore = situation["score"]