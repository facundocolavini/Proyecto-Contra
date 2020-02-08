extends Node
var todos_los_suelos
var s_invisible
var jugadores = 1
var puntaje_j1 = 0
var puntaje_j2 = 0
var highscore = 500
var gano = false

func iniciar():
	todos_los_suelos = get_tree().get_nodes_in_group("suelo")
	s_invisible = get_tree().get_nodes_in_group("sinvisible")