

// Anima o portrait
var _state = typist.get_state()
portrait_animate(_state);


// Controla o skip
if (auto_advance) {
	dialog_advance();
} else {
	
	if (_state < 1) {	
		if (skip_input) {
			typist.skip()
		}
	} else if (_state == 1) {
		dialog_advance()
	}
}


// Limpa o input após a execucao
skip_input = skip_auto;