
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

#region Common

const float Tau = 6.28318;

const vec3 lum_weights = vec3(0.2126729, 0.7151522, 0.0721750);
float GetLuminance(vec3 color) {
	return dot(color, lum_weights);
}

float rand(vec2 p, sampler2D tex) {
	return texture2D(tex, p).r;
}

// (C) 2016, Ashima Arts
/*vec3 mod2D289(vec3 x) {return x - floor( x * (1.0 / 289.0)) * 289.0;}
vec2 mod2D289(vec2 x) {return x - floor( x * (1.0 / 289.0)) * 289.0;}
vec3 permute(vec3 x) {return mod2D289(((x * 34.0) + 1.0) * x);}
float snoise(vec2 v) {
	const highp vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
	vec2 i = floor(v + dot(v, C.yy));
	vec2 x0 = v - i + dot(i, C.xx);
	vec2 i1;
	i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	vec4 x12 = x0.xyxy + C.xxzz;
	x12.xy -= i1;
	i = mod2D289(i);
	vec3 p = permute(permute(i.y + vec3( 0.0, i1.y, 1.0 )) + i.x + vec3(0.0, i1.x, 1.0));
	vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
	m = m * m;
	m = m * m;
	vec3 x = 2.0 * fract(p * C.www) - 1.0;
	vec3 h = abs(x) - 0.5;
	vec3 ox = floor(x + 0.5);
	vec3 a0 = x - ox;
	m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
	vec3 g;
	g.x = a0.x * x0.x + h.x * x0.y;
	g.yz = a0.yz * x12.xz + h.yz * x12.yw;
	return 130.0 * dot(m, g);
}*/

vec2 GetAspectRatio(vec2 res, vec2 size) {
	float aspect_ratio = res.x / res.y;
	return (res.x > res.y)
	? vec2(size.x * aspect_ratio, size.y)
	: vec2(size.x, size.y / aspect_ratio);
}

vec2 Tiling(vec2 uv, vec2 amount) {
	uv = (uv - 0.5) * amount + 0.5;
	return mod(uv, 1.0);
}

vec2 TilingMirror(vec2 uv, vec2 amount) {
	uv = (uv - 0.5) * amount + 0.5;
	uv = abs(mod(uv - 1.0, 2.0) - 1.0);
	return uv;
}

float linearstep(float a, float b, float c) {
	return (c - a) / (b - a);
}

float Saturate(float x) {
	return clamp(x, 0.0, 1.0);
}

vec3 Saturate(vec3 x) {
	return clamp(x, 0.0, 1.0);
}

vec3 Blend(vec3 source, vec3 dest) {
	return source + dest - source * dest;
}

vec3 Blend(vec3 source, vec4 dest) {
	return dest.rgb * dest.a + source * (1.0-dest.a);
}

vec4 Blend(vec4 source, vec4 dest) {
	return dest * dest.a + source * (1.0-dest.a);
}

float MaskRadial(vec2 uv, vec2 center, float power, float scale, float smoothness) {
	float smoothh = mix(scale, 0.0, smoothness);
	float sc = scale / 2.0;
	float mask = pow(1.0-Saturate((length(uv-center)-sc) / ((smoothh-0.001)-sc)), power);
	return mask;
}
#endregion

#region Effects
uniform float u_mistEnable;
uniform float u_mistIntensity;
uniform float u_mistScale;
uniform float u_mistTiling;
uniform float u_mistSpeed;
uniform float u_mistAngle;
uniform float u_mistContrast;
uniform float u_mistPower;
uniform float u_mistRemap;
uniform vec3 u_mistColor;
uniform float u_mistMix;
uniform float u_mistMixThreshold;
uniform vec2 u_mistOffset;
uniform float u_mistFadeAmount;
uniform float u_mistFadeAngle;
uniform sampler2D u_mistNoiseTexture;
uniform vec4 u_mistNoiseTextureUVs;
const float mistFadeSmoothness = 0.8;

