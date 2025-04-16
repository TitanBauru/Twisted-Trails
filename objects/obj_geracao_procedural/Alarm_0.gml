// Krug: Object Prop Creation

var _prop_chance = 0.4		// chançe daquele chao criar um prop
var _prop_data = [			// struct contendo informações sobre cada prop. Se for adicionar muitas, compensa criar um constructor
	new PropObject([spr_poste_1, spr_poste_2], 16, 16, 0, 0, 12, 12, false),
	new PropObject(spr_arcade_1, 32, 32, 0, 4, 6, 6, false),
	new PropObject([spr_carro_1, spr_carro_2], 64, 32, 16, 14, 0, 0, true, {
		create : function() {			
			// evita do carro criar em cima do player
			if (place_meeting(x, y, obj_player)) {
				instance_destroy(id, false)
			}
			xscale = 1
			yscale = 1
			ang = 0
			flash_white = 0
			life = 200
		},
		step : function() {
			// colisao com a bala
			var _bullet = instance_place(x, y, obj_bullet)
			if (_bullet) {				
				// squash
				xscale = 0.8
				xscale = 1.2
				flash_white = 1
				ang += random_range(-3, 3)
				
				// Criar instância do número de dano
		        var numero_dano = instance_create_layer(x, y, "chao", obj_num_dano);
		        numero_dano.x = x + random_range(-20,20);
		        numero_dano.y = y + random_range(-10,10) - 16;
				numero_dano.cor = c_white;
		        numero_dano.numero = _bullet.damage;
				
				// vfx
				repeat(8) instance_create_layer(x+random_range(-12,12), y+random_range(-12,12), "Bloom", obj_pop, { width: irandom_range(2, 12), lerpval : .9 });
				repeat(irandom(16)) spark(x, y, random(10), random(360), 120, 8, .9, c_white, c_white,2, 0);
				repeat(random_range(10,20)) 
				{
					var poeira = instance_create_layer(x,y-8,"Instances",obj_dustwalk)
					 poeira.speed = random(1);
					 poeira.direction = random(360);
				}
				repeat(irandom(3)) instance_create_layer(x+random_range(-12,12), y+random_range(-12,12),"Bloom",obj_vfx_1);
	            instance_create_layer(x, y,"Bloom",obj_vfx_2);
				
				life -= _bullet.damage
				if (life <= 0) {
					instance_destroy()
				}
				
				instance_destroy(_bullet)
			}
			
			xscale	= lerp(xscale, 1, 0.1)
			yscale	= lerp(yscale, 1, 0.1)
			ang		= lerp(ang, 0, 0.1)			
			flash_white = max(0, flash_white - 0.05)
		},
		draw : function() {
			draw_sprite_ext(sprite_index,image_index,x,y,xscale,yscale,ang,image_blend,image_alpha)
			
			gpu_set_fog(true, c_white, 1, 0);
			draw_sprite_ext(sprite_index, image_index, x, y, xscale, yscale, ang, c_white, flash_white);
			gpu_set_fog(false, c_white, 0, 1);
		},
		destroy : function() {
			instance_destroy(id)
		},
	}),
	new PropObject(spr_lanterna_1, 16, 16, 0, 4, 6, 6, false),
	new PropObject(spr_lixo, 16, 16, 0, 4, 12, 12, false),
	new PropObject(spr_lixo_2, 16, 16, 0, 4, 12, 12, false),
	new PropObject(spr_lata_de_lixo, 16, 16, 0, 4, 12, 12, false),
	new PropObject(spr_caixa_1, 16, 16, 0, 4, 12, 12, false),
	new PropObject(spr_garrafas_1, 16, 16, 0, 4, 12, 12, false),
	new PropObject(spr_garrafas_2, 16, 16, 0, 4, 12, 12, false),
	new PropObject(spr_hidrante, 16, 16, 0, 4, 12, 12, false),
	new PropObject(spr_boeiro, 16, 16, 0, 4, 4, 4, false, {
		create : function() {
			depth = layer_get_depth(layer)	// remove o depthsort
		},
	}),
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
				
				// starts from floor center
				var _x = _floor_id.x + _prop.xoff + irandom_range(-_prop.xr, _prop.yr)
				var _y = _floor_id.y + _prop.yoff + irandom_range(-_prop.xr, _prop.yr)
			
				// create desired prop
				var _inst = instance_create_layer(_x, _y, "inst_props", _prop.solid ? obj_prop_solid : obj_prop_general)
				with (_inst) {
					sprite_index = is_array(_prop.spr) ? _prop.spr[irandom(array_length(_prop.spr)-1)] : _prop.spr
					image_xscale = choose(-1, 1) // Krug: deixei aqui opcional mas se precisar dps é só tirar
					
					// copia os eventos do prop pra instancia criada
					var _keys = struct_get_names(_prop.events)
					var _len = array_length(_keys)
					for (var j = 0; j < _len; j++) {
						var _key = _keys[j]
						self[$ _key] = method(self, _prop.events[$ _key])
					}

					// faz ele rodar o create custom
					create()
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
















