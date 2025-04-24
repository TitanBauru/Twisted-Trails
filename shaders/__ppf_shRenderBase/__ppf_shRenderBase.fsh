
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

precision highp float;

varying vec2 v_vPosition;
varying vec2 v_vTexcoord;

uniform vec2 u_resolution;
uniform float u_time;

// Dependencies
#region Common

float Saturate(float x) {
	return clamp(x, 0.0, 1.0);
}

vec2 Saturate(vec2 x) {
	return clamp(x, 0.0, 1.0);
}

vec3 Saturate(vec3 x) {
	return clamp(x, 0.0, 1.0);
}

float random(vec2 uv, float t) {
	highp float d = 437.0 + mod(t, 10.0);
	highp vec2 p = uv;
	return fract(sin(cos(1.0-sin(p.x) * 1.0-cos(p.y)) * d) * d);
}

float noise(in vec2 p) {
	highp vec2 i = floor(p);
	highp vec2 f = fract(p);
	vec2 u = f * f * (3.0-2.0*f);
	return mix(mix(random(i + vec2(0.0, 0.0), 0.0),
	random(i + vec2(1.0, 0.0), 0.0), u.x),
	mix(random(i + vec2(0.0, 1.0), 0.0),
	random(i + vec2(1.0, 1.0), 0.0), u.x), u.y);
}

float peak(float x, float xpos, float scale) {
	// Thanks to: "BitOfGold"
	return clamp((1.0 - x) * scale * log(1.0 / abs(x - xpos)), 0.0, 1.0);
}

vec2 TilingMirror(vec2 uv, vec2 tiling) {
	uv = (uv - 0.5) * tiling + 0.5;
	uv = abs(mod(uv - 1.0, 2.0) - 1.0);
	return uv;
}

vec2 GetAspectRatio(vec2 uv, vec2 res) {
	float aspectRatio = res.x / res.y;
	return (res.x > res.y)
	? vec2(uv.x * aspectRatio, uv.y)
	: vec2(uv.x, uv.y / aspectRatio);
}

#endregion

#region Effects

uniform float u_rotationEnable;
uniform float u_rotationAngle;

vec2 ApplyRotationUV(vec2 uv) {
	float angle = radians(u_rotationAngle);
	mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
	vec2 rs = u_resolution.xy / vec2(2.0);
	vec2 uv2 = v_vPosition - rs;
	uv = (rot * uv2 + rs) / u_resolution.xy;
	return uv;
}

uniform float u_zoomEnable;
uniform float u_zoomAmount;
uniform float u_zoomRange;
uniform vec2 u_zoomCenter;

vec2 ApplyZoomUV(vec2 uv) {
	float zoom = 1.0 + (u_zoomAmount - 2.0);
	uv += (u_zoomCenter - uv) * (zoom / max(1.0, u_zoomRange));
	return uv;
}

uniform float u_shakeEnable;
uniform float u_shakeSpeed;
uniform float u_shakeMagnitude;
uniform float u_shakeHspeed;
uniform float u_shakeVspeed;

vec2 ApplyShakeUV(vec2 uv) {
	highp float t = 100.0 + u_time * u_shakeSpeed;
	vec2 offset;
	offset.x = u_shakeHspeed * cos(t*135.0 + sin(t)) * u_shakeMagnitude;
	offset.y = u_shakeVspeed * sin(t*90.0 + cos(t)) * u_shakeMagnitude;
	return uv + offset;
}

uniform float u_panoramaEnable;
uniform float u_panoramaDepthX;
uniform float u_panoramaDepthY;

vec2 ApplyPanoramaUV(vec2 uv) {
	vec2 dist = vec2(length(uv.x - 0.5), length(uv.y - 0.5));
	float offset = dist.x * dist.y;
	vec2 dir = vec2(1.0) - 2.0 * step(0.5, uv);
	uv = vec2(
		uv.x + dist.y * (offset * dir.x * u_panoramaDepthX),
		uv.y + dist.x * (offset * dir.y * u_panoramaDepthY)
	);
	return uv;
}

uniform float u_lensDistortionEnable;
uniform float u_lensDistortionAmount;

