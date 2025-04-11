
// Feather ignore all

/// @desc A material refers to the properties of an object's surface.
/// Note that this is optional, you will only need materials if you want to achieve the following effects: Normal Map, Emissive, Unlit, Metallic, Roughness, Ambient Occlusion, Reflections and Light Mask.
/// 
/// Call .Apply() and this material will be added to the last renderer, unless you use crystal_set_renderer() to override.
/// This will add realism to the images if PBR is enabled.
/// @param {Id.Instance,Struct} owner The instance to get initial properties. Use noone if you want multiple materials (not ideal, because you should use a single material per instance).
/// @param {Bool} isBitmap true means bitmap sprites (default). Set to false if using skeleton sprites from Spine.
function Crystal_Material(_owner, _isBitmap=true) constructor {
	static defaultOwner = {depth : 0, x : 0, y : 0, image_angle : 0, image_xscale : 1, image_yscale : 1};
	// base
	__cull = false;
	__destroyed = false;
	__applied = false;
	__owner = defaultOwner;
	if (instance_exists(_owner)) {
		__owner = _owner;
	}
	// properties
	isBitmap = _isBitmap;
	enabled = true;
	self.depth = __owner.depth;
	self.x = __owner.x;
	self.y = __owner.y;
	angle = __owner.image_angle;
	xScale = __owner.image_xscale;
	yScale = __owner.image_yscale;
	normalSprite = undefined;
	normalSpriteSubimg = 0;
	normalIntensity = 1;
	metallicSprite = undefined;
	metallicSpriteSubimg = 0;
	metallicIntensity = 1;
	roughnessSprite = undefined;
	roughnessSpriteSubimg = 0;
	roughnessIntensity = 1;
	aoSprite = undefined;
	aoSpriteSubimg = 0;
	aoIntensity = 1;
	emissiveSprite = undefined;
	emissiveSpriteSubimg = 0;
	emissiveIntensity = 1;
	emissionColor = c_white;
	emission = 1;
	reflectionSprite = undefined;
	reflectionSpriteSubimg = 0;
	reflectionColor = c_white;
	reflectionXscale = 1;
	reflectionYscale = 1;
	reflectionIntensity = 1;
	maskSprite = undefined;
	maskSpriteSubimg = 0;
	maskIntensity = 1;
	// Spine skeleton related (if in use)
	animName = "";
	skinName = "default";
	animTime = 0;
	
	#region Public Methods
	
	/// @desc Destroys the material from the Crystal_Renderer(). You should call this when the instance is destroyed, for example. Useful for the Clean-Up Event.
	/// You can call .Apply() again after calling this function, and the material will be sent to the renderer again.
	/// @method Destroy()
	static Destroy = function() {
		__destroyed = true;
		__applied = false;
		return self;
	}
	
	/// @desc Call this after setting up the material and it will be sent to Crystal_Renderer().
	/// @param {Struct.Crystal_Renderer} renderer The renderer to add the material for rendering. If not specified, adds to the last created renderer (or set with crystal_set_renderer()).
	/// @method Apply(renderer)
	static Apply = function(_renderer=global.__CrystalCurrentRenderer) {
		// if already applied, do nothing.
		if (__applied) {
			__crystal_trace("Material not applied, material already rendering!", 1);
			return;
		}
		// check if renderer exists
		if (_renderer == undefined) {
			__crystal_trace("Material not applied, renderer not found. (creation order?)", 1);
			return;
		}
		// add to renderer (once)
		_renderer.__addMaterial(self);
		__applied = true;
		__destroyed = false;
		return self;
	}
	
	/// @desc Sets Material sprites based on the referenced sprite's name. The following prefixes will be taken into account: "normal", "emissive", "metallic", "roughness", "ao", "reflection", "mask" (to-do).
	/// @param {Asset.GMSprite,undefined} sprite The sprite to get materials from. Example: sprite_index. Use undefined to use the sprite_index from "owner".
	static FromSprite = function(_sprite=undefined) {
		if (_sprite == undefined) _sprite = __owner.sprite_index;
		var _name = sprite_get_name(_sprite);
		var _spr = -1;
		_spr = asset_get_index(_name + CLE_CFG_MAT_SUFFIX_NORMAL);
		if (sprite_exists(_spr)) normalSprite = _spr;
		_spr = asset_get_index(_name + CLE_CFG_MAT_SUFFIX_EMISSIVE);
		if (sprite_exists(_spr)) emissiveSprite = _spr;
		_spr = asset_get_index(_name + CLE_CFG_MAT_SUFFIX_METALLIC);
		if (sprite_exists(_spr)) metallicSprite = _spr;
		_spr = asset_get_index(_name + CLE_CFG_MAT_SUFFIX_ROUGHNESS);
		if (sprite_exists(_spr)) roughnessSprite = _spr;
		_spr = asset_get_index(_name + CLE_CFG_MAT_SUFFIX_AO);
		if (sprite_exists(_spr)) aoSprite = _spr;
		_spr = asset_get_index(_name + CLE_CFG_MAT_SUFFIX_MASK);
		if (sprite_exists(_spr)) maskSprite = _spr;
		_spr = asset_get_index(_name + CLE_CFG_MAT_SUFFIX_REFLECTION);
		if (sprite_exists(_spr)) reflectionSprite = _spr;
		return self;
	}
	
	/// @desc Sets Material sprites based on the referenced sprite's frames. This function takes into account frame 0 being the albedo (default). Use 1 in each parameter to tell whether the sprite frame in question exists in the sprite. The frame is incremented sequentially.
	/// The order of sprite frames is the order of parameters.
	/// @method FromSpriteFrames(sprite, normal, emissive, metallic, roughness, ao, mask, reflection)
	/// @param {Asset.GMSprite,undefined} sprite The sprite to get materials from. Example: sprite_index. Use undefined to use the sprite_index from "owner".
	/// @param {Real} normal Use 1 if the sprite contains this.
	/// @param {Real} emissive Use 1 if the sprite contains this.
	/// @param {Real} metallic Use 1 if the sprite contains this.
	/// @param {Real} roughness Use 1 if the sprite contains this.
	/// @param {Real} ao Use 1 if the sprite contains this.
	/// @param {Real} mask Use 1 if the sprite contains this.
	/// @param {Real} reflection Use 1 if the sprite contains this.
	static FromSpriteFrames = function(_sprite=undefined, _normal=-1, _emissive=-1, _metallic=-1, _roughness=-1, _ao=-1, _mask=-1, _reflection=-1) {
		if (_sprite == undefined) _sprite = __owner.sprite_index;
		var _index = 0; // albedo
		if (_normal > 0) {normalSprite = _sprite; normalSpriteSubimg = ++_index;}
		if (_emissive > 0) {emissiveSprite = _sprite; emissiveSpriteSubimg = ++_index;}
		if (_metallic > 0) {metallicSprite = _sprite; metallicSpriteSubimg = ++_index;}
		if (_roughness > 0) {roughnessSprite = _sprite; roughnessSpriteSubimg = ++_index;}
		if (_ao > 0) {aoSprite = _sprite; aoSpriteSubimg = ++_index;}
		if (_mask > 0) {maskSprite = _sprite; maskSpriteSubimg = ++_index;}
		if (_reflection > 0) {reflectionSprite = _sprite; reflectionSpriteSubimg = ++_index;}
		return self;
	}
	
	/// @desc This function synchronizes "transforms" (position, rotation, scale), alpha/intensity and "depth" variables to the "owner" instance (if defined) - built-in variables.
	/// 
	/// This should be called every frame.
	/// @method SyncToOwner()
	static SyncToOwner = function() {
		if (__owner == noone) return;
		self.depth = __owner.depth;
		self.x = __owner.x;
		self.y = __owner.y;
		angle = __owner.image_angle;
		xScale = __owner.image_xscale;
		yScale = __owner.image_yscale;
		normalIntensity = __owner.image_alpha;
		emissiveIntensity = __owner.image_alpha;
		metallicIntensity = __owner.image_alpha;
		roughnessIntensity = __owner.image_alpha;
		aoIntensity = __owner.image_alpha;
		reflectionIntensity = __owner.image_alpha;
		maskIntensity = __owner.image_alpha;
	}
	
	/// @desc With this function, it is possible to synchronize the frame of all material sprites (bitmap only) with the specified value. Useful for animated PBR objects.
	/// 
	/// Note that you assume that the frame sequence of the associated sprites is synchronized to the same frame index.
	/// 
	/// This should be called every frame.
	/// @method SyncFrame(frame)
	/// @param {Real} frame The image index/frame to sync. Example: image_index.
	static SyncFrame = function(_frame) {
		normalSpriteSubimg = _frame;
		metallicSpriteSubimg = _frame;
		roughnessSpriteSubimg = _frame;
		aoSpriteSubimg = _frame;
		emissiveSpriteSubimg = _frame;
		reflectionSpriteSubimg = _frame;
		maskSpriteSubimg = _frame;
	}
	
	/// @desc This function will synchronize the drawing of the Spine skeleton animation with the animation of the current context instance. Only useful for Spine skeleton sprites. You can also use "animName" and "skinName" variables for this.
	/// 
	/// This should be called every frame.
	/// @method SyncAnimation(animation, skin)
	/// @param {String} animation The Spine sprite animation name.
	/// @param {String} skin The Spine sprite skin name.
	static SyncAnimation = function(_animation, _skin) {
		animName = _animation;
		skinName = _skin;
	}
	
	/// @desc This function synchronizes the Spine skeleton animation frame with the current context instance. If you want to have control over the normalized position (0-1) of the animation, use "animTime" variable directly from the material.
	/// 
	/// This should be called every frame.
	/// @method SyncAnimationTime(position, duration)
	/// @param {Real} position The animation position. You can use skeleton_animation_get_position(0).
	/// @param {Real} duration The animation duration. You can use skeleton_animation_get_duration();
	static SyncAnimationTime = function(_position, _duration) {
		animTime = _position * _duration;
	}
	
	/// @desc Returns a boolean indicating whether the material is already applied (.Apply() was called).
	/// @method IsApplied()
	static IsApplied = function() {
		return __applied;
	}
	
	#endregion
}
