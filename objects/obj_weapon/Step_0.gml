visible = true
// Define o lado da espada com base na posição do player
var _lado_da_espada = obj_player.lado;

if (arma_ativa.ammo < 0) { // Verifica se a arma tem munição infinita
    // Ajusta a escala horizontal do sprite com base no lado da espada
    xscale = (_lado_da_espada == 1) ? -1 : 1;
}


var current_index = array_index_of(weapon_list, arma_ativa.nome);

if (mouse_wheel_up())
{
    current_index++;
    current_index = wrap_index(current_index, 0, array_length(weapon_list));
    var new_weapon_visible_name = weapon_list[current_index];
    var new_weapon_internal_name = variable_struct_get(weapon_name, new_weapon_visible_name);
    if (variable_instance_exists(self, new_weapon_internal_name))
    {
        arma_ativa = self[$ new_weapon_internal_name];
    }
}

if (mouse_wheel_down())
{
    current_index--;
    current_index = wrap_index(current_index, 0, array_length(weapon_list));
    var new_weapon_visible_name = weapon_list[current_index];
    var new_weapon_internal_name = variable_struct_get(weapon_name, new_weapon_visible_name);
    if (variable_instance_exists(self, new_weapon_internal_name))
    {
        arma_ativa = self[$ new_weapon_internal_name];
    }
}








var _posicao_da_espada, _atraso_da_espada;
_atraso_da_espada = 0.2; // Define o atraso na posição da espada
_posicao_da_espada = obj_player.x - 6 * _lado_da_espada; // Calcula a posição inicial da espada

if (recarregando) {
    tempo_recarga_atual--; // Reduz o contador de recarga

    if (tempo_recarga_atual <= 0) {
        recarregando = false; // Termina o processo de recarga
        arma_ativa.ammo = arma_ativa.ammo_max; // Recarrega a arma completamente
       // sprite_index = arma_ativa.sprite[0]; // Retorna ao sprite padrão de idle ou ativo
    }
}




if (arma_ativa.ammo >= 0) { // Verifica se a arma ainda tem munição
    arma_solo(); // Executa a função específica para a arma
	// Controle de teclas para iniciar a recarga (pode ser uma tecla específica ou um botão)
	if (keyboard_check_pressed(ord("R"))){
	    reload();
	}
    if (arma_ativa.dano <= 0) arma_ativa.dano = 1; // Garante que o dano da arma não seja zero ou negativo

    //global.arma_atual = object_index; // Atualiza a arma atual no escopo global
    
    var _sep = -12; // Offset vertical para a posição do mouse        
	dir = get_attack_direction();
    
    // Alinha a arma com o lado correto
    arrumar_lado_arma();
    //arrumar_lado_arma_controle();

    // Faz a arma seguir a posição do player
    // Calcula a distância entre o player e o mouse
	var distance_to_mouse = point_distance(target.x, target.y, mouse_x, mouse_y);
	
	// Ajusta a distância da arma com base na distância do mouse
	var dynamic_len = lerp(16, 64, clamp(distance_to_mouse / 600, 0, 1)); // Ajusta os valores conforme necessário
	
	// Faz a arma seguir a posição do player com base na nova distância
	x = target.x + lengthdir_x(dynamic_len, dir);
	y = target.y + lengthdir_y(dynamic_len, dir);


    // ----- Atirando -----
    var shot_key; // Variável para determinar se o tiro deve ser disparado

    // Verifica se a arma é automática ou semi-automática e define a tecla de disparo
    if (arma_ativa.automatico) {
        shot_key = mouse_check_button(mb_left)
    } else {
        shot_key = mouse_check_button_pressed(mb_left);  
    }

    if (cooldown > 0) cooldown--; // Reduz o cooldown se ainda houver
	if (shot_key && arma_ativa.ammo <= 0) reload();
    if (shot_key && cooldown <= 0 && arma_ativa.ammo > 0 && !recarregando) { // Verifica se pode atirar
        alarm[3] = 10; // Ativa um alarme para algum efeito
        randomize(); // Randomiza para garantir variação nos efeitos
		var _projX = lengthdir_x(arma_ativa.dist, dir);  
		var _projY = lengthdir_y(arma_ativa.dist, dir);  
		spark(x + _projX,y + _projY,random(6),dir,80,12,.95,c_white,c_white,1,0)
		
		estado_da_arma = 1
		obj_camera.camera.shake(1,.1);
		amp = random_range(.6, .9);
		var _weapon_name = weapon_name[$ arma_ativa.nome];
		var _weapon = self[$ _weapon_name];		
		audio_play_sound(_weapon.sound, 1, 0,,,amp);        
        recoil = arma_ativa.recoil_amount; // Aplica o recuo da arma
		precisao_inicial += precisao_incremento
		if precisao_inicial > arma_ativa.precisao precisao_inicial = arma_ativa.precisao					
		angle += 10*yscale*recoil
		// Aplica uma deformação no player (squish effect)
        with (target) {
            xscale = 1.7 * other.lado;
            yscale = 0.6; 
        }		
		// Aplica knockback no player ao disparar        
		obj_player.take_knockback(arma_ativa.knockback, dir-180);
		cooldown = arma_ativa.atk_speed;
        weapon_shoot();			
        // Reseta o cooldown para o tempo de ataque da arma
        
    }

    depth = obj_player.depth - 1; // Ajusta a profundidade do objeto

} else { // Caso a arma esteja sem munição
    // Lógica de ataque com espada ou arma sem munição
    if (mouse_check_button_released(mb_left) ) {
      
	  direction = point_direction(obj_player.x, obj_player.y, mouse_x, mouse_y); // Calcula a direção
      
	  depth = obj_player.depth - 1; // Ajusta a profundidade
      
	  _posicao_da_espada = obj_player.x - 6 * _lado_da_espada + lengthdir_x(12, direction); // Calcula a nova posição da espada
      
	  _atraso_da_espada = 0.5; // Define o atraso para a espada
      
	  angle = 0; // Reseta o ângulo
	  
	  if (atacando){
			atacando = false;
				
		}
      
	  y = obj_player.y + lengthdir_y(12, direction); // Ajusta a posição y da espada
    }
    if ((mouse_check_button(mb_left))) {
        
		_posicao_da_espada = obj_player.x - 12 * _lado_da_espada * -1; // Ajusta a posição da espada
        
		_atraso_da_espada = 0.3; // Define o atraso para a espada
        
		angle = lerp(angle, 180 * _lado_da_espada * -1, 0.2); // Ajusta o ângulo da espada
       
		direction = get_attack_direction();
		
        x = obj_player.x + lengthdir_x(12, direction); // Ajusta a posição x da espada
        y = obj_player.y + lengthdir_y(12, direction); // Ajusta a posição y da espada
        depth = -bbox_bottom; // Ajusta a profundidade

        if (!instance_exists(obj_slash)) { // Cria o efeito de slash se ainda não existir
            if (_posicao_da_espada == (obj_player.x - 12 * _lado_da_espada * -1) && cooldown <= 0) {
                criar_slash(_lado_da_espada); // Função para criar o efeito de slash
            }
        }
		if (!atacando){
			atacando = true;
					
		}
    }
}