vec2 ApplyLensDistortionUV(vec2 uv, float intensity) {
	vec2 uvCenter = vec2(0.5);
	vec2 dir = (uv - uvCenter);
	float polar = atan(dir.y, dir.x);
	float radius = length(dir);
	radius *= (1.0 + pow(radius, 2.0) * u_lensDistortionAmount * intensity);
	uv = uvCenter + radius * vec2(cos(polar), sin(polar));
	return uv;
}

uniform float u_pixelizeEnable;
uniform float u_pixelizeAmount;
uniform float u_pixelizePixelMaxSize;
uniform float u_pixelizeSteps;

vec2 ApplyPixelizeUV(vec2 uv) {
	float amount = u_pixelizeAmount;
	if (u_pixelizeSteps > 0.0) amount = ceil(amount*u_pixelizeSteps)/u_pixelizeSteps;
	vec2 gridSize = vec2(u_pixelizePixelMaxSize) * amount;
	if (amount > 0.0) uv = floor(uv * u_resolution / gridSize + 0.5) * gridSize / u_resolution;
	return uv;
}

uniform float u_swirlEnable;
uniform float u_swirlAngle;
uniform float u_swirlRadius;
uniform float u_swirlRounded;
uniform vec2 u_swirlCenter;

vec2 ApplySwirlUV(vec2 uv) {
	uv -= u_swirlCenter;
	float angle = radians(u_swirlAngle) * smoothstep(0.0, u_swirlRadius, u_swirlRadius-length((u_swirlRounded > 0.5) ? GetAspectRatio(uv, u_resolution) : uv));
	mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
	uv *= rot;
	uv += u_swirlCenter;
	return uv;
}

uniform float u_shockwavesEnable;
uniform float u_shockwavesAmount;
uniform float u_shockwavesAberration;
uniform vec4 u_shockwavesUVs;
uniform vec4 u_shockwavesPrismaLutUVs;
uniform sampler2D u_shockwavesTexture;
uniform sampler2D u_shockwavesPrismaLutTexture;

vec2 ApplyShockwavesUV(vec2 uv, out vec2 offsetOut) {
	vec2 offset = (texture2D(u_shockwavesTexture, mix(u_shockwavesUVs.xy, u_shockwavesUVs.zw, uv)).rg * 2.0 - 1.0) * u_shockwavesAmount;
	offsetOut = offset;
	return uv + offset;
}

vec4 ApplyShockwaves(vec4 color, vec2 uv, in vec2 offsetIn) {
	vec4 colPrismaA = texture2D(u_shockwavesPrismaLutTexture, mix(u_shockwavesPrismaLutUVs.xy, u_shockwavesPrismaLutUVs.zw, vec2(0.5/3.0, 0.0)));
	vec4 colPrismaB = texture2D(u_shockwavesPrismaLutTexture, mix(u_shockwavesPrismaLutUVs.xy, u_shockwavesPrismaLutUVs.zw, vec2(1.5/3.0, 0.0)));
	vec4 colPrismaC = texture2D(u_shockwavesPrismaLutTexture, mix(u_shockwavesPrismaLutUVs.xy, u_shockwavesPrismaLutUVs.zw, vec2(2.5/3.0, 0.0)));
	vec2 dist = vec2(offsetIn * u_shockwavesAberration);
	vec4 colChromaA = texture2D(gm_BaseTexture, uv + dist);
	vec4 colChromaB = texture2D(gm_BaseTexture, uv);
	vec4 colChromaC = texture2D(gm_BaseTexture, uv - dist);
	vec4 col = colChromaA*colPrismaA + colChromaB*colPrismaB + colChromaC*colPrismaC;
	color = col / (colPrismaA + colPrismaB + colPrismaC);
	return color;
}

uniform float u_displacemapEnable;
uniform float u_displacemapAmount;
uniform float u_displacemapScale;
uniform float u_displacemapAngle;
uniform float u_displacemapSpeed;
uniform vec4 u_displacemapUVs;
uniform sampler2D u_displacemapTexture;
uniform vec2 u_displacemapOffset;

