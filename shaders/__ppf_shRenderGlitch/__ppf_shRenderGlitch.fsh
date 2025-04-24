
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
uniform vec2 u_texelSize;
uniform vec2 u_resolution;
uniform float u_time;

const vec4 u_randomSeeds = vec4(0.0, 1.0, 1.0, 1.0); // 0 - 1
    
uniform float u_glitchIntensity;

uniform float u_glitchShuffleOffset;
uniform float u_glitchShuffleSpeed;
uniform vec2 u_glitchShuffleAmount;
uniform vec2 u_glitchShuffle1Scale;
uniform vec2 u_glitchShuffle2Scale;
uniform vec2 u_glitchShufflePower;

uniform float u_glitchShakeOffset;
uniform float u_glitchShakeSpeed;
uniform float u_glitchSineOffset;
uniform float u_glitchSineSpeed;
uniform float u_glitchSineWiggleIntensity;
uniform float u_glitchSineWiggleInterval;
uniform float u_glitchInterlacingOffset;
uniform vec2 u_glitchStripOffset;
uniform float u_glitchStripAmount;
uniform float u_glitchStripSpeed;
uniform float u_glitchStripScale;
uniform float u_glitchChromaShiftOffset;
uniform float u_glitchChromaShiftNoise;


#region >> dependencies
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
#endregion


float randomNoise(vec2 seed, float time) {
	return fract(sin(dot(seed * floor(time * 30.0), vec2(127.1, 311.7))) * 43758.5453123);
}

float randomNoise(float seed, float time) {
	return randomNoise(vec2(seed, 1.0), time);
}


//float randomNoise(vec2 seed, float t) {
//	highp float d = 437.0 + mod(t, 10.0);
//	highp vec2 p = seed;
//	return fract(sin(cos(1.0-sin(p.x) * 1.0-cos(p.y)) * d) * d);
//}

//float randomNoise(float seed, float t) {
//	return randomNoise(vec2(seed), t);
//}



float peak(float x, float xpos, float scale) {
	// Thanks to: "BitOfGold"
	return clamp((1.0 - x) * scale * log(1.0 / abs(x - xpos)), 0.0, 1.0);
}

void main() {
    // UV
	vec2 uv = v_vTexcoord;
	vec2 uvl = uv;
	vec2 uvOffset = vec2(0.0);
	vec2 uvChromaShift;
	float time = 100.0 + u_time;
	
	// [d] lens distortion
	//if (u_lensDistortionEnable > 0.5) uvl = ApplyLensDistortionUV(uv, 1.0); // it has limitations from gm-side
	
	// Sine [OK]
	float sineTime = time*u_glitchSineSpeed;
	float sineOffset = u_glitchSineOffset;
	sineOffset += u_randomSeeds.x * u_glitchSineWiggleIntensity; // wiggle random value comes from CPU
	float sine = (cos(uv.y*35.4-sineTime*1.2) + sin(uv.y*15.38+sineTime) * 1.7) * sineOffset;
	uvOffset.x += sine;
	
	// Interlacing (reacts with sine) [OK]
	float interlacingOffset = (sin(uv.y*20.0+sineTime)*10.0) * u_glitchInterlacingOffset * sine;
	float interlacing = mix(0.01, -0.01, step(mod(floor(gl_FragCoord.y/1.0), 2.0), 0.0)) * interlacingOffset;
	uvOffset.x += interlacing;
	
	// Strip line offset [OK]
	float lines = (floor(uv.y * u_resolution.y * (1.0-u_glitchStripScale)) / u_resolution.y);
	float linesNoise = randomNoise(vec2(0.0, lines), time*u_glitchStripSpeed);
	float lineInterval = step(linesNoise, u_glitchStripAmount);
	float linesOffset = linesNoise * mix(u_glitchStripOffset.x, -u_glitchStripOffset.y, step(linesNoise, 0.5)) * lineInterval;
	uvOffset.x -= linesOffset;// * peak(uv.y, linesOffset, linesOffset);
		
	// Shake [OK]
	float shakeNoise = randomNoise(1.0, time*u_glitchShakeSpeed);
	uvOffset.x += mix(0.0, u_glitchShakeOffset, step(shakeNoise, 0.25));
	
	// Shuffle [NOT WORKING CORRECTLY...]
	float shuffleTime = floor(time*u_glitchShuffleSpeed) / u_glitchShuffleSpeed;
	vec2 uvRounded1 = floor(uv * u_resolution.xy * (1.0-u_glitchShuffle1Scale)) / u_resolution.xy;
	vec2 uvRounded2 = floor(uv * u_resolution.xy * (1.0-u_glitchShuffle2Scale)) / u_resolution.xy;
	vec2 shuffleNoise = vec2(
	    pow(randomNoise(uvRounded1+(5.72*u_randomSeeds.y), shuffleTime), u_glitchShufflePower.x)+0.01,
	    pow(randomNoise(uvRounded2+(2.49*u_randomSeeds.z), shuffleTime), u_glitchShufflePower.y)+0.01
	);
	//shuffleNoise.x *= step(shuffleNoise.x, u_glitchShuffleAmount.x); // THIS MAKES THE SHUFFLE NOT WORK
	//shuffleNoise.y *= step(shuffleNoise.y, u_glitchShuffleAmount.y);
	if (shuffleNoise.x < u_glitchShuffleAmount.x) shuffleNoise.x *= 0.0;
	if (shuffleNoise.y < u_glitchShuffleAmount.y) shuffleNoise.y *= 0.0;
	float shuffle = u_glitchShuffleOffset * (shuffleNoise.x * shuffleNoise.y);
	uvChromaShift.xy += shuffle;
	
	// Chroma Shift [OK]
	float chromaShift = pow(randomNoise(1.0, time), 10.0) * u_glitchChromaShiftOffset;
	uvChromaShift -= chromaShift;
	
	// Chroma Noise [OK]
	float chromaNoise = randomNoise(uv, time);
	uvChromaShift += chromaNoise * u_glitchChromaShiftNoise;
	
	// final
	uv += uvOffset * u_glitchIntensity;
	uvChromaShift *= u_glitchIntensity;
	vec4 destTexR = texture2D(gm_BaseTexture, uv);
	vec4 destTexG = texture2D(gm_BaseTexture, uv + uvChromaShift);
	vec4 destTexB = texture2D(gm_BaseTexture, uv - uvChromaShift);
	vec4 finalCol = vec4(vec3(destTexR.x, destTexG.y, destTexB.z), destTexR.a);
	gl_FragColor = mix(destTexR, finalCol, u_glitchIntensity);
	//gl_FragColor = vec4(vec3(shuffle*1.0), 1.0);
}
