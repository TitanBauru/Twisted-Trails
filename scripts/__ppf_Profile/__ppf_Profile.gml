
/// Feather ignore all

/// @desc The profile is like a container, which contains the effects you want the system to render. They alone don't do anything, it's just a data structure.
/// You can create multiple profiles with different effects and then load them in real time.
///
/// The order you add the effects to the array doesn't matter. They already have their own order.
///
/// To load this profile to the Post-processing renderer, use system_id.ProfileLoad(profile_id).
/// @param {String} name Profile name. It only serves as a cosmetic and nothing else.
/// @param {Array} effectsArray Array with all effects structs. Each effect can be obtained from "new FX_*" constructors.
/// @returns {Struct} Profile struct.
function PPFX_Profile(_name, _effectsArray) constructor {
	__ppf_trace($"Profile created", 3);
	__ppf_exception(!is_string(_name), "Invalid profile name.");
	__ppf_exception(!is_array(_effectsArray), "Parameter is not an array containing effects.");
	
	__profileName = _name;
	__effectsArray = _effectsArray;
	//__id = sha1_string_utf8(string(self) + string(random(10000))); // unused
	
	#region Public Methods
	/// @method GetName()
	/// @desc Get the name of the profile.
	/// @returns {String} Profile name.
	static GetName = function() {
		return __profileName;
	}
	
	/// @method SetName(name)
	/// @desc Set the name of the profile.
	/// @param {String} name New profile name.
	/// @returns {Undefined}
	static SetName = function(_name) {
		__ppf_exception(!is_string(_name), "Invalid profile name.");
		__profileName = _name;
	}
	
	/// @method Stringify(roundNumbers, enabledOnly, renderer)
	/// @desc This function parses and exports the profile in GML, for easy use.
	/// @param {Bool} roundNumbers Sets whether to round numbers (removing decimals).
	/// @param {Bool} enabledOnly Defines if will export only enabled effects.
	/// @param {Struct} renderer Include PPFX_Renderer() id to export effects from the system/renderer, instead of profile.
	/// @returns {string} Description
	static Stringify = function(_roundNumbers=false, _enabledOnly=false, _renderer=undefined) {
		var _source = self;
		if (_renderer != undefined && __ppf_renderer_exists(_renderer)) {
			_source = _renderer;
		}
		
		__ppf_trace($"Parsing \"{__profileName}\" Profile. WARNING: The returned string will contain undefined textures.", 2);
		
		// methods
		static __parseEffect = function(_effectStruct=undefined, _constructorMame="", _parametersArray=undefined, _roundNumber=false, _delimiter=", ") {
			if (_parametersArray == undefined) exit;
			var _effectString = $"\tnew {_constructorMame}(";
			var _variableValue = undefined,
				_variableType = undefined,
				_parametersLength = array_length(_parametersArray);
			
			// fill parameters
			for (var k = 0; k < _parametersLength; ++k) {
				_variableValue = _parametersArray[k];
				_variableType = typeof(_variableValue);
				
				// concat parameter
				// write string based on type
				switch(_variableType) {
					case "bool":
						_effectString += _variableValue ? "true" : "false";
						break;
					
					case "number":
						var _value = _variableValue;
						if (_variableValue < 0.0001) _value = "0"; else
						if (_roundNumber && _variableValue > 1) _value = string(round(_variableValue)); // round number (if needed)
						_effectString += string(_value);
						break;
					
					case "ptr":
						_effectString += "undefined";
						break;
					
					case "array":
						var _type = _variableValue[0];
						var _value = _variableValue[1];
						switch(_type) {
							// vec2
						    case "vec2":
								_effectString += $"[{string(_value[0])}, {string(_value[1])}]";
								break;
							// vec3
						    case "vec3":
								_effectString += $"[{string(_value[0])}, {string(_value[1])}, {string(_value[2])}]";
								break;
							// color
							case "color":
								var _color = make_color_rgb(_value[0]*255, _value[1]*255, _value[2]*255);
								if (_color == c_black) _effectString += "c_black"; else
								if (_color == c_white) _effectString += "c_white"; else
								if (_color == c_red) _effectString += "c_red"; else
								if (_color == c_green) _effectString += "c_green"; else
								if (_color == c_blue) _effectString += "c_blue"; else
								if (_color == c_orange) _effectString += "c_orange"; else
								if (_color == c_yellow) _effectString += "c_yellow"; else
								if (_color == c_aqua) _effectString += "c_aqua"; else
								if (_color == c_lime) _effectString += "c_lime"; else
								if (_color == c_purple) _effectString += "c_purple"; else
								if (_color == c_fuchsia) _effectString += "c_fuchsia"; else
								_effectString += $"make_color_rgb({string(round(_value[0]*255))}, {string(round(_value[1]*255))}, {string(round(_value[2]*255))})";
								break;
							// texture
							case "texture":
								_effectString += "undefined";
								break;
						}
						break;
					
					default:
						_effectString += string(_variableValue);
						break;
				}
				
				// add _delimiter (comma)
				if (k != _parametersLength-1) _effectString += _delimiter;
			}
			
			// close parentheses
			_effectString += ")";
			
			// order
			if (_effectStruct != undefined) {
				if (_effectStruct.orderWasChanged) {
					_effectString += $".SetOrder({_effectStruct.stackOrder})";
				}
			}
			
			// last comma
			return _effectString + ",\n";
		}
		
		// init
		var _finalString = $"profile = new PPFX_Profile(\"{__profileName}\", [\n";
		try {
			// loop effects
			var _array = _source.__effectsOrdered;
			var _length = array_length(_array);
			for (var i = 0; i < _length; ++i) {
				var _effectStruct = _array[i];
				if (_effectStruct.enabled || !_enabledOnly) {
					if (_effectStruct.ExportData != undefined) {
						var _data = _effectStruct.ExportData();
						_finalString += __parseEffect(_effectStruct, _data.name, _data.params, _roundNumbers);
					}
				}
			}
			// close bracket
			_finalString += "]);"
		}
		catch(error) {
			__ppf_trace($"Error parsing \"{__profileName}\" profile.\n> " + error.longMessage, 1);
			return undefined;
		}
		return _finalString;
	}
	
	/// @ignore
	/// @desc Reset profile (remove all effects from it).
	static Reset = function() {
		array_resize(__effectsArray, 0);
	}
	
	/// @ignore
	/// @desc Clone effects (including their settings) from a profile to this profile. This function will replace the existing effects.
	static Clone = function(_profile) {
		if (_profile == undefined) {
			__ppf_trace("Profile is undefined, can't clone", 1);
			return;
		}
		// get the effects array of the other profile
		array_resize(__effectsArray, 0);
		__effectsArray = variable_clone(_profile.__effectsArray);
	}
	
	#endregion
}
