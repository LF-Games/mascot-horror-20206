class_name Interactable
extends Area2D
## Classe responsável por receber interações do jogador

const GROUP_NAME := "INTERACTABLE"


func _ready():
	add_to_group(GROUP_NAME)


func interact():
	print("interacted")