vec4 ApplyMist(vec4 color, vec2 uv) {
	//vec2 uvO = (v_vPosition-u_mistOffset) / u_resolution.xy;
	vec2 uvO = uv + (u_mistOffset / u_resolution.xy);
	
	vec2 uvNoise = uvO;
	uvNoise = mat2(cos(u_mistAngle), -sin(u_mistAngle), sin(u_mistAngle), cos(u_mistAngle)) * (uvNoise - 0.5) + 0.5;
	uvNoise.x -= u_time * u_mistSpeed;
	uvNoise = Tiling(uvNoise, vec2(u_mistTiling*u_mistScale, u_mistTiling));
	
	uvNoise = mix(u_mistNoiseTextureUVs.xy, u_mistNoiseTextureUVs.zw, uvNoise);
	float noise = texture2D(u_mistNoiseTexture, uvNoise).r * u_mistContrast + 0.5;
	float fog = Saturate(pow(noise, u_mistPower)-u_mistRemap) / (1.0-u_mistRemap);
	
	vec2 uvFade = uvO;
	uvFade = mat2(cos(u_mistFadeAngle), -sin(u_mistFadeAngle), sin(u_mistFadeAngle), cos(u_mistFadeAngle)) * (uvFade - 0.5) + 0.5;
	if (u_mistFadeAmount > 0.0) fog *= smoothstep(u_mistFadeAmount, u_mistFadeAmount-mistFadeSmoothness, uvFade.x);
	
	fog *= u_mistIntensity;
	
	vec3 luminance_level = max((color.rgb + u_mistMixThreshold) * u_mistIntensity, 0.0);
	vec3 luma = mix(vec3(1.0), luminance_level, u_mistMix);
	
	vec3 mistCol = mix(color.rgb, u_mistColor, Saturate(fog*luma));
	color.rgb = mix(color.rgb, mistCol, Saturate(fog));
	return color;
}

uniform float u_ditheringEnable;
uniform float u_ditheringMode;
uniform float u_ditheringIntensity;
uniform float u_ditheringBitLevels;
uniform float u_ditheringContrast;
uniform float u_ditheringThreshold;
uniform float u_ditheringScale;
uniform float u_ditheringBayerSize;
uniform sampler2D u_ditheringBayerTexture;
uniform vec4 u_ditheringBayerUVs;

vec3 ApplyDithering(vec3 color) {
	// bayer matrix
	vec2 uvDither = mod(v_vPosition/u_ditheringScale, u_ditheringBayerSize)/u_ditheringBayerSize;
	float matrix = texture2D(u_ditheringBayerTexture, mix(u_ditheringBayerUVs.xy, u_ditheringBayerUVs.zw, uvDither)).r;
	// luminance
	float lum = GetLuminance(color);
	lum = clamp((lum - 0.5 - abs(u_ditheringThreshold)) * max(u_ditheringContrast, 0.0) + 0.5, 0.0, 1.0);
	// different dithering modes
	vec3 dithering;
	if (u_ditheringMode == 0.0) {
		dithering = floor(color * u_ditheringBitLevels + matrix) / u_ditheringBitLevels;
	} else
	if (u_ditheringMode == 1.0) {
		vec3 colStep = floor(color * u_ditheringBitLevels) / u_ditheringBitLevels;
		dithering = mix(color, vec3(step(matrix, colStep)), clamp((color - 0.5) * u_ditheringContrast + 0.5, 0.0, 1.0));
	} else
	if (u_ditheringMode == 2.0) {
		vec3 colStep = floor(color * u_ditheringBitLevels + matrix) / u_ditheringBitLevels;
		dithering = mix(color, colStep, step(matrix, lum));
	} else
	if (u_ditheringMode == 3.0) {
		float lumStep = floor(lum * u_ditheringBitLevels) / u_ditheringBitLevels;
		dithering = mix(color, color * step(matrix, lumStep) + color, mix(0.0, 0.5, u_ditheringIntensity));
	}
	return mix(color, dithering, u_ditheringIntensity);
}

uniform float u_noiseGrainEnable;
uniform float u_noiseGrainIntensity;
uniform float u_noiseGrainLuminosity;
uniform float u_noiseGrainScale;
uniform float u_noiseGrainSpeed;
uniform float u_noiseGrainMix;
uniform vec2 u_noiseGrainSize;
uniform vec4 u_noiseGrainUVs;
uniform vec4 u_noiseGrainTextureOffsets;
uniform sampler2D u_noiseGrainTexture;

vec3 ApplyNoiseGrain(vec3 color) {
	vec2 uv = v_vPosition / u_noiseGrainSize;
	uv = Tiling(uv, vec2(u_noiseGrainScale));
	
	float g1 = texture2D(u_noiseGrainTexture, mix(u_noiseGrainUVs.xy, u_noiseGrainUVs.zw, fract(uv+u_noiseGrainTextureOffsets.xy))).r;
	float g2 = texture2D(u_noiseGrainTexture, mix(u_noiseGrainUVs.xy, u_noiseGrainUVs.zw, fract(uv+u_noiseGrainTextureOffsets.zw))).r;
	float grain = (sqrt(g1 * g2) / 0.75);
	
	float lum = 1.0 - sqrt(GetLuminance(Saturate(color)));
	lum = mix(lum, 1.0, u_noiseGrainLuminosity);
	
	color = mix(vec3(grain)*u_noiseGrainIntensity, color+color*(grain*2.0-1.0)*lum*u_noiseGrainIntensity, u_noiseGrainMix);
	return color;
}

