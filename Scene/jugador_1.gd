extends Position2D

var Velocidad = Vector2()
export (float) var GRAVEDAD = 100
export (float) var VEL_MOVIMIENTO = 25
export (float) var VEL_SALTO = 25
var puede_disparar = true
var puede_saltar = false
var esta_en_agua = false
enum estados {idle, cuerpo_tierra, sumergido, apuntando_diagarr, apuntando_diagab, apuntando_arr, apuntando_ab, corriendo, muerto}
var suelo_inferior = false
var estado_actual = estados.idle
var puede_agacharse = true
export (int) var arma = 0
export (PackedScene) var bala_actual
export (Vector2) var spawnB_izq
export (Vector2) var spawnB_arr
export (Vector2) var spawnB_izqAR
export (Vector2) var spawnB_izqAB

func _ready():
	spawnB_izq = get_node("cuerpo_j1/spawnbala").position
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		get_node("cuerpo_j1").add_collision_exception_with(player)
	var powerups = get_tree().get_nodes_in_group("powerup")
	for powerup in powerups:
		get_node("cuerpo_j1").add_collision_exception_with(powerup)

	
func _physics_process(delta):
	
	Velocidad.y += GRAVEDAD * delta
	
	if(estado_actual != estados.muerto):
		
		if(Input.is_action_pressed("tecla_a") && estado_actual != estados.cuerpo_tierra && estado_actual != estados.sumergido):
			Velocidad.x = -VEL_MOVIMIENTO
			get_node("cuerpo_j1/spr_j1").flip_h = false
			if(Input.is_action_pressed("tecla_w")):
				if(estado_actual != estados.apuntando_diagarr && (puede_saltar) && !esta_en_agua):
					get_node("animacion_j1").play("j1_diagar")
					get_node("cuerpo_j1/spawnbala").position = spawnB_izqAR
					estado_actual = estados.apuntando_diagarr
				elif(estado_actual != estados.apuntando_diagarr && !puede_saltar):
					get_node("cuerpo_j1/spawnbala").position = spawnB_izqAR
					estado_actual = estados.apuntando_diagarr
			elif(Input.is_action_pressed("tecla_s")):
				if(estado_actual != estados.apuntando_diagab && (puede_saltar) && !esta_en_agua):
					get_node("animacion_j1").play("j1_diagab")
					get_node("cuerpo_j1/spawnbala").position = spawnB_izqAB
					estado_actual = estados.apuntando_diagab
				elif(estado_actual != estados.apuntando_diagab && !puede_saltar):
					get_node("cuerpo_j1/spawnbala").position = spawnB_izqAB
					estado_actual = estados.apuntando_diagab
			elif(estado_actual != estados.corriendo && (puede_saltar)):
				if(!esta_en_agua):
					get_node("animacion_j1").play("j1_corriendo")
				else:
					get_node("animacion_j1").play("j1_watermove")
				estado_actual = estados.corriendo
				get_node("cuerpo_j1/spawnbala").position = spawnB_izq
			elif(estado_actual != estados.corriendo && !puede_saltar):
				get_node("cuerpo_j1/spawnbala").position = spawnB_izq
		elif(Input.is_action_pressed("tecla_d") && estado_actual != estados.cuerpo_tierra && estado_actual != estados.sumergido):
			Velocidad.x = VEL_MOVIMIENTO
			get_node("cuerpo_j1/spr_j1").flip_h = true
			if(Input.is_action_pressed("tecla_w")):
				if(estado_actual != estados.apuntando_diagarr && (puede_saltar) && !esta_en_agua):
					get_node("animacion_j1").play("j1_diagar")
					get_node("cuerpo_j1/spawnbala").position = Vector2(spawnB_izqAR.x * -0.4, spawnB_izqAR.y)
					estado_actual = estados.apuntando_diagarr
				elif(estado_actual != estados.apuntando_diagarr && !puede_saltar):
					get_node("cuerpo_j1/spawnbala").position = Vector2(spawnB_izqAR.x * -0.4, spawnB_izqAR.y)
					estado_actual = estados.apuntando_diagarr
			elif(Input.is_action_pressed("tecla_s")):
				if(estado_actual != estados.apuntando_diagab && (puede_saltar) && !esta_en_agua):
					get_node("animacion_j1").play("j1_diagab")
					get_node("cuerpo_j1/spawnbala").position = Vector2(spawnB_izqAB.x * -0.4, spawnB_izqAB.y)
					estado_actual = estados.apuntando_diagab
				elif(estado_actual != estados.apuntando_diagab && (!puede_saltar)):
					get_node("cuerpo_j1/spawnbala").position = Vector2(spawnB_izqAB.x * -0.4, spawnB_izqAB.y)
					estado_actual = estados.apuntando_diagab
			elif(estado_actual != estados.corriendo && (puede_saltar)):
				if(!esta_en_agua):
					get_node("animacion_j1").play("j1_corriendo")
				else:
					get_node("animacion_j1").play("j1_watermove")
				estado_actual = estados.corriendo
				get_node("cuerpo_j1/spawnbala").position = Vector2(spawnB_izq.x * -1, spawnB_izq.y)
			elif(estado_actual != estados.corriendo && !puede_saltar):
				get_node("cuerpo_j1/spawnbala").position = Vector2(spawnB_izq.x * -1, spawnB_izq.y)
		elif(Input.is_action_pressed("tecla_w") && estado_actual != estados.cuerpo_tierra && estado_actual != estados.sumergido):
			if(puede_saltar && !esta_en_agua):
				get_node("animacion_j1").play("j1_haciaarriba")
				get_node("cuerpo_j1/spawnbala").position = spawnB_arr
				estado_actual = estados.apuntando_arr
			elif(!puede_saltar):
				get_node("cuerpo_j1/spawnbala").position = spawnB_arr
				estado_actual = estados.apuntando_arr
			Velocidad.x = 0
		elif(Input.is_action_pressed("tecla_s") && puede_agacharse):
			if(puede_saltar):
				if(!esta_en_agua):
					get_node("animacion_j1").play("j1_agachado")
					estado_actual = estados.cuerpo_tierra
				else:
					get_node("animacion_j1").play("j1_underwater")
					puede_disparar = false
					estado_actual = estados.sumergido
					get_node("cuerpo_j1/colision_j1").disabled = true
			else:
				get_node("cuerpo_j1/spawnbala").position = Vector2(spawnB_arr.x, spawnB_arr.y * -0.11)
				estado_actual = estados.apuntando_ab
			Velocidad.x = 0
		else:
			Velocidad.x = 0
			if(puede_saltar):
				estado_actual = estados.idle
				if(!esta_en_agua):
					get_node("animacion_j1").play("j1_idle")
					if(estado_actual == estados.cuerpo_tierra):
						get_node("cuerpo_j1").global_position -= Vector2(0, 35)
				else:
					get_node("animacion_j1").play("J1_water")
		
		if(Input.is_action_pressed("tecla_space") && puede_saltar && estado_actual != estados.sumergido):
			if(estado_actual != estados.cuerpo_tierra):
				Velocidad.y = -VEL_SALTO
				get_node("animacion_j1").play("j1_salto")
				estado_actual = estados.idle
			elif(!suelo_inferior):
				get_node("cuerpo_j1").global_position += Vector2(0, 1)
				estado_actual = estados.idle
				get_node("animacion_j1").play("j1_idle")
				
		if(Input.is_action_pressed("tecla_m") && puede_disparar):
			var newBala = get_tree().get_nodes_in_group("main")[0].seleccionar_bala(arma).instance()
			newBala.global_position = get_node("cuerpo_j1/spawnbala").global_position
			get_tree().get_nodes_in_group("main")[0].add_child(newBala)
			puede_disparar = false
			get_node("cuerpo_j1/tmr_cooldown").start()
			if(estado_actual == estados.apuntando_arr):
				newBala.velocidad.y = -newBala.potencia
			elif(estado_actual == estados.idle || estado_actual == estados.cuerpo_tierra || estado_actual == estados.corriendo):
				if(get_node("cuerpo_j1/spr_j1").flip_h):
					newBala.velocidad.x = newBala.potencia
				else:
					newBala.velocidad.x = -newBala.potencia
			elif(estado_actual == estados.apuntando_diagarr):
				if(get_node("cuerpo_j1/spr_j1").flip_h):
					newBala.velocidad = Vector2(newBala.potencia, -newBala.potencia)
				else:
					newBala.velocidad = Vector2(-newBala.potencia, -newBala.potencia)
			elif(estado_actual == estados.apuntando_diagab):
				if(get_node("cuerpo_j1/spr_j1").flip_h):
					newBala.velocidad = Vector2(newBala.potencia, newBala.potencia)
				else:
					newBala.velocidad = Vector2(-newBala.potencia, newBala.potencia)
			elif(estado_actual == estados.apuntando_ab && !puede_saltar):
				newBala.velocidad.y = newBala.potencia
			
		if(Input.is_action_just_released("tecla_s") && puede_agacharse && puede_saltar):
			puede_agacharse = false
			estado_actual = estados.idle
			get_node("animacion_j1").play("j1_idle")
			global_position.y -= 35
			yield(get_tree().create_timer(0.4), "timeout")
			puede_agacharse = true
			if(get_node("cuerpo_j1/spr_j1").flip_h):
				get_node("cuerpo_j1/spawnbala").position = -spawnB_izq
			else:
				get_node("cuerpo_j1/spawnbala").position = spawnB_izq
			puede_disparar = true

				
		#ACA VOY A CALCULAR EL RESTO
		if(estado_actual != estados.sumergido):
			var movimiento = Velocidad * delta
			get_node("cuerpo_j1").move_and_slide(movimiento)
		
		if(get_node("cuerpo_j1").get_slide_collision(get_node("cuerpo_j1").get_slide_count()-1) != null):
			var obj_colisionado = get_node("cuerpo_j1").get_slide_collision(get_node("cuerpo_j1").get_slide_count()-1).collider
			if(obj_colisionado.is_in_group("suelo")):
				get_tree().get_nodes_in_group("spawn_j")[0].global_position = get_node("cuerpo_j1").global_position
				if(obj_colisionado.is_in_group("suelo_agua")):
					suelo_inferior = true
				else:
					suelo_inferior = false
				if(puede_saltar == false):
					puede_saltar = true
					get_node("animacion_j1").stop()
					estado_actual = estados.idle
					if(obj_colisionado.is_in_group("agua")):
						esta_en_agua = true
						get_node("animacion_j1").play("J1_water")
					else:
						esta_en_agua = false
						get_node("sfx_piso").play()
						
				if(obj_colisionado.is_in_group("puente")):
					obj_colisionado.get_parent().explotar()
			elif(obj_colisionado.is_in_group("enemigo") && estado_actual != estados.muerto):
				muerte_player()
			elif(obj_colisionado.is_in_group("powerup_abierto")):
				if(obj_colisionado.id == 6):
					agregar_vida()
				else:
					arma = obj_colisionado.id
				obj_colisionado.queue_free()
		elif(puede_saltar):
			puede_saltar = false
	else:
		var movimiento = Velocidad * delta
		get_node("cuerpo_j1").move_and_slide(movimiento)
		




func _on_tmr_cooldown_timeout():
	puede_disparar = true

func muerte_player():
	get_node("sfx_muerte").play()
	Velocidad.x = 0
	var enemigos = get_tree().get_nodes_in_group("enemigo")
	for enemigo in enemigos:
		get_node("cuerpo_j1").add_collision_exception_with(enemigo)
	estado_actual = estados.muerto
	get_node("animacion_j1").play("j1_muerte")
	yield(get_node("animacion_j1"), "animation_finished")
	get_tree().get_nodes_in_group("main")[0].respawn_j1()
	get_tree().get_nodes_in_group("camara")[0].global_position.x = get_node("cuerpo_j1").global_position.x
	queue_free()
	

func _on_VisibilityNotifier2D_screen_exited():
	muerte_player()
	
func agregar_vida():
	get_node("sfx_vida").play()
	get_tree().get_nodes_in_group("main")[0].agregar_vida_j1()
