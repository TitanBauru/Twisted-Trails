
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

precision highp float;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// >> uniforms
uniform vec2 u_resolution;
uniform float u_time;
uniform float u_chromaticAberration;
uniform float u_scanAberration;
uniform float u_grainIntensity;
uniform float u_grainHeight;
uniform float u_grainFade;
uniform float u_grainAmount;
uniform float u_grainSpeed;
uniform float u_grainInterval;
uniform float u_scanSpeed;
uniform float u_scanSize;
uniform float u_scanOffset;
uniform float u_hScanOffset;
uniform float u_flickeringIntensity;
uniform float u_flickeringSpeed;
uniform float u_wiggleAmplitude;

const vec4 colSpectralA = vec4(vec3(1.0, 0.0, 0.0), 1.0);
const vec4 colSpectralB = vec4(vec3(0.0, 1.0, 0.0), 1.0);
const vec4 colSpectralC = vec4(vec3(0.0, 0.0, 1.0), 1.0);

// >> dependencies
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
const float Phi = 1.61803398875;

float Saturate(float x) {
	return clamp(x, 0.0, 1.0);
}

vec2 Saturate(vec2 x) {
	return clamp(x, 0.0, 1.0);
}

vec3 Saturate(vec3 x) {
	return clamp(x, 0.0, 1.0);
}

vec4 Saturate(vec4 x) {
	return clamp(x, 0.0, 1.0);
}

float GoldNoise(in vec2 fpos, in float seed) {
	// (C) 2015, Dominic Cerisano
	highp vec2 p = fpos;
	return fract(tan(distance(p*Phi, p)*seed)*p.x);
}

float BarVertical(float uv, float pos, float offset, float size) {
    return (smoothstep(pos-size, pos, uv) * offset) - smoothstep(pos, pos+size, uv) * offset;
}

float ScanVertical(float uv, float pos, float offset, float size) {
    return (smoothstep(pos-size, pos, 1.0-uv) * offset) - step(pos, 1.0-uv) * offset;
}
#endregion

void main() {
	vec2 uv = v_vTexcoord;
	vec2 uvl = uv;
	// [d] lens distortion
	//if (u_lensDistortionEnable > 0.5) uvl = ApplyLensDistortionUV(uv, 1.0); // it has limitations from gm-side
	
	uv.y = 1.0-uv.y;
	uvl.y = 1.0-uvl.y;
	float scanAberrationSum = 0.0;
	
	// wiggle
	uv.y += sin(u_time*15.0 + sin(u_time*15.0)) * u_wiggleAmplitude;
	
	// bottom glitch
	float scanTime = u_time * u_scanSpeed;
	float hscan = sin(scanTime*60.0 + sin(scanTime))*0.1+0.5;
	float vscan = floor(BarVertical(uvl.y, 0.008, hscan, 0.03)*5.0) * 0.01;
	uv.x -= vscan;
	scanAberrationSum += vscan * u_scanAberration;
	
	// scan
	float wave = sin(uvl.y*4.0 + scanTime);
	float scan = step(sin(wave), wave) * u_hScanOffset;
	uv.x += scan;
	float scan_noise = GoldNoise(vec2(u_time, gl_FragCoord.y), 1.0);
	for(float i = 1.0; i < 2.0; i+=1.0/2.0) {
		float scanYoffset = -u_scanSize + fract(scanTime*0.1 * i) * 2.0;
		float scanHscan = sin(uvl.y + scanTime * i);
		float scan = ScanVertical(uvl.y, scanYoffset, u_scanOffset*uvl.y*scanHscan, u_scanSize);
		uv.x -= scan * scan_noise;
		scanAberrationSum += scan * u_scanAberration;
	}
	// chromatic aberration
	float chromaOffset = (u_chromaticAberration + scanAberrationSum) * 0.01;
	vec4 colChromaA = texture2D(gm_BaseTexture, vec2(uv.x+chromaOffset, 1.0-uv.y));
	vec4 colChromaB = texture2D(gm_BaseTexture, vec2(uv.x, 1.0-uv.y));
	vec4 colChromaC = texture2D(gm_BaseTexture, vec2(uv.x-chromaOffset, 1.0-uv.y));
	vec4 col = colChromaA*colSpectralA + colChromaB*colSpectralB + colChromaC*colSpectralC;
	vec4 colSum = (colSpectralA + colSpectralB + colSpectralC);
	vec4 colFinal = col / colSum;
	
	// grain
	float grainTime = 100.0 + u_time;
	float grainLines = u_resolution.y / max(2.0, u_grainAmount);
	float sprinkles = GoldNoise(vec2(1.0+grainTime, gl_FragCoord.y), 1.0);
	sprinkles = 1.0 + pow(sprinkles, 7.0) * step(u_grainInterval, sprinkles);
	float grainYoffset = (grainTime * grainLines * u_grainSpeed) * sprinkles;
	float mask = floor(mod(gl_FragCoord.y-grainYoffset, grainLines+u_grainHeight) / grainLines) * smoothstep(mix(2.0, 0.0, u_grainFade), 0.0, uv.y);
	float grain = pow(GoldNoise(gl_FragCoord.xy, 1.0+fract(grainTime)), 1.0/u_grainIntensity) * mask;
	colFinal.rgb += grain;
	
	// flickering
	float flickeringTime = u_time * u_flickeringSpeed;
	float scanlines = ((sin(uvl.y*0.8 + flickeringTime*15.0 + sin(flickeringTime))*0.5+0.2) * u_flickeringIntensity);
	scanlines = Saturate(scanlines);
	colFinal.rgb = mix(colFinal.rgb, vec3(scanlines), scanlines);
	gl_FragColor = colFinal;
}
