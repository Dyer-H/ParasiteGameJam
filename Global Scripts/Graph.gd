extends Node

var startNode:RoomGraphNode
var nodes:Array[RoomGraphNode]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tempNode:RoomGraphNode=RoomGraphNode
	tempNode.id=0
	startNode=tempNode
	nodes.append(tempNode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func addNode(parent:RoomGraphNode,id:int): # Connection is nodeID we're connecting to, id is the id of the new node
	var newNode:RoomGraphNode=RoomGraphNode
	newNode.parent=parent
	newNode.id=id
	parent.children.append(newNode)
	
	nodes.append(newNode)
