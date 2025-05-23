global.area = 0;
randomize()
#macro CRIA_PAREDE instance_create_layer(x, y, "Instances", obj_colisor)

function Item_Creator(_chest)
{		
	if(instance_exists(obj_player))
	{
		var _playerDist = point_distance(x, y, obj_player.x, obj_player.y);
		var _colisao = collision_circle(x, y, 24, obj_colisor, false, false);
		var _dist = 96;

		
		if(_playerDist > _dist && !_colisao)
		{
			instance_create_layer(x, y, "Instances", _chest);	
		}		
	}		
}
function Cria_Dois(_obj1, _obj2)
{		
	if(instance_exists(obj_player))
	{
		var _playerDist = point_distance(x, y, obj_player.x, obj_player.y);
		var _colisao = collision_circle(x, y, 24, obj_colisor, false, false);
		var _dist = 96;

		
		if(_playerDist > _dist && !_colisao)
		{
			instance_create_layer(x-16, y, "Instances", _obj1);	
			instance_create_layer(x+16, y, "Instances", _obj2);	
		}		
	}		
}

function Drunken_Walk_Improved(steps, walker_count, dir_repeats)
{
    randomize();
    var _size = 32;
    var _x = room_width div _size;
    var _y = room_height div _size;
    
    // Cria as paredes (obj_vacuo) em todo o grid
    for(var i = 0; i < _x; i += 1)
    {
        for(var j = 0; j < _y; j += 1)
        {
            instance_create_layer(_size * i, _size * j, "vacuo", obj_vacuo);
        }
    }
   
    // Cria os walkers e faz eles "escavarem" o mapa
    for(var w = 0; w < walker_count; w += 1)
    {
        var _wx = irandom_range(5 * _size, (_x - 8) * _size);
        var _wy = irandom_range(5 * _size, (_y - 8) * _size);
        instance_create_layer(_wx, _wy, "vacuo", obj_walker);
    }
    
    // Aumenta o número de passos para garantir mais áreas abertas
    repeat(steps) // Aumentei em 50% os passos para mais escavação
    {
        with(obj_walker)
        {
            if(irandom_range(1, dir_repeats) == 1)
            {
                direction = irandom(3) * 90;
            }
            x += lengthdir_x(_size, direction);
            y += lengthdir_y(_size, direction);
            var col = instance_place(x, y, obj_vacuo);
            if(col) { instance_destroy(col); }
            x = clamp(x, 5 * _size, (_x - 8) * _size);
            y = clamp(y, 5 * _size, (_y - 8) * _size);
        }
    }
    
    
    // Spawn do player com verificação mais robusta
    var player_spawned = false;
    var attempts = 0;
    var max_attempts = 200; // Limite para evitar loop infinito
    
    while (!player_spawned && attempts < max_attempts)
    {
        var _px = irandom_range(16 * _size, (_x - 32) * _size); // Offset grande como você testou
        var _py = irandom_range(16 * _size, (_y - 32) * _size);
        
        // Verifica se a posição está livre de paredes
        if (!instance_position(_px, _py, obj_vacuo)) // Usando place_meeting para checar colisão
        {
            instance_create_layer(_px, _py, "chao", obj_player);
            player_spawned = true;
            show_debug_message("Player spawned at: " + string(_px) + ", " + string(_py));
        }
        else
        {
            show_debug_message("Tentativa " + string(attempts) + ": Posição " + string(_px) + ", " + string(_py) + " tem parede");
        }
        attempts += 1;
    }
    
    // Se não conseguir spawnar, avisa
    if (!player_spawned)
    {
        show_debug_message("Erro: Não foi possível encontrar posição livre para o player após " + string(max_attempts) + " tentativas!");
        // Spawn de emergência no centro como fallback
        instance_create_layer(room_width / 2, room_height / 2, "chao", obj_player);
    }
    
   
}

function get_attack_direction(){
	var _dir = point_direction(obj_player.x, obj_player.y, mouse_x, mouse_y); // Calcula a direção com base no mouse
   
	return _dir;
}