// Define o sprite da arma ativa
// Exemplo de como acessar o sprite atual da arma
sprite_index = arma_ativa.sprite[estado_da_arma]

if (image_index >= image_number - 1) estado_da_arma = 0

//if (image_index >= image_number - 1 )sprite_index = arma_ativa.sprite[0];
// Se não estiver recarregando
if (arma_ativa.ammo_max > 0)
{
	if !(recarregando) {
	    // Calcula a diferença de ângulo e interpola suavemente
	    var ang_diff = angle_difference(dir, angle);
	    angle += ang_diff * 0.1;
	} else {
	    // Se estiver recarregando, gira suavemente para um ângulo maior (exemplo: +200 graus)
	    var ang_diff = angle_difference(angle, angle + 259);
	    angle += ang_diff * 0.2;
	}
}


// Interpola a posição da espada para suavizar o movimento
x = lerp(x, _posicao_da_espada, _atraso_da_espada);
y = lerp(y, obj_player.y - 8, 0.5);


	var cooldown_decrease = (1)	

if (cooldown > 0) cooldown -= 1 * cooldown_decrease; // Reduz o cooldown se ainda houver

precisao_inicial -= (precisao_inicial * precisao_decay_percent) + precisao_decay_constant
if (precisao_inicial < 0) precisao_inicial = 0

recoil *= target.xscale
recoil = lerp(recoil,0,0.2)
x-=lengthdir_x(recoil,dir)
y-=lengthdir_y(recoil,dir)
 scribble( "Dano: [c_red]"+string(arma_ativa.dano)).draw(20,35)
   scribble( "Atk Speed: [c_red]"+string(arma_ativa.atk_speed)).draw(20,50) 
	scribble("Ammo: [c_red]"+string(arma_ativa.ammo_max)).draw(20,65) 
   scribble( "Reload: [c_red]"+string(arma_ativa.cd_reload)).draw(20,80)
   scribble( "Precisao: [c_red]"+string(arma_ativa.precisao)).draw(20,95) 
   scribble( "Num Projetil: [c_red]"+string(arma_ativa.num_projectiles)).draw(20,110)
   scribble( "Proj Speed: [c_red]"+string(arma_ativa.projetil_speed)).draw(20,125) 
//Debug 
if (keyboard_check_pressed(vk_f2))
{
	arma_ativa.dano = get_integer("Dano",0)
}
//Debug 
if (keyboard_check_pressed(vk_f3))
{
	arma_ativa.atk_speed = get_integer("Atk Speed",0)
}
//Debug 
if (keyboard_check_pressed(vk_f4))
{
	arma_ativa.ammo_max = get_integer("Ammo max",0)	
}
//Debug 
if (keyboard_check_pressed(vk_f5))
{
	arma_ativa.cd_reload = get_integer("Cd Reload",0)	
}
//Debug 
if (keyboard_check_pressed(vk_f6))
{
	arma_ativa.precisao	= get_integer("Precisao",0)
}
//Debug 
if (keyboard_check_pressed(vk_f7))
{
	arma_ativa.num_projectiles	= get_integer("Num Projeteis",0)
}
//Debug 
if (keyboard_check_pressed(vk_f8))
{
	arma_ativa.projetil_speed	= get_integer("Projetil Speed",0)
}
