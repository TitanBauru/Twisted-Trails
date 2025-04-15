// Krug: Object Prop Creation

var _prop_chance = 0.1		// chançe daquele chao criar um prop
var _prop_data = [			// struct contendo informações sobre cada prop. Se for adicionar muitas, compensa criar um constructor
	{
		spr : spr_poste_1,	// sprite pra ser usada
		wid : 32,			// largura da caixa de colisao
		hei : 32,			// altura da caixa de colisao
		xx	: 0,			// offset do x
		yy	: 0,			// offset do y
		r	: 12,			// valor máximo de random pra aplicar na posição
	},
	{
		spr : spr_arcade_1,
		wid : 32,
		hei : 32,
		xx	: 0,
		yy	: 4,
		r	: 6,
	},
	{
		spr : spr_carro_1,
		wid : 64,
		hei : 32,
		xx	: 16,
		yy	: 14,
		r	: 0,
	},
	{
		spr : spr_carro_2,
		wid : 64,
		hei : 32,
		xx	: 16,
		yy	: 14,
		r	: 0,
	},
]

// loop por todos os floor, e avalia quais props ele consegue portar
var _floor_data = []
with (obj_floor) {
	var _possible_props = []
	for (var i = 0; i < array_length(_prop_data); i++) {
		var _prop = _prop_data[i]
		
		// test this tile against each prop
		var _x1 = x - 16
		var _y1 = y - 16
		var _x2 = _x1 + _prop.wid
		var _y2 = _y1 + _prop.hei
		
		// check if it has space for that prop
		if (collision_rectangle(_x1, _y1, _x2, _y2, obj_vacuo, false, true)) {
			continue;
		}
		
		array_push(_possible_props, i)
	}
	array_push(_floor_data, [id, _possible_props])
}

// place prop on floors
for (var i = array_length(_floor_data)-1; i >= 0 ; i--) {
	var _floor_info = _floor_data[i]
	var _floor_id	= _floor_info[0]
	var _floor_list = _floor_info[1]
	var _list_len	= array_length(_floor_list)
	
	if (instance_exists(_floor_id)) {
		if (random(1) <= _prop_chance && _floor_id.create_prop && _list_len) {
			with (_floor_id) {
			
				// choose one prop to create
				var _prop_selected = _floor_list[irandom(_list_len-1)]
				var _prop = _prop_data[_prop_selected]
				
				var _x = _floor_id.x + _prop.xx + irandom_range(-_prop.r, _prop.r)
				var _y = _floor_id.y + _prop.yy + irandom_range(-_prop.r, _prop.r)
			
				with (instance_create_layer(_x, _y, "inst_props", obj_prop_general)) {
					sprite_index = _prop.spr
					image_xscale = choose(-1, 1) // Krug: deixei aqui opcional mas se precisar dps é só tirar
				}
			
				// make floors under this prop as unnable to create more props
				var _x1 = x - 16
				var _y1 = y - 16
				var _x2 = _x1 + _prop.wid
				var _y2 = _y1 + _prop.hei
			
				var _list = ds_list_create()
				var _num = collision_rectangle_list(_x1, _y1, _x2, _y2, obj_floor, false, false, _list, false)
				for (var j = 0; j < _num; j++) {
					var _nei = _list[| j]
					_nei.create_prop = false
				}
				ds_list_destroy(_list)
			}
		}
	}
}
















