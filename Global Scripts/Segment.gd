# This is the script for holding room information and generation

extends Node

var tree:RoomGraph=RoomGraph

# The array of map scenes
var rooms:Array=[load("res://Map Scenes/greenhall1.tscn"),load("res://Map Scenes/greenhall2.tscn"),load("res://Map Scenes/greenroom1.tscn"),load("res://Map Scenes/greenroom1_2door.tscn"),load("res://Map Scenes/greenroom2.tscn"),load("res://Map Scenes/greenroom3.tscn")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generateBranch(chance:int,maxDepth:int):
	var depth=0
	var firstNode=RoomGraphNode
	firstNode.room=load("res://Map Scenes/lobby.tscn") # Lobby is first room of segment
	generateRoom(chance,0,maxDepth,firstNode,1)

# Chance is how much the card drop % changes per room (key drop chance=chance/100)
func generateRoom(chance:int,depth:int,maxDepth:int,previousRoom:RoomGraphNode,id:int):
	if(depth!=maxDepth):
		var newRoom=RoomGraphNode
		newRoom.room=rooms[randi_range(0,5)]
		previousRoom.children.append(newRoom)
		tree.nodes.append(newRoom)
		tree.addNode(previousRoom,id-1)
		var chancePercent=randi_range(chance,100)
		if(chancePercent==100):
			newRoom.hasKey=true
		print("Generated room:")
		print(newRoom.room)
		print("ID: ",id," DEPTH: ",depth," PARENT: ",previousRoom.room)
		
		depth+=1
		generateRoom(chance*2,depth,maxDepth,newRoom,id+1)
	
	
	
