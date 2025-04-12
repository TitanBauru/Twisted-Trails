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
                power_fx_fx: 1.0  // Poder/intensidade padrão do efeito
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
            if (!variable_struct_exists(effects[$ _effect_name], "power_fx_fx")) {
                effects[$ _effect_name].power_fx_fx = 1.0;
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
                    apply_continuous_effect(player_instance, _effect_name, _effect.power_fx_fx);
                } else if (!_effect.used) {
                    // Aplicar efeitos únicos (se ainda não usados)
                    apply_one_time_effect(player_instance, _effect_name, _effect.power_fx_fx);
                    _effect.used = true; // Marcar como usado
                }
            }
        }
    }
    
    // Aplicar efeitos contínuos (passivos)
    static apply_continuous_effect = function(player_instance, effect_name, power_fx_fx) {
        switch(effect_name) {
            case "increase_speed":
               // player_instance.movement_speed += 0.5 * power_fx_fx;
                break;
            
        }
    }
    
    // Aplicar efeitos de uso único
    static apply_one_time_effect = function(player_instance, effect_name, power_fx_fx) {
        switch(effect_name) {
            case "curar_player":
			{
                player_instance.vida += 2 * power_fx_fx;
                player_instance.vida = min(player_instance.vida, player_instance.vida_max);
                
                break;
			}
			case "aumentar_dano":
			{
				obj_player.dano_armas *= 1 + power_fx_fx;	
				
				obj_weapon.arma_ativa.dano = (obj_weapon.arma_ativa.dano_base * obj_player.dano_armas)
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
// No objeto: obj_item_database
// Função initialize_item_database() corrigida

function initialize_item_database() {
    // ---------- ITENS COMUNS ----------
    
    // 1. Anel de Ferro Corroído
    add_item(
        "Anel de Ferro Corroído", 
        "Aumenta o dano base em 10%, mas reduz a cadência em 5%.",
        spr_dokrl, 
        50, // preço sugerido
        "Comum",
        {
            // Modificadores de stats permanentes (aplicados uma vez)
            aumentar_dano: { active: true, is_continuous: false, power_fx: 1 },
            //decrease_fire_rate: { active: true, is_continuous: false, power_fx: 0.05 }
        }
    );
    
    // 2. Propulsores Sombrios
    add_item(
        "Propulsores Sombrios", 
        "Aumenta a velocidade de movimento em 10%, mas reduz a vida máxima em 5%.",
        spr_dokrl, 
        50,
        "Comum",
        {
            increase_speed: { active: true, is_continuous: false, power_fx: 0.1 },
            decrease_max_health: { active: true, is_continuous: false, power_fx: 0.05 }
        }
    );
    
    // 3. Placa de Aço Quebrada
    add_item(
        "Placa de Aço Quebrada", 
        "Aumenta a defesa em 10%, mas reduz o dano em 5%.",
        spr_dokrl, 
        50,
        "Comum",
        {
            increase_defense: { active: true, is_continuous: false, power_fx: 0.1 },
            decrease_damage: { active: true, is_continuous: false, power_fx: 0.05 }
        }
    );
    
    // 4. Manoplas de Frequência
    add_item(
        "Manoplas de Frequência", 
        "Aumenta a cadência em 10%, mas reduz a precisão em 5%.",
        spr_dokrl, 
        50,
        "Comum",
        {
            increase_fire_rate: { active: true, is_continuous: false, power_fx: 0.1 },
            decrease_accuracy: { active: true, is_continuous: false, power_fx: 0.05 }
        }
    );
    
    // ---------- ITENS RAROS ----------
    
    // 5. Colar Parasítico
    add_item(
        "Colar Parasítico", 
        "A cada 10 inimigos mortos, cura 10% da vida máxima, mas aumenta o dano recebido em 5%.",
        spr_dokrl, 
        100,
        "Raro",
        {
            // Efeito da cura é contínuo (verifica kills constantemente)
            heal_on_kills: { active: true, is_continuous: true, power_fx: 1.0, kills_required: 10, heal_percent: 0.1 },
            // Modificador de dano recebido é permanente (aplicado uma vez)
            increase_damage_taken: { active: true, is_continuous: false, power_fx: 0.05 }
        }
    );
    
    // 6. Cilindro de Plasma
    add_item(
        "Cilindro de Plasma", 
        "Adiciona 10 de dano de fogo aos ataques, mas reduz a chance de crítico em 5%.",
        spr_dokrl, 
        100,
        "Raro",
        {
            add_fire_damage: { active: true, is_continuous: false, power_fx: 10 },
            decrease_crit_chance: { active: true, is_continuous: false, power_fx: 0.05 }
        }
    );
    
    // 7. Jatos Traiçoeiros
    add_item(
        "Jatos Traiçoeiros", 
        "Aumenta a distância do dash em 20%, mas aumenta o tempo de recarga do dash em 10%.",
        spr_dokrl, 
        100,
        "Raro",
        {
            increase_dash_distance: { active: true, is_continuous: false, power_fx: 0.2 },
            increase_dash_cooldown: { active: true, is_continuous: false, power_fx: 0.1 }
        }
    );
    
    // 8. Gatilhos Frenéticos
    add_item(
        "Gatilhos Frenéticos", 
        "Aumenta a cadência em 0.666% a cada inimigo que você matar (máx. 20%).",
        spr_dokrl, 
        100,
        "Raro",
        {
            // Este é contínuo porque depende de um contador de kills
            stacking_fire_rate: { active: true, is_continuous: true, power_fx: 0.00666, max_stacks: 30 }
        }
    );
    
    // ---------- ITENS ÉPICOS ----------
    
    // 9. Capa do Glitch Crítico
    add_item(
        "Capa do Glitch Crítico", 
        "A cada crítico consecutivo, aumenta a chance de crítico em 5% por 5 segundos (máx. 25%), mas reduz o dano base em 10%.",
        spr_dokrl, 
        200,
        "Épico",
        {
            // Efeito de stack de críticos é contínuo (verifica críticos constantemente)
            crit_stacking: { active: true, is_continuous: true, power_fx: 0.05, max_bonus: 0.25, duration: 300 },
            // Redução de dano base é permanente (aplicado uma vez)
            decrease_base_damage: { active: true, is_continuous: false, power_fx: 0.1 }
        }
    );
    
    // 10. Canhão de Vidro
    add_item(
        "Canhão de Vidro", 
        "Aumenta o dano em 50%, mas reduz a vida máxima em 20%.",
        spr_dokrl, 
        200,
        "Épico",
        {
            increase_damage: { active: true, is_continuous: false, power_fx: 0.5 },
            decrease_max_health: { active: true, is_continuous: false, power_fx: 0.2 }
        }
    );
    
    // 11. Jatos do Vazio
    add_item(
        "Jatos do Vazio", 
        "Ao tomar dano, 20% de chance de não tomar knockback, mas aumenta o dano recebido em 10%.",
        spr_dokrl, 
        200,
        "Épico",
        {
            // Efeito de chance é contínuo (verifica quando recebe dano)
            knockback_resistance: { active: true, is_continuous: true, power_fx: 0.2 },
            // Aumento de dano recebido é permanente (aplicado uma vez)
            increase_damage_taken: { active: true, is_continuous: false, power_fx: 0.1 }
        }
    );
    
    // 12. Punhos do Abismo
    add_item(
        "Punhos do Abismo", 
        "Aumenta o dano em 20% com vida abaixo de 50%, mas reduz a regeneração de vida em 50%.",
        spr_dokrl, 
        200,
        "Épico",
        {
            // Efeito de dano com vida baixa é contínuo (verifica HP constantemente)
            low_health_damage: { active: true, is_continuous: true, power_fx: 0.2, threshold: 0.5 },
            // Redução de regeneração é permanente (aplicado uma vez)
            decrease_health_regen: { active: true, is_continuous: false, power_fx: 0.5 }
        }
    );
    
    // ---------- ITENS LENDÁRIOS ----------
    
    // 13. Faca de Dois Gumes
    add_item(
        "Faca de Dois Gumes", 
        "Aumenta todo o dano em 50%, mas cada ataque consome 5% da vida atual.",
        spr_dokrl, 
        400,
        "Lendário",
        {
            // Aumento de dano é permanente (aplicado uma vez)
            increase_damage: { active: true, is_continuous: false, power_fx: 0.5 },
            // Custo de vida por ataque é contínuo (verifica a cada ataque)
            health_cost_per_attack: { active: true, is_continuous: true, power_fx: 0.05 }
        }
    );
    
    // 14. Armadura do Exílio
    add_item(
        "Armadura do Exílio", 
        "Reduz o dano recebido em 50%, mas reduz o dano causado em 30%.",
        spr_dokrl, 
        400,
        "Lendário",
        {
            decrease_damage_taken: { active: true, is_continuous: false, power_fx: 0.5 },
            decrease_damage: { active: true, is_continuous: false, power_fx: 0.3 }
        }
    );
    
    // 15. Reatores do Caos
    add_item(
        "Reatores do Caos", 
        "Aumenta a velocidade em 50% e dá dash infinito, mas randomiza a direção do dash.",
        spr_dokrl, 
        400,
        "Lendário",
        {
            // Aumento de velocidade é permanente (aplicado uma vez)
            increase_speed: { active: true, is_continuous: false, power_fx: 0.5 },
            // Dash infinito é permanente (aplicado uma vez)
            infinite_dash: { active: true, is_continuous: false, power_fx: 1.0 },
            // Randomização de direção é contínua (verifica a cada dash)
            random_dash_direction: { active: true, is_continuous: true, power_fx: 1.0 }
        }
    );
    
    // 16. Manoplas do Overdrive
    add_item(
        "Manoplas do Overdrive", 
        "Aumenta a cadência em 100%, mas cada tiro tem 50% de chance de falhar.",
        spr_dokrl, 
        400,
        "Lendário",
        {
            // Aumento de cadência é permanente (aplicado uma vez)
            increase_fire_rate: { active: true, is_continuous: false, power_fx: 1.0 },
            // Chance de falha é contínua (verifica a cada tiro)
            shot_failure_chance: { active: true, is_continuous: true, power_fx: 0.5 }
        }
    );
    
    // ---------- ITENS TITAN (ALEO) ----------
    
    // 17. Coroa do Abismo
    add_item(
        "Coroa do Abismo", 
        "Aumenta em 10% por dungeon seus atributos e você perde 10% do seu dinheiro total (a cada dungeon).",
        spr_dokrl, 
        800,
        "TITAN",
        {
            // Ambos são contínuos pois são verificados a cada nova dungeon
            per_dungeon_stats: { active: true, is_continuous: true, power_fx: 0.1 },
            per_dungeon_coin_loss: { active: true, is_continuous: true, power_fx: 0.1 }
        }
    );
    
    // 18. Elixir Titânico
    add_item(
        "Elixir Titânico", 
        "Dobra seu tamanho e sua vida máxima.",
        spr_dokrl, 
        800,
        "TITAN",
        {
            double_size: { active: true, is_continuous: false, power_fx: 2.0 },
            double_max_health: { active: true, is_continuous: false, power_fx: 2.0 }
        }
    );
    
    // 19. Tambor Hexadecimal
    add_item(
        "Tambor Hexadecimal", 
        "A cada sexto tiro, 100% de chance de crítico.",
        spr_dokrl, 
        800,
        "TITAN",
        {
            // Contínuo porque depende da contagem de tiros
            guaranteed_crit_cycle: { active: true, is_continuous: true, power_fx: 1.0, shot_count: 6 }
        }
    );
    
    // 20. Vaga Lembrança
    add_item(
        "Vaga Lembrança", 
        "A sobrevivência de Deuses do passado lhe deram a força de mil homens, dano dobrado.",
        spr_dokrl, 
        800,
        "TITAN",
        {
            double_damage: { active: true, is_continuous: false, power_fx: 2.0 }
        }
    );
}

initialize_item_database()
