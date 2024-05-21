extends Node2D


@export var PlayerScene: PackedScene
var PlayerArr = []
var PlayersColliding = {}
var RecentTag = false
# Called when the node enters the scene tree for the first time.
func _ready():
	print(GameManager.Players)
	if(multiplayer.is_server()):
		print(" --server")
	else:
		print("--client")
	var index = 0
	for i in GameManager.Players:
		PlayerArr.push_back(GameManager.Players[i])
	
	#sort players by id so they dont overlap in spawn
	PlayerArr.sort_custom(func(a, b): return a.id < b.id)
	
	for player in PlayerArr:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(player.id)
		currentPlayer.find_child("playername").text = player.name
		add_child(currentPlayer)
		
		#loop to spawn players in node
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if(spawn.name == str(index)):
				currentPlayer.global_position = spawn.global_position
				print(str(index) + "was spawned: " + currentPlayer.name)
		index+=1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for p in GameManager.Players:
		
		var player = get_node(str(p))
		if(player == null):
			continue
		if(GameManager.Players[p].is_it):
			if(player.has_node("playername")):
				var label : Label = player.get_node("playername") as Label
				label.add_theme_color_override("font_color", Color(1, 0.5, 0))
			if(player.has_node("Sprite2D")):
				var sprite : Sprite2D = player.get_node("Sprite2D") as Sprite2D
				var shader : Material = sprite.material as Material
				shader.set_shader_parameter("line_thickness", 10)
		else:
			if(player.has_node("playername")):
				var label : Label = player.get_node("playername") as Label
				label.add_theme_color_override("font_color", Color(0, 0, 0))
			if(player.has_node("Sprite2D")):
				var sprite : Sprite2D = player.get_node("Sprite2D") as Sprite2D
				var shader : Material = sprite.material as Material
				shader.set_shader_parameter("line_thickness", 0)
	var pInvolved = 0
	pass




		
func _on_tag_timer_timeout():
	print("can tag")
	pass # Replace with function body.