vec2 ApplyDisplaceMapsUV(vec2 uv) {
	highp vec2 uv2 = (v_vPosition+u_displacemapOffset) / u_resolution;
	mat2 rot = mat2(cos(u_displacemapAngle), -sin(u_displacemapAngle), sin(u_displacemapAngle), cos(u_displacemapAngle));
	uv2 = rot * (uv2 - 0.5) + 0.5;
	uv2.x -= u_time * u_displacemapSpeed;
	uv2 = TilingMirror(uv2, vec2(u_displacemapScale));
	return uv + (texture2D(u_displacemapTexture, mix(u_displacemapUVs.xy, u_displacemapUVs.zw, uv2)).rg * 2.0 - 1.0) * u_displacemapAmount;
}

uniform float u_sinewaveEnable;
uniform vec2 u_sinewaveFrequency;
uniform vec2 u_sinewaveAmplitude;
uniform float u_sinewaveSpeed;
uniform vec2 u_sinewaveOffset;

vec2 ApplySineWaveUV(vec2 uv) {
	vec2 uv2 = (v_vPosition+u_sinewaveOffset) / u_resolution;
	float spd = u_time * u_sinewaveSpeed;
	vec2 offset;
	offset.x = cos(uv2.y*u_sinewaveFrequency.x - spd) * u_sinewaveAmplitude.x;
	offset.y = sin(uv2.x*u_sinewaveFrequency.y - spd) * u_sinewaveAmplitude.y;
	return uv + offset;
}

uniform float u_interferenceEnable;
uniform float u_interferenceSpeed;
uniform float u_interferenceBlockSize;
uniform float u_interferenceInterval;
uniform float u_interferenceIntensity;
uniform float u_interferencePeakAmplitude1;
uniform float u_interferencePeakAmplitude2;

vec2 ApplyInterferenceUV(vec2 uv) {
	highp float time = u_time * u_interferenceSpeed;
	highp float interference = random(vec2(0.0, ceil(uv.y * (u_resolution.y * (1.0-u_interferenceBlockSize)))), time);
	highp float vscan = interference;
	interference *= (interference > u_interferenceInterval) ? u_interferencePeakAmplitude1 : u_interferencePeakAmplitude2;
	float ds = 0.05 * u_interferenceIntensity * interference * peak(uv.y, vscan, vscan);
	uv.x -= ds;
	//uv.y += ds;
	return uv;
}
#endregion

void main() {
	// # base
	vec2 uv = v_vTexcoord;
	
	#region Apply Effects
	// rotation
	if (u_rotationEnable > 0.5) uv = ApplyRotationUV(uv);
	
	// shake
	if (u_shakeEnable > 0.5) uv = ApplyShakeUV(uv);
	
	// lens distortion
	if (u_lensDistortionEnable > 0.5) uv = ApplyLensDistortionUV(uv, 1.0);
	
	// zoom
	if (u_zoomEnable > 0.5) uv = ApplyZoomUV(uv);
	
	// pixelize (effects below will respect pixelize pixel size)
	if (u_pixelizeEnable > 0.5) uv = ApplyPixelizeUV(uv);
	
	// swirl
	if (u_swirlEnable > 0.5) uv = ApplySwirlUV(uv);
	
	// panorama
	if (u_panoramaEnable > 0.5) uv = ApplyPanoramaUV(uv);
	
	// sine wave
	if (u_sinewaveEnable > 0.5) uv = ApplySineWaveUV(uv);
	
	// interference
	if (u_interferenceEnable > 0.5) uv = ApplyInterferenceUV(uv);
	
	// shockwaves
	vec2 _swOffset = vec2(0.0);
	if (u_shockwavesEnable > 0.5) uv = ApplyShockwavesUV(uv, _swOffset);
	
	// displacement map
	if (u_displacemapEnable > 0.5) uv = ApplyDisplaceMapsUV(uv);
	
	// image
	vec4 mainTex = texture2D(gm_BaseTexture, uv);
	
	// shockwaves
	if (u_shockwavesEnable > 0.5) mainTex = ApplyShockwaves(mainTex, uv, _swOffset);
	#endregion
	
	gl_FragColor = mainTex;
}
