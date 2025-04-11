// No objeto: obj_item_database
// Create Event (versão melhorada)

// Inicializar arrays para armazenar informações dos itens
global.items = [];
global.total_items = 0;

// Construtor de item melhorado
function ItemConstructor(_id, _name, _description, _sprite, _price, _rarity, _effects = {}) constructor {
    id_item = _id;
    name = _name;
    description = _description;
    sprite_index_item = _sprite;
    price = _price;
    rarity = _rarity;  // Comum, incomum, raro, lendário, etc.
    effects = {};      // Objeto com configurações de efeitos
    
    // Processar efeitos passados com suas propriedades
    var _effect_names = variable_struct_get_names(_effects);
    for (var i = 0; i < array_length(_effect_names); i++) {
        var _effect_name = _effect_names[i];
        var _effect_value = _effects[$ _effect_name];
        
        // Verificar se o efeito foi passado como um booleano simples ou como uma estrutura
        if (is_bool(_effect_value)) {
            // Se for um booleano, criar estrutura com valor padrão para contínuo (true)
            effects[$ _effect_name] = {
                active: _effect_value,
                is_continuous: true,
                used: false,
                power_fx: 1.0  // Poder/intensidade padrão do efeito
            };
        } else {
            // Se for uma estrutura, usar os valores fornecidos
            effects[$ _effect_name] = _effect_value;
            
            // Garantir que tenha propriedades padrão se não foram fornecidas
            if (!variable_struct_exists(effects[$ _effect_name], "active")) {
                effects[$ _effect_name].active = true;
            }
            if (!variable_struct_exists(effects[$ _effect_name], "is_continuous")) {
                effects[$ _effect_name].is_continuous = true;
            }
            if (!variable_struct_exists(effects[$ _effect_name], "used")) {
                effects[$ _effect_name].used = false;
            }
            if (!variable_struct_exists(effects[$ _effect_name], "power_fx")) {
                effects[$ _effect_name].power_fx = 1.0;
            }
        }
    }
    
    // Métodos para gerenciar os efeitos
    static activate_effect = function(effect_name) {
        if (variable_struct_exists(effects, effect_name)) {
            effects[$ effect_name].active = true;
            return true;
        }
        return false;
    }
    
    static deactivate_effect = function(effect_name) {
        if (variable_struct_exists(effects, effect_name)) {
            effects[$ effect_name].active = false;
            return true;
        }
        return false;
    }
    
    static has_effect = function(effect_name) {
        return variable_struct_exists(effects, effect_name) && effects[$ effect_name].active;
    }
    
    static is_effect_continuous = function(effect_name) {
        return variable_struct_exists(effects, effect_name) && effects[$ effect_name].is_continuous;
    }
    
    static use_effect = function(effect_name) {
        if (variable_struct_exists(effects, effect_name)) {
            if (!effects[$ effect_name].is_continuous) {
                // Marcar como usado se for um efeito de uso único
                effects[$ effect_name].used = true;
                
                // Opcionalmente, desativar após o uso (depende da lógica do jogo)
                effects[$ effect_name].active = false;
            }
            return true;
        }
        return false;
    }
    
    static can_use_effect = function(effect_name) {
        return variable_struct_exists(effects, effect_name) && 
               effects[$ effect_name].active && 
               (!effects[$ effect_name].used || effects[$ effect_name].is_continuous);
    }
    
    // Método para aplicar os efeitos ao jogador
    static apply_effects = function(player_instance) {
        var _effect_names = variable_struct_get_names(effects);
        
        for (var i = 0; i < array_length(_effect_names); i++) {
            var _effect_name = _effect_names[i];
            var _effect = effects[$ _effect_name];
            
            if (_effect.active) {
                if (_effect.is_continuous) {
                    // Aplicar efeitos contínuos
                    apply_continuous_effect(player_instance, _effect_name, _effect.power_fx);
                } else if (!_effect.used) {
                    // Aplicar efeitos únicos (se ainda não usados)
                    apply_one_time_effect(player_instance, _effect_name, _effect.power_fx);
                    _effect.used = true; // Marcar como usado
                }
            }
        }
    }
    
    // Aplicar efeitos contínuos (passivos)
    static apply_continuous_effect = function(player_instance, effect_name, power_fx) {
        switch(effect_name) {
            case "increase_speed":
               // player_instance.movement_speed += 0.5 * power_fx;
                break;
            
        }
    }
    
    // Aplicar efeitos de uso único
    static apply_one_time_effect = function(player_instance, effect_name, power_fx) {
        switch(effect_name) {
            case "curar_player":
			{
                player_instance.vida += 2 * power_fx;
                player_instance.vida = min(player_instance.vida, player_instance.vida_max);
                
                break;
			}
		}
    }
}

// Função para adicionar um item ao banco de dados
function add_item(_name, _description, _sprite, _price, _rarity, _effects = {}) {
    var _id = global.total_items;
    var _item = new ItemConstructor(_id, _name, _description, _sprite, _price, _rarity, _effects);
    global.items[_id] = _item;
    global.total_items++;
    return _id;
}

// No objeto: obj_item_database
// Create Event (continuação)

function initialize_item_database() {
    // Itens com efeitos contínuos (passivos)
    add_item(
        "Band-Aid", 
        "Você se cura um pouco.",
        spr_capsula, 
        0, 
        "Comum",
        { 
            curar_player: { active: true, is_continuous: false, power_fx: 1.0 }
        }
    );
    
    // Continue adicionando mais itens...
}

initialize_item_database()
show_message(global.items)
show_message( global.total_items)