uniform float u_speedlinesEnable;
uniform float u_speedlinesScale;
uniform float u_speedlinesTiling;
uniform float u_speedlinesSpeed;
uniform float u_speedlinesRotSpeed;
uniform float u_speedlinesContrast;
uniform float u_speedlinesPower;
uniform float u_speedlinesRemap;
uniform vec3 u_speedlinesColor;
uniform float u_speedlinesMaskPower;
uniform float u_speedlinesMaskScale;
uniform float u_speedlinesMaskSmoothness;
uniform vec4 u_speedlinesNoiseUVs;
uniform sampler2D u_speedlinesNoiseTex;

vec3 ApplySpeedlines(vec3 color, vec2 uv) {
	vec2 center = uv - 0.5;
	
	float angle = radians(u_time * u_speedlinesRotSpeed);
	center *= mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
	
	highp float time = u_time * u_speedlinesSpeed*0.1;
	vec2 uv2 = vec2((length(center) * u_speedlinesScale * 0.5) - time, atan(center.x, center.y) * (1.0/Tau) * u_speedlinesTiling);
	
	float perlinNoise = texture2D(u_speedlinesNoiseTex, mix(u_speedlinesNoiseUVs.xy, u_speedlinesNoiseUVs.zw, fract(uv2))).r * u_speedlinesContrast + 0.5;
	float fastLines = Saturate(pow(perlinNoise, u_speedlinesPower) - u_speedlinesRemap) / (1.0-u_speedlinesRemap);
	float mask = MaskRadial(uv, vec2(0.5), u_speedlinesMaskPower, u_speedlinesMaskScale, u_speedlinesMaskSmoothness);
	
	return mix(color, u_speedlinesColor, Saturate(fastLines * mask));
}

uniform float u_vignetteEnable;
uniform float u_vignetteIntensity;
uniform float u_vignetteCurvature;
uniform float u_vignetteInner;
uniform float u_vignetteOuter;
uniform vec3 u_vignetteColor;
uniform vec2 u_vignetteCenter;
uniform float u_vignetteRounded;
uniform float u_vignetteLinear;

vec3 ApplyVignette(vec3 color, vec2 uv) {
	vec2 dist = abs(uv - u_vignetteCenter) * 2.0;
	if (u_vignetteRounded > 0.5) dist *= (u_resolution / min(u_resolution.x, u_resolution.y));
	vec2 curve = pow(dist, vec2(1.0/u_vignetteCurvature));
	float edge = pow(length(curve), u_vignetteCurvature);
	float vig = (u_vignetteLinear > 0.5) ? 
		smoothstep(1.0-u_vignetteInner, 1.0, edge/u_vignetteOuter) :
		pow(edge/u_vignetteOuter, 1.0/u_vignetteInner);
	return mix(color, u_vignetteColor, Saturate(vig) * u_vignetteIntensity);
}

uniform float u_NESFadeEnable;
uniform float u_NESFadeAmount;
uniform float u_NESFadeLevels;

vec3 ApplyNESFade(vec3 color) {
	// with help of Jan Vorisek
	color = max(color-u_NESFadeAmount, 0.0);
	vec3 bias = vec3(1.0) / u_NESFadeLevels;
	color = max((floor((color + bias) * u_NESFadeLevels) / u_NESFadeLevels) - bias, 0.0);
	return color;
}

uniform float u_scanlinesEnable;
uniform float u_scanlinesIntensity;
uniform float u_scanlinesSharpness;
uniform float u_scanlinesSpeed;
uniform float u_scanlinesAmount;
uniform vec3 u_scanlinesColor;
uniform float u_scanlinesMaskPower;
uniform float u_scanlinesMaskScale;
uniform float u_scanlinesMaskSmoothness;

vec3 ApplyScanlines(vec3 color, vec2 uv) {
	highp float time = u_time * u_scanlinesSpeed;
	float mask = MaskRadial(uv, vec2(0.5), u_scanlinesMaskPower, u_scanlinesMaskScale, u_scanlinesMaskSmoothness);
	float lines = sin(time - (uv.y * 2.0*u_resolution.y * u_scanlinesAmount)) * 0.5+0.5;
	float sharp = mix(0.0, 0.5, u_scanlinesSharpness);
	lines = Saturate(linearstep(sharp, 1.0-sharp, lines));
	return mix(color, u_scanlinesColor, lines * mask * u_scanlinesIntensity);
}

uniform float u_fadeEnable;
uniform float u_fadeAmount;
uniform vec3 u_fadeColor;

vec3 ApplyFadeColor(vec3 color) {
	return mix(color, u_fadeColor, u_fadeAmount);
}

uniform float u_cinamaBarsEnable;
uniform float u_cinemaBarsAmount;
uniform float u_cinemaBarsIntensity;
uniform float u_cinemaBarsSmoothness;
uniform vec3 u_cinemaBarsColor;
uniform float u_cinemaBarsVerticalEnable;
uniform float u_cinemaBarsHorizontalEnable;
uniform float u_cinemaBarsCanDistort;

