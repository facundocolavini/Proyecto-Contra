extends KinematicBody2D

var velocidad = Vector2()

export(float) var gravedad = 0
export var potencia = 0

func _ready():
	velocidad.x = 0
	velocidad.y = 0 
	#Toma todos los suelos por excepcion de colision
	var todos_los_suelos = get_tree().get_nodes_in_group("suelo")
	var s_invisible = get_tree().get_nodes_in_group("sinvisible")
	var balas_enemigo = get_tree().get_nodes_in_group("bala_enemigo")
	var enemigos = get_tree().get_nodes_in_group("enemigo")
	var powerups = get_tree().get_nodes_in_group("powerup")
	var powerupabiertos = get_tree().get_nodes_in_group("powerup_abierto")
	
	#Excepciones con un ciclo recorriendo todos los suelos
	for suelo in todos_los_suelos:
		add_collision_exception_with(suelo)
		
	for enemigo in balas_enemigo:
		add_collision_exception_with(enemigo)
	 
	for suelo in s_invisible:
		add_collision_exception_with(suelo)
	
	for enemigo in enemigos:
		add_collision_exception_with(enemigo)
		
	for powerup in powerups:
		add_collision_exception_with(powerup)
	
	for powerupabierto in powerupabiertos:
		add_collision_exception_with(powerupabierto)
	
func _physics_process(delta):
	velocidad.y += gravedad * delta
	var movimiento = velocidad * delta
	var obj_colisionado= move_and_collide(movimiento)
	
	if(obj_colisionado != null):
		obj_colisionado = obj_colisionado.collider
		if(obj_colisionado.is_in_group("player")):
			obj_colisionado.get_parent().muerte_player()
			
func recibir_golpe(var id):
	queue_free()
		
func _on_VisibilityNotifier2D_screen_exited():
	print('salio de pantalla')
	queue_free() # elimina la bala que sale de la pantalla para liberar memoria y que no quede basura