// Use essa função para causar dano no player
function deal_damage_to_player(_dmg, _knockback_strenght, _knockback_dir){
	if (instance_exists(obj_player))
	{
		with (obj_player)
		{
			// rodar SFX DE DANO
			vida -= _dmg;
			global.aberracao_cromatica = 35
			sleep(50)
			if (vida <= 0)
			{
				show_message("Morreu")
				room_restart();
			}
			else
			{
				on_knockback = true;
				knockback_strenght = _knockback_strenght;
				knockback_dir = _knockback_dir;
				
				//obj_camera.camera.shake(4, .25);
				//omnicam_shake(15, 10)
			}
		}
	}
}

function tomar_dano_inimigo(dano, chance_critico, multiplicador_critico, fonte,_knockback) {
    var critico = false; // Inicializa o valor do crítico como falso
    var dano_final = dano; // Dano inicial é o dano base
	//sleep(5)
    // Verifica se o ataque será crítico com base na chance fornecida
    if (random(100) < chance_critico) {
        if critico != true
		{
			critico = true
			//obj_camera.camera.shake(1.005,.05)
			//omnicam_shake(60, 3)
		}
        dano_final *= multiplicador_critico; // Aplica o multiplicador de crítico ao dano
    }

    if (!escudo && cooldown_hit <= 0) {
        // Calcular a direção para aplicar o knockback
        if (fonte != id)
		{
			var dir = point_direction(fonte.x, fonte.y, x, y);
			velh = lengthdir_x(_knockback, dir);
			velv = lengthdir_y(_knockback, dir);
		}
        // Aplicar efeito de escala temporário ao inimigo
        //xscale = 1.2*lado;
        //yscale = 0.8
		estado = "Hurt"
        // Definir cooldown para o próximo hit
        cooldown_hit = 5;
		
        // Resetar o tempo fora de combate do player
        fonte.tempo_sem_bater_em_inimigos = 0;
		if (fonte != id)
		{
		
		
			
        // Efeitos visuais de hit
        // Reduzir a vida do inimigo
        vida -= dano_final;
	
        // Definir tempo de flash e marcar que o inimigo tomou um hit
        if tempo_flash != 5
		{
			//global.aberracao_cromatica = 10
			//var _somataque = choose(Hit_1,Hit_2,Hit_3,Hit_4)
			//audio_sound_pitch(_somataque,random_range(.6,1.4))
			//saudio_sound_play_at(obj_audio_control.effect_group,_somataque , x,y,0);
			
			//var _somataque = choose(monster_hit_1,monster_hit_2)
			//audio_sound_pitch(_somataque,random_range(.8,1.2))
			//saudio_sound_play_at(obj_audio_control.effect_group,_somataque , x,y,0);
			
			
		// Criar instância do número de dano
        var numero_dano = instance_create_layer(x, y, "chao", obj_num_dano);
        numero_dano.x = x + random_range(-20,20) + 2 * sign(velh);
        numero_dano.y = y + random_range(-10,10) - 16;
        numero_dano.numero = dano_final;

        // Ajustar cor e escala do número de dano com base no crítico
        if (critico) {
			
			obj_player.alarm[1] = 30;
			global.aberracao_cromatica = 10
			//obj_camera.camera.zoom(obj_player.zoom_punch, .1);
			omnicam_zoom(obj_player.zoom_punch, true)
			obj_player.zoom_punch += .01;
			sleep(20)	
			if(obj_player.zoom_punch>= 1.2) obj_player.zoom_punch = 1.2
				
            numero_dano.cor = c_red;
			numero_dano.preset = "[shake][scale,1.5]"
           
        } else {
            numero_dano.cor = c_white;
            
        }
		tempo_flash = 1
		}
        //tomei_hit = true;

        randomize(); // Randomizar para garantir variação em efeitos, se necessário
		}
	}
}

/// array_index_of(array, value)
/// Retorna o índice de `value` dentro de `array`, ou -1 se não for encontrado.
function array_index_of(_array, _value) 
{
    var _len = array_length(_array);
    for (var i = 0; i < _len; i++) 
    {
        if (_array[i] == _value) 
        {
            return i;
        }
    }
    return -1; // Retorna -1 se o valor não existir no array
}

function wrap(value, _min, _max){
	if (value mod 1 == 0){
		while (value > _max || value < _min){
		    if (value > _max) value += _min - _max - 1;
		    else if (value < _min) value += _max - _min + 1;
		}
		return(value);
	} else {
		var vOld = value + 1;
		while (value != vOld){
		    vOld = value;
		    if (value < _min) value = _max - (_min - value);
		    else if (value > _max) value = _min + (value - _max);
		}
		return(value);
	}
}

