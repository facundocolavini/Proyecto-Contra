extends KinematicBody2D


enum estados {corriendo , saltando, cayendo}
var habilitado  = true
export var vidas = 0
var puede_disparar = true 
var angulo_final = 0
export var puntos = 0 

func _ready():
	get_node("AnimationPlayer").play("apuntando_adelante")
	var powerupabiertos = get_tree().get_nodes_in_group("powerup_abierto")
	for powerupabierto in powerupabiertos:
		add_collision_exception_with(powerupabierto)
	
	var puentes = get_tree().get_nodes_in_group("puente")
	for puente in puentes:
		add_collision_exception_with(puente)	
	
	#Posicion del personaje 
func _physics_process(delta):
	if (habilitado):
		
		var jugador_apuntado = null
		var players = get_tree().get_nodes_in_group("player")
		if(players.size() > 1):
			if (abs(players[0].global_position.x - global_position.x) < abs(players[1].global_position.x - global_position.x)):
				angulo_final =  round(rad2deg((players[0].global_position - global_position).angle() / 45))
				angulo_final = deg2rad(angulo_final * 45)
			else:
				angulo_final =  round(rad2deg((players[1].global_position - global_position).angle() / 45))
				angulo_final =  deg2rad(angulo_final * 45)
		elif(players.size() == 1 && players[0] != null):#Si queda solo un jugador la torreta apunta al que queda vivo
			angulo_final =  round(rad2deg((players[0].global_position -  global_position).angle() / 45))
			angulo_final = deg2rad(angulo_final * 45)
		
		if(puede_disparar):
			disparar()
			puede_disparar = false
			get_node("cooldown").start()
		
		move_and_slide(Vector2(0,0))
		
		if(get_slide_collision(get_slide_count()-1) != null):#si estoy colisionando con un suelo y no es nulo
			var objeto_colisionado= get_slide_collision(get_slide_count()-1).collider
			if(objeto_colisionado != null):
				if(objeto_colisionado.is_in_group("bala")):
					var padre =  objeto_colisionado.get_parent()
					if(padre.is_in_group("main")|| padre.is_in_group("nivel")):
						recibir_golpe(objeto_colisionado.id)
					else:
						recibir_golpe(padre.id)
					objeto_colisionado.queue_free()
				elif (objeto_colisionado.is_in_group("player")):
					objeto_colisionado.get_parent().muerte_player()
					

func recibir_golpe(var id):
	vidas -= 1
	if(vidas < 1):
		muerte_enemigo()
		if(id == 1):
			game_handler.puntaje_j1 += puntos
		else:
			game_handler.puntaje_j2 += puntos
			
func muerte_enemigo():
	get_node("muerte").play()
	habilitado = false
	get_node("CollisionShape2D").queue_free()
	get_node("AnimationPlayer").play("explosion")
	yield(get_node("AnimationPlayer"),"animation_finished")	#recibe 2 parametros va a esperar hasta que la animacion termine
	queue_free()
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() 

func _on_cooldown_timeout():
	puede_disparar = true
	
func disparar():		
	var newBala = get_tree().get_nodes_in_group("main")[0].bala_enemigo.instance()
	get_tree().get_nodes_in_group("nivel")[0].add_child(newBala)
	newBala.global_position = get_node("spawn_bala").global_position
	newBala.velocidad.x = newBala.potencia * cos(angulo_final)
	newBala.velocidad.y = newBala.potencia * sin(angulo_final)
	if(round(newBala.velocidad.x) > 0 && !get_node("Sprite").flip_h):
		get_node("Sprite").flip_h = true
		get_node("spawn_bala").global_position.x = -get_node("spawn_bala").global_position.x 
	elif(round(newBala.velocidad.x) < 0 && get_node("Sprite").flip_h):
		get_node("Sprite").flip_h = false
		get_node("spawn_bala").global_position.x = -get_node("spawn_bala").global_position.x
	if(round(newBala.velocidad.y) == 0):
		get_node("AnimationPlayer").play("apuntando_adelante")
	elif(round(newBala.velocidad.y) < 0):
		get_node("AnimationPlayer").play("apuntando_arriba")
	elif(round(newBala.velocidad.y) > 0):
		get_node("AnimationPlayer").play("apuntando_abajo")
			
		