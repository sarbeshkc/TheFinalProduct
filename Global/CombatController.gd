# A global function to manage combact mechaniam

extends Node

signal damage_delt(attacker, target, amount)

func deal_damage(attacker, target, amount):
	if target.has_method("take_damage"):
		target.take_damage(amount)
		damage_delt.emit(attacker, target, amount)
