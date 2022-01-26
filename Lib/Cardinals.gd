extends Node

class_name Cardinals

const basic_cardinals = ["N","E","S","W"]
const basic_vectors = [Vector2(0,-1),Vector2(1,0),Vector2(0,1),Vector2(-1,0)]

const direction_vectors = {
		"N": Vector2(0,-1),
		"NE" : Vector2(1,-1),
		"E" : Vector2(1,0),
		"SE" : Vector2(1,1),
		"S" : Vector2(0,1),
		"SW": Vector2(-1,1),
		"W" : Vector2(-1,0),
		"NW" : Vector2(-1,-1)
	}

const vector_directions = {
		Vector2(0,-1) : "N" ,
		Vector2(1,-1) : "NE",
		Vector2(1,0) : "E",
		Vector2(1,1) : "SE",
		Vector2(0,1) : "S",
		Vector2(-1,1) : "SW",
		Vector2(-1,0) : "W",
		Vector2(-1,-1) : "NW"
	}

const inverse_direction = {
		"N": "S",
		"NE": "SW",
		"E" : "W",
		"SE" : "NW",
		"S" : "N",
		"SW" : "NE",
		"W" : "E",
		"NW" : "SE",
	}

const inverse_vector = {
		Vector2(0,-1) : Vector2(0,1) ,
		Vector2(1,-1) : Vector2(-1,1),
		Vector2(1,0) : Vector2(-1,0),
		Vector2(1,1) : Vector2(-1,-1),
		Vector2(0,1) : Vector2(0,-1),
		Vector2(-1,1) : Vector2(1,-1),
		Vector2(-1,0) : Vector2(1,0),
		Vector2(-1,-1) : Vector2(1,1)
	}

static func vector_from_direction(direction):
	if direction_vectors.has(direction):
		return direction_vectors[direction]
	return null

static func direction_from_vector(vector):
	if vector_directions.has(vector):
		return vector_directions[vector]
	return null

static func inverse_vector(vector):
	return inverse_vector[vector]

static func inverse_direction(direction):
	return inverse_direction[direction]

static func get_basic_vectors() -> Array:
	return basic_vectors

static func get_basic_directions() -> Array:
	return basic_cardinals