//	Wrap (rapido)
//	Algoritmo mais simples e leve que envolve o valor dentro do intervalo (precisão baixa).
function qwrap(value, _min, _max){
	if (value > _max) return _min;
	else if (value < _min) return _max;
	else return value;
}

function wrap_index(val, _min, _max) {
    var range = _max - _min;
    var result = (val - _min) % range;
    if (result < 0) result += range;
    return result + _min;
}

function spark(_x, _y, spd, dir, spread, amount, _decay, color1, color2, width_reduction, _outline_width){
	
	for (var i = 0; i < amount; i++){
		instance_create_layer(_x, _y, "Bloom", obj_spark,{
				speed: spd,
				direction: dir + random_amp(spread),
				decay: _decay * random_range(.66, 1),
				c1: color1,
				c2: color2,
				w: width_reduction,
				outline_width: _outline_width
			}
		)
	}
}

//TODO transforma isso em um vertex buffer pelo amor de Deus
function hollow_circle(_x, _y, r1, r2, sn, istart = 0){
    var i; i = istart;
    draw_primitive_begin(pr_trianglestrip);
    repeat (sn + 1){
        var d, dx, dy;
        d = i / sn * 360;
        dx = lengthdir_x(1, d);
        dy = lengthdir_y(1, d);
        draw_vertex(_x + dx * r1, _y + dy * r1);
        draw_vertex(_x + dx * r2, _y + dy * r2);
        i += 1;
    }
    draw_primitive_end();
}

function random_amp(amp) { return random_range(-amp * .5, amp * .5) };

function collision(obj)
{
	var _velh = sign(velh);
	var _velv = sign(velv);
	
	//Colisão Horizontal
	if(place_meeting(x + velh, y, obj))
	{
		while(!place_meeting(x + _velh, y, obj))
		{
			x += _velh;	
		}
		velh = 0;
	}
	
	//Colisão Vertical
	if(place_meeting(x, y + velv, obj))
	{
		while(!place_meeting(x, y + _velv, obj))
		{
			y += _velv;	
		}
		velv = 0;
	}
}

function sleep(ms){
	var t = current_time + ms;
	while (current_time < t) {};
}

///@func choose_weighted(item1, weight1, item2, weight2, ...)
function choose_weighted(_item1, _weight1, _item2, _weight2) {
    if (argument_count mod 2 != 0 || argument_count == 0) {
        show_error("Expected an even number of arguments greater than 0, got " + string(argument_count) + ".", true);
    }
    
    var _item_index        = 0
    var _item_count        = argument_count >> 1
    var _item_array        = array_create(_item_count)
    var _cumul_weights    = array_create(_item_count)
    var _total_weight    = 0    
    
    var i = 0;
    repeat (_item_count) {
        _item_array[_item_index] = argument[i++];
        _total_weight += argument[i++];
        _cumul_weights[_item_index] = _total_weight;
        _item_index++;
    }    

    var _rand = random(_total_weight);
    for (var j = 0; j < _item_count; j++) {
        if (_rand < _cumul_weights[j]) {
            return _item_array[j];
        }
    }
    
    return _item_array[_item_count-1];
}


// sprite pra ser usada
// largura mínima necessária pro objeto aparecer
// altura mínima necessária pro objeto aparecer
// offset do x
// offset do y
// valor máximo de random pra aplicar na posição
// events = create, step, draw, destroy
function PropObject(_spr, _wid, _hei, _xoff, _yoff, _xr, _yr, _solid, _events = {}) constructor {
	
	spr		= _spr			// sprite pra ser usada
	wid		= _wid			// largura mínima necessária pro objeto aparecer
	hei		= _hei			// altura mínima necessária pro objeto aparecer
	xoff	= _xoff			// offset do x
	yoff	= _yoff			// offset do y
	xr		= _xr			// move aleatório no x
	yr		= _yr			// move aleatório no y
	solid	= _solid		// se tem colisao
	events	= {}
	
	// apply custom events
	var _keys = struct_get_names(_events)
	var _len = array_length(_keys)
	for (var i = 0; i < _len; i++) {
		var _key = _keys[i]
		events[$ _key] = method(self, _events[$ _key])
	}
}

































