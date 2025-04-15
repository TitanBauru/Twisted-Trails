///@desc
if(place_meeting(x, y, obj_vacuo))
{
	instance_destroy();
}

spawna = false

// Krug: Floor Prop Creation
var _prop_ids		= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
var _prop_chance	= 0.25

if (random(1) <= _prop_chance) {
	var _tilemap_id = layer_tilemap_get_id(layer_get_id("tile_props_floor"))
	var _tile_w = tilemap_get_tile_width(_tilemap_id)
	var _tile_h = tilemap_get_tile_height(_tilemap_id)
	var _tile_id = _prop_ids[irandom(array_length(_prop_ids)-1)]
	var _x = x div _tile_w - (irandom(1))
	var _y = y div _tile_h - (irandom(1))
	tilemap_set(_tilemap_id, _tile_id, _x, _y)
}
