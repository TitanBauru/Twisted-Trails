
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

varying vec2 v_vPosition;
varying vec2 v_vTexcoord;

uniform vec2 u_resolution;
uniform sampler2D u_charsTexture;
uniform vec4 u_charsTextureUVs;
uniform float u_framesAmount;
uniform vec2 u_gridSize;
uniform float u_scale;
uniform vec3 u_color;
uniform float u_pixelMix;
uniform float u_saturation;
uniform float u_mix;
uniform float u_intensity;

const vec3 lumWeights = vec3(0.2126729, 0.7151522, 0.0721750);
float GetLuminance(vec3 color) {
	return dot(color, lumWeights);
}

void main() {
	vec2 gridSize = u_gridSize * u_scale;
	vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
	
	vec2 uvP = v_vTexcoord;
	uvP = floor(uvP * u_resolution / gridSize) * gridSize / u_resolution;
	vec4 pixelatedCol = texture2D(gm_BaseTexture, uvP);
	float lum = GetLuminance(pixelatedCol.rgb);
	
	float frameIndex = floor(lum * u_framesAmount);
	vec2 charUV = fract(v_vPosition/gridSize);
	charUV.x = (charUV.x + frameIndex) / u_framesAmount;
	charUV = clamp(charUV, 0.0, 1.0);
	vec4 charCol = texture2D(u_charsTexture, mix(u_charsTextureUVs.xy, u_charsTextureUVs.zw, charUV)) * u_intensity;
	charCol.rgb *= u_color;
	
	vec4 colFinal = col;
	colFinal.rgb = mix(charCol.rgb*colFinal.rgb, charCol.rgb*pixelatedCol.rgb, u_pixelMix); // color
	colFinal.rgb = mix(charCol.rgb, colFinal.rgb, u_saturation); // saturation
	colFinal.rgb = mix(colFinal.rgb, col.rgb+colFinal.rgb, u_mix); // mix
	gl_FragColor = colFinal;
}