vec3 ApplyCinemaBars(vec3 color, vec2 uv, vec2 uvl) {
	vec2 uv2 = uv;
	if (u_cinemaBarsCanDistort > 0.5) uv2 = uvl;
	vec2 uvBars = abs(uv2*2.0-1.0);
	vec2 bars = smoothstep(u_cinemaBarsAmount, u_cinemaBarsAmount+u_cinemaBarsSmoothness, 1.0-uvBars);
	vec3 col = color;
	if (u_cinemaBarsVerticalEnable > 0.5) col = mix(u_cinemaBarsColor, col, bars.y);
	if (u_cinemaBarsHorizontalEnable > 0.5) col = mix(u_cinemaBarsColor, col, bars.x);
	return mix(color, col, u_cinemaBarsIntensity);
}

uniform float u_colorBlindnessEnable;
uniform float u_colorBlindnessMode;

vec3 ApplyColorBlindness(vec3 color) {
	//http://blog.noblemaster.com/2013/10/26/opengl-shader-to-correct-and-simulate-color-blindness-experimental/
	if (u_colorBlindnessMode == 0.0) { // protanopia
		color *= mat3(0.20, 0.99, -0.19,
					0.16, 0.79, 0.04,
					0.01, -0.01, 1.00);
	} else
	if (u_colorBlindnessMode == 1.0) { // deuteranopia
		color *= mat3(0.43, 0.72, -0.15,
					0.34, 0.57, 0.09,
					-0.02, 0.03, 1.00);
	} else
	if (u_colorBlindnessMode == 2.0) { // tritanopia
		color *= mat3(0.97, 0.11, -0.08,
					0.02, 0.82, 0.16,
					-0.06, 0.88, 0.18);
	}
	return color;
}

uniform float u_channelsEnable;
uniform vec3 u_channelRGB;

vec3 ApplyChannels(vec3 color) {
	return color * u_channelRGB;
}

uniform float u_borderEnable;
uniform float u_borderCurvature;
uniform float u_borderSmooth;
uniform vec3 u_borderColor;

vec3 ApplyBorder(vec3 color, vec2 uv) {
	vec2 corner = pow(abs(uv*2.0-1.0), vec2(1.0/u_borderCurvature));
	float edge = pow(length(corner), u_borderCurvature);
	float border = smoothstep(1.0-u_borderSmooth, 1.0, edge);
	return mix(color, u_borderColor, border);
}
#endregion

void main() {
	vec2 uv = v_vTexcoord;
	
	// [d] lens distortion
	vec2 uvl = uv;
	if (u_lensDistortionEnable > 0.5) uvl = ApplyLensDistortionUV(uv, 1.0);
	
	// image
	vec4 mainTex = texture2D(gm_BaseTexture, uv);
	
	#region Apply Effects
	// Mist
	if (u_mistEnable > 0.5) mainTex = ApplyMist(mainTex, uvl);
	
	// Speed Lines
	if (u_speedlinesEnable > 0.5) mainTex.rgb = ApplySpeedlines(mainTex.rgb, uvl);
	
	// Dithering
	if (u_ditheringEnable > 0.5) mainTex.rgb = ApplyDithering(mainTex.rgb);
	
	// Noise Grain
	if (u_noiseGrainEnable > 0.5) mainTex.rgb = ApplyNoiseGrain(mainTex.rgb);
	
	// NES Fade
	if (u_NESFadeEnable > 0.5) mainTex.rgb = ApplyNESFade(mainTex.rgb);
	
	// Cinema Bars
	if (u_cinamaBarsEnable > 0.5) mainTex.rgb = ApplyCinemaBars(mainTex.rgb, uv, uvl);
	
	// FadeColor
	if (u_fadeEnable > 0.5) mainTex.rgb = ApplyFadeColor(mainTex.rgb);
	
	// Scanlines
	if (u_scanlinesEnable > 0.5) mainTex.rgb = ApplyScanlines(mainTex.rgb, uvl);
	
	// Vignette
	if (u_vignetteEnable > 0.5) mainTex.rgb = ApplyVignette(mainTex.rgb, uvl);
	
	// Color Blindness
	if (u_colorBlindnessEnable > 0.5) mainTex.rgb = ApplyColorBlindness(mainTex.rgb);
	
	// Channels
	if (u_channelsEnable > 0.5) mainTex.rgb = ApplyChannels(mainTex.rgb);
	
	// Border
	if (u_borderEnable > 0.5) mainTex.rgb = ApplyBorder(mainTex.rgb, uvl);
	#endregion
	
	gl_FragColor = mainTex;
}
