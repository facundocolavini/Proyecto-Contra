extends Position2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var enemigo_base
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_VisibilityNotifier2D_screen_entered():
	var newEnemigo = enemigo_base.instance()
	newEnemigo.global_position = global_position
	get_tree().get_nodes_in_group("nivel")[0].add_child(newEnemigo)
	queue_free()

