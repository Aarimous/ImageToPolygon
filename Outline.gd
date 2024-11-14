extends Line2D
class_name Outline

@export var procedural_set_point : bool = false
@export var art : TextureRect


#threshold variable for the bit map conversion	
@export var threshold  = .1

#threshold variable for bit map to polygon conversion
@export var epsilon  = 2.0

#adjust this to increase/decrease the min distance between points (smaller value is more points)
@export var spacing_squared  = 25.0


var is_highlighted : bool:
	set(new_value):
		is_highlighted = new_value
		%"Tile Stack Outline".visible = is_highlighted

var outline_color : Color :
	set(new_color):
		outline_color = new_color
		material.set_shader_parameter("outline_color", outline_color)


func _ready():
	if procedural_set_point:
		clear_points()
		generate_line_points()

func generate_line_points():
	clear_points()
	
	var bit_map : BitMap = BitMap.new()
	bit_map.create_from_image_alpha(art.texture.get_image(), threshold)
	var polygons = bit_map.opaque_to_polygons( Rect2(Vector2(), bit_map.get_size()), epsilon)


	for polygon in polygons:
		var last_point : Vector2
		for i in range(polygon.size()):
			var point = polygon[i]
			var can_add_point = true
			if last_point and last_point.distance_squared_to(point) < spacing_squared:
				can_add_point = false	
			
			if i == polygon.size() - 1 and polygon[0].distance_squared_to(point) < spacing_squared:
				can_add_point = false	

			if can_add_point:
				add_point(point)
				last_point = point
