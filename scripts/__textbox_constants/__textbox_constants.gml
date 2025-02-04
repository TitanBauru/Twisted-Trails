

enum Dialog {
	Text,		// Texto a ser exibido
	Actor,		// Ator usado no diálogo
	
	PortName,	// Sobrescreve o nome do portrait
	PortSprite,	// Sobrescreve a sprite do portrait. Uso: [Dialog.Callback, <sprite_id>, <image_index>]
	PortFrame,	// Sobrescreve o frame do portrait
	PortAnim,	// Define um sprite com animacao pra ser o portrait
	PortClear,	// Seta o protrait com os valores padroes
	
	Background,	// Sobrescreve o background da textbox
	Callback,	// Chama uma funcao. Uso: [Dialog.Callback, <funcion_id>, [argument0, argument1, ...]]
	Voice,		// Muda o som a ser tocado no diálogo
	VoicePitch,	// Muda o pitch da voz do diálogo
}

enum TextBoxEase {
	Linear,
	Ease,
	Cubic,
	Quart,
	Expo,
	Circ,
	Back,
	Elastic,
	Bounce,
}
