///@ignore
/*
+========================================================
||
||	Script de configuracao.
||	
||	Configuracoes da textbox, alterando tamanho, posicao,
||	sons, sprites etc.
||	
+========================================================
*/


global.config = {
		
	// TODO: adicionar descricao dos parametros
		
	dialog_speed		: 0.5,					// Velocidade com que o texto é exibido
	dialog_smooth		: 8,					// Quantidade de caracteres exibidos por vez
	dialog_prefix		: "[wave]",				// Prefixo de efeito que afeta todo o texto
	dialog_pitchvar		: 0.1,					// Variacao no pitch da voz do diálogo
			
		
	textbox_color		: c_white,				// Cor da caixa de texto
	textbox_alpha		: 1.0,					// Alfa da caixa de texto
	textbox_x_fac		: 0.5,					// Porcentagem da posicao X da caixa
	textbox_y_fac		: 0.8,					// Porcentagem da posicao Y da caixa
	textbox_wid_fac		: 0.8,					// Porcentagem da largula da caixa
	textbox_hei_fac		: 0.25,					// Porcentagem da altura da caixa
	textbox_bg_scale	: 2,					// Escala da caixa
	textbox_text_scale	: 0.5,					// Escala do texto (ajustar pelo tamanho da fonte)
	textbox_line_height	: 8,					// Altura da linha (ajustar pelo tamanho da fonte)
	textbox_hpad		: 8,					// Espaco entre as laterais da caixa e o texto
	textbox_vpad		: 2,					// Espaco entre o topo da caixa e o texto
	textbox_ease_mode	: TextBoxEase.Expo,		// Tipo de animacao da caixa de texto
	textbox_sprite		: spr_textbox,			// Sprite padrao da caixa
	textbox_frame		: 0,					// Frame padrao da caixa
		

	portrait_pad_x		: 2,					// Offset do portrait no eixo X
	portrait_pad_y		: 0,					// Offset do portrait no eixo Y
	portrait_xscal		: 1,					// Escala do portrait no eixo X
	portrait_yscal		: 1,					// Escala do portrait no eixo Y
	portrait_name_pad_x	: 8,					// Offset do nome no eixo X
	portrait_name_pad_y	: 0,					// Offset do nome no eixo Y
	portrait_name_scale	: 0.5,					// Escala do nome
	portrait_size		: 32,					// Tamamho do portrait em pixels
	portrait_color		: c_white,				// Cor do portrait
	portrait_alpha		: 1.0,					// Alpha do portrait
	portrait_prefix		: "[wave]",				// Prefixo de efeito que afeta todo o nome
	portrait_skewer		: 0.2,					// Efeito de scale quando o diálogo muda
		
		
	skip_delay			: 30,					// Delay em frames pra aparecer o icone de skip
	skip_text			: "[wave]...",			// Prefixo de efeito que afeta o skip
		
		
	anim_delay			: 30,					// Duracao em frames da animacao da caixa
	anim_overlap		: 0.1,					// Fator onde o texto pode aparecer antes da animacao terminar
		
}
return global.config;
