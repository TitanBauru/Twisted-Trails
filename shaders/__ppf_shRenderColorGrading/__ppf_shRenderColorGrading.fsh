
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

#region LICENSES

// ACES
/*-------------------------------[ License Terms for Academy Color Encoding System Components ]-------------------------------
Academy Color Encoding System (ACES) software and tools are provided by the Academy under the following terms and conditions:
A worldwide, royalty-free, non-exclusive right to copy, modify, create derivatives, and use, in source and binary forms, is
hereby granted, subject to acceptance of this license.

Copyright © 2015 Academy of Motion Picture Arts and Sciences (A.M.P.A.S.). Portions contributed by others as indicated.
All rights reserved.

Performance of any of the aforementioned acts indicates acceptance to be bound by the following terms and conditions:

* Copies of source code, in whole or in part, must retain the above copyright notice, this list of conditions and the Disclaimer
of Warranty.

* Use in binary form must retain the above copyright notice, this list of conditions and the Disclaimer of Warranty in the
documentation and/or other materials provided with the distribution.

* Nothing in this license shall be deemed to grant any rights to trademarks, copyrights, patents, trade secrets or any other
intellectual property of A.M.P.A.S. or any contributors, except as expressly stated herein.

* Neither the name "A.M.P.A.S." nor the name of any other contributors to this software may be used to endorse or promote products
derivative of or based on this software without express prior written permission of A.M.P.A.S. or the contributors, as appropriate.

This license shall be construed pursuant to the laws of the State of California, and any disputes related thereto shall be subject
to the jurisdiction of the courts therein.

Disclaimer of Warranty: THIS SOFTWARE IS PROVIDED BY A.M.P.A.S. AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT
ARE DISCLAIMED. IN NO EVENT SHALL A.M.P.A.S., OR ANY CONTRIBUTORS OR DISTRIBUTORS, BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, RESITUTIONARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

WITHOUT LIMITING THE GENERALITY OF THE FOREGOING, THE ACADEMY SPECIFICALLY DISCLAIMS ANY REPRESENTATIONS OR WARRANTIES WHATSOEVER
RELATED TO PATENT OR OTHER INTELLECTUAL PROPERTY RIGHTS IN THE ACADEMY COLOR ENCODING SYSTEM, OR APPLICATIONS THEREOF, HELD BY
PARTIES OTHER THAN A.M.P.A.S., WHETHER DISCLOSED OR UNDISCLOSED.
-------------------------------------------------------------------------------------------

Other author information can be found in links and comments in the code.
*/

#endregion

precision highp float;

varying vec2 v_vPosition;
varying vec2 v_vTexcoord;

uniform vec2 u_resolution;

// >> dependencies
#region Common

#define ACEScc_MAX 1.4679964
#define ACEScc_MIDGRAY 0.4135884

const mat3 AP1_2_XYZ_MAT = mat3 (
	0.6624541811, 0.1340042065, 0.1561876870,
	0.2722287168, 0.6740817658, 0.0536895174,
	-0.0055746495, 0.0040607335, 1.0103391003
);
const vec3 AP1_RGB2Y = vec3(AP1_2_XYZ_MAT[0][1], AP1_2_XYZ_MAT[1][1], AP1_2_XYZ_MAT[2][1]);
const float M_LOG10E = 0.434294481903251827651128918916605082;

const vec3 lumWeights = vec3(0.2126, 0.7152, 0.0722);
const vec3 lumWeightsAverage = vec3(0.333);

float GetLuminance(vec3 color) {
	return dot(color, lumWeights);
}

float GetLuminanceAverage(vec3 color) {
	return dot(color, lumWeightsAverage);
}

float GetLuminanceACES(vec3 color) {
	return dot(color, AP1_RGB2Y);
}

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

// screen blend
vec3 Blend(vec3 source, vec3 dest) {
	return source + dest - source * dest;
}

vec3 Blend(vec3 source, vec4 dest) {
	return dest.rgb * dest.a + source * (1.0-dest.a);
}

vec4 Blend(vec4 source, vec4 dest) {
	return dest * dest.a + source * (1.0-dest.a);
}

vec3 tanh(vec3 x) {
    return (exp(x) - exp(-x)) / (exp(x) + exp(-x));
}

#endregion

#region Color Spaces

const float YRGB_EPSILON = 1e-6;
#define GAMMA 2.4 // 2.2

///// @desc Converts gamma space color to linear space.
vec3 GammaToLinear(vec3 rgb) {
	return pow(rgb, vec3(GAMMA));
}

/// @desc Converts linear space color to gamma space.
vec3 LinearToGamma(vec3 rgb) {
	return pow(rgb, vec3(1.0 / GAMMA));
}

// Convert linear RGB color to sRGB color
vec3 LinearTosRGB(vec3 colorLinear) {
    vec3 colorSRGB = clamp(colorLinear, 0.0, 1.0);
    colorSRGB = mix(12.92 * colorSRGB, 1.055 * pow(colorSRGB, vec3(1.0 / 2.4)) - 0.055, step(0.0031308, colorSRGB));
    return colorSRGB;
}

// Convert sRGB color to linear RGB color
vec3 SRGBToLinear(vec3 colorSRGB) {
    vec3 colorLinear = clamp(colorSRGB, 0.0, 1.0);
    colorLinear = mix(colorLinear / 12.92, pow((colorLinear + 0.055) / 1.055, vec3(2.4)), step(0.04045, colorLinear));
    return colorLinear;
}

vec3 HUEtoRGB(in float hue) {
	// Hue [0..1] to RGB [0..1]
	// See http://www.chilliant.com/rgb2hsv.html
	vec3 rgb = abs(hue * 6. - vec3(3, 2, 4)) * vec3(1, -1, -1) + vec3(-1, 2, 2);
	return clamp(rgb, 0., 1.);
}

vec3 RGBtoHCV(in vec3 rgb) {
	// RGB [0..1] to Hue-Chroma-Value [0..1]
	// Based on work by Sam Hocevar and Emil Persson
	vec4 p = (rgb.g < rgb.b) ? vec4(rgb.bg, -1., 2. / 3.) : vec4(rgb.gb, 0., -1. / 3.);
	vec4 q = (rgb.r < p.x) ? vec4(p.xyw, rgb.r) : vec4(rgb.r, p.yzx);
	float c = q.x - min(q.w, q.y);
	float h = abs((q.w - q.y) / (6. * c + YRGB_EPSILON) + q.z);
	return vec3(h, c, q.x);
}

vec3 HSVtoRGB(in vec3 hsv) {
	// Hue-Saturation-Value [0..1] to RGB [0..1]
	vec3 rgb = HUEtoRGB(hsv.x);
	return ((rgb - 1.) * hsv.y + 1.) * hsv.z;
}

vec3 HSLtoRGB(in vec3 hsl) {
	// Hue-Saturation-Lightness [0..1] to RGB [0..1]
	vec3 rgb = HUEtoRGB(hsl.x);
	float c = (1. - abs(2. * hsl.z - 1.)) * hsl.y;
	return (rgb - 0.5) * c + hsl.z;
}

vec3 RGBtoHSV(in vec3 rgb) {
	// RGB [0..1] to Hue-Saturation-Value [0..1]
	vec3 hcv = RGBtoHCV(rgb);
	float s = hcv.y / (hcv.z + YRGB_EPSILON);
	return vec3(hcv.x, s, hcv.z);
}

vec3 RGBtoHSL(in vec3 rgb) {
	// RGB [0..1] to Hue-Saturation-Lightness [0..1]
	vec3 hcv = RGBtoHCV(rgb);
	float z = hcv.z - hcv.y * 0.5;
	float s = hcv.y / (1. - abs(z * 2. - 1.) + YRGB_EPSILON);
	return vec3(hcv.x, s, z);
}

vec3 LRGBtoLMS(vec3 col) {
	// Linear RGB to LMS
	const mat3 LIN_2_LMS_MAT = mat3 (
		3.90405e-1, 5.49941e-1, 8.92632e-3,
		7.08416e-2, 9.63172e-1, 1.35775e-3,
		2.31082e-2, 1.28021e-1, 9.36245e-1
	);
	return col * LIN_2_LMS_MAT;
}

vec3 LMStoLRGB(vec3 col) {
	// LMS to Linear RGB
	const mat3 LMS_2_LIN_MAT = mat3 (
		2.85847e+0, -1.62879e+0, -2.48910e-2,
		-2.10182e-1,  1.15820e+0,  3.24281e-4,
		-4.18120e-2, -1.18169e-1,  1.06867e+0
	);
	return col * LMS_2_LIN_MAT;
}

vec3 CIEtoLMS(float x, float y) {
	float Y = 1.0;
	float X = Y * x / y;
	float Z = Y * (1.0 - x - y) / y;
	
	float L = 0.7328 * X + 0.4296 * Y - 0.1624 * Z;
	float M = -0.7036 * X + 1.6975 * Y + 0.0061 * Z;
	float S = 0.0030 * X + 0.0136 * Y + 0.9834 * Z;
	
	return vec3(L, M, S);
}

vec3 SRGBtoLinear(vec3 col){
    return mix(col / 12.92, pow((col+0.055)/1.055,vec3(2.4)), step(0.04045, col));
}

vec3 LinearToSRGB(vec3 col){
    return mix(col*12.92, 1.055 * pow(col, vec3(0.41667)) - 0.055, step(0.0031308, col));
}

float extractSaturation(vec3 color) {
	vec3 hsl = RGBtoHSL(color);
	return hsl.y;
}

#endregion

#region Tonemap

vec3 TonemapJodieReinhard(vec3 c) {
	vec3 tc = c / (c + 1.0);
	return mix(c / (GetLuminance(c) + 1.0), tc, tc);
}

vec3 tonemap_reinhard(vec3 v) {
    return v / (1.0 + v);
}

vec3 tonemap_reinhard_white(vec3 color, float white) {
	return (color * (1.0 + color / (white * white))) / (1.0 + color);
}

vec3 tonemap_reinhard_white2(vec3 color, float white) {
	return (white * color + color) / (color * white + white);
}

vec3 tonemap_jodie_reinhard(vec3 c) {
	vec3 tc = c / (c + 1.0);
	return mix(c / (GetLuminance(c) + 1.0), tc, tc);
}

vec3 uncharted2_tonemap_partial(vec3 x) {
    float A = 0.15;
    float B = 0.50;
    float C = 0.10;
    float D = 0.20;
    float E = 0.02;
    float F = 0.30;
    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}
vec3 uncharted2_filmic(vec3 v, float white) {
	float exposure_bias = 2.0;
	vec3 curr = uncharted2_tonemap_partial(v * exposure_bias);
	vec3 W = vec3(11.2 * white); // 11.2;
	vec3 white_scale = vec3(1.0) / uncharted2_tonemap_partial(W);
	return curr * white_scale;
}

//vec3 RRTAndODTFit2(vec3 color) {
//    vec3 color_tonemapped = (color * (color + 0.0245786) - 0.000090537) / (color * (0.983729 * color + 0.4329510) + 0.238081);
//    return color_tonemapped;
//}
vec3 RRTAndODTFitWhite(vec3 color, float white, float exposure_bias) {
    vec3 color_tonemapped = (color * (color + 0.0245786) - 0.000090537) / (color * (0.983729 * color + 0.4329510) + 0.238081);
	//white *= exposure_bias;
    //float white_tonemapped = (white * (white + 0.0245786) - 0.000090537) / (white * (0.983729 * white + 0.4329510) + 0.238081);
    return color_tonemapped;// / white_tonemapped;
}
const mat3 ACESInputMat = mat3(
	0.575961650,  0.344143820,  0.079952030,
	0.070806820,  0.827392350,  0.101774690,
	0.028035252,  0.131523770,  0.840242300
);
const mat3 ACESOutputMat = mat3(
	1.666954300, -0.601741150, -0.065202855,
	-0.106835220,  1.237778600, -0.130948950,
	-0.004142626, -0.087411870,  1.091555000
);
vec3 tonemap_ACES(vec3 LinearColor, float white) {
	// Original by Stephen Hill, adapted by Mozart Junior
	vec3 color = LinearColor;
	color = color * ACESInputMat;
	//color = tanh(color);
	color = tonemap_reinhard_white(color, white);
	//color = RRTAndODTFitWhite(color, white, exposure_bias);
	//color = uncharted2_filmic(color, white);
	// Transform color spaces, perform blue correction and pre desaturation
	color = color * ACESOutputMat;
	return color;
}

vec3 tonemap_ACESFilm(vec3 color) {
	// Original by Narkowicz 2015, "ACES Filmic Tone Mapping Curve". Modified by Mozart Junior.
	color = color * ACESInputMat;
	color = clamp((color * (2.51 * color + 0.03)) / (color * (2.43 * color + 0.59) + 0.14), 0.0, 1.0);
	color = color * ACESOutputMat;
	return color;
}

#endregion

#region >> Effects

uniform float u_LUTenable;
uniform vec2 u_LUTsize;
uniform vec2 u_LUTTiles;
uniform float u_LUTintensity;
uniform sampler2D u_LUTtexture;
uniform vec4 u_LUTUVs;

vec3 ApplyLUT(vec3 color) {
	// Copyright (C) 2024 Mozart Junior
	vec2 tiles = u_LUTTiles;
	float z = Saturate(color.b) * (tiles.x * tiles.y - 1.0);
	float zB = floor(z);
	float zC = ceil(z);
	vec2 tile1;
		tile1.y = floor(zB / tiles.x);
		tile1.x = floor(zB - tile1.y * tiles.x);
	vec2 tile2;
		tile2.y = floor(zC / tiles.x);
		tile2.x = floor(zC - tile2.y * tiles.x);
	vec2 tileSize = u_LUTsize / tiles;
	vec2 tileUV = mix(0.5/tileSize, (tileSize-0.5)/tileSize, Saturate(color.rg));
	vec3 col = mix(
		texture2D(u_LUTtexture, mix(u_LUTUVs.xy, u_LUTUVs.zw, (tile1/tiles)+(tileUV/tiles))).rgb,
		texture2D(u_LUTtexture, mix(u_LUTUVs.xy, u_LUTUVs.zw, (tile2/tiles)+(tileUV/tiles))).rgb,
		z-zB
	);
	return mix(color, col, u_LUTintensity);
}

uniform float u_whiteBalanceEnable;
uniform vec2 u_whiteBalanceChromaticity;

vec3 ApplyWhiteBalance(vec3 color) {
	// tristimulus values of the D65 white point in the CIE XYZ color space
	vec3 white1 = vec3(0.949237, 1.03542, 1.08728); // D65 illuminant  //vec3(0.95047, 1.00000, 1.08883)
	// CIE To LMS color space
	vec3 white2 = CIEtoLMS(u_whiteBalanceChromaticity.x, u_whiteBalanceChromaticity.y);
	// get balance
	vec3 balance = vec3(white1 / white2);
	vec3 lms = LRGBtoLMS(color);
	lms *= balance;
	color = LMStoLRGB(lms);
	return color;
}

uniform float u_exposureEnable;
uniform float u_exposureValue;

vec3 ApplyExposure(vec3 color) {
	return color * u_exposureValue;
}

uniform float u_brightnessEnable;
uniform float u_brightnessValue;

vec3 ApplyBrightness(vec3 color) {
	return max(color + (u_brightnessValue - 1.0), 0.0);
}

uniform float u_contrastEnable;
uniform float u_contrastValue;

vec3 ApplyContrast(vec3 color) {
	//color = LinearToLogC(color); // currently not supported
	color = (color - ACEScc_MIDGRAY) * max(u_contrastValue, 0.0) + ACEScc_MIDGRAY;
	return color; //LogCToLinear(color);
}

uniform float u_channelMixerEnable;
uniform vec3 u_channelMixerRed;
uniform vec3 u_channelMixerGreen;
uniform vec3 u_channelMixerBlue;

vec3 ApplyChannelMixer(vec3 color) {
	return vec3(dot(color, u_channelMixerRed.rgb), dot(color, u_channelMixerGreen.rgb), dot(color, u_channelMixerBlue.rgb));
}

uniform float u_colorBalanceEnable;
uniform vec3 u_shadowColor;
uniform vec3 u_midtoneColor;
uniform vec3 u_highlightColor;
uniform vec4 u_colorBalanceRanges;

vec3 ApplyShadowsMidtonesHighlights(vec3 color) {
	float lum = GetLuminanceACES(color);
	float shadowInfluence = 1.0 - smoothstep(u_colorBalanceRanges.x, u_colorBalanceRanges.y, lum);
	float highlightInfluence = smoothstep(u_colorBalanceRanges.z, u_colorBalanceRanges.w, lum);
	float midtoneInfluence = 1.0 - shadowInfluence - highlightInfluence;
	color *= (shadowInfluence * u_shadowColor) + (midtoneInfluence * u_midtoneColor + (highlightInfluence * u_highlightColor));
	return color;
}

uniform float u_liftGammaGainEnable;
uniform vec3 u_liftColor;
uniform vec3 u_invGammaColor;
uniform vec3 u_gainColor;

vec3 ApplyLiftGammaGain(vec3 color) {
	color *= u_gainColor;
	color = Saturate(color * (1.5-0.5 * u_liftColor) + 0.5 * u_liftColor - 0.5);
	color = pow(abs(color), u_invGammaColor);
	return color;
}

uniform float u_saturationEnable;
uniform float u_saturationValue;

vec3 ApplySaturation(vec3 color) {
	float lum = GetLuminance(color);
	return mix(vec3(lum), color, u_saturationValue);
}

uniform float u_hueshiftEnable;
uniform vec3 u_hueshiftHSV;
uniform float u_hueshiftPreserveLum;

vec3 ApplyHueShift(vec3 color) {
	float originalLum = RGBtoHSL(color).z;
	
	color = RGBtoHSV(color);
	color.x = fract(color.x + u_hueshiftHSV.x);
	color.y *= u_hueshiftHSV.y;
	//color.z *= u_hueshiftHSV.z;
	color = HSVtoRGB(color);
	
	if (u_hueshiftPreserveLum > 0.5) {
		color.rgb = RGBtoHSL(color.rgb);
		color.z = originalLum;
		color.rgb = HSLtoRGB(color.rgb);
	}
	return color;
}

uniform float u_colortintEnable;
uniform vec3 u_colortintColor;

vec3 ApplyColorTint(in vec3 color) {
	return color * u_colortintColor;
}

uniform float u_colorizeEnable;
uniform vec3 u_colorizeHSV;
uniform float u_colorizeIntensity;

vec3 ApplyColorize(vec3 color) {
	float lum = GetLuminance(color);
	float aa = clamp(2.0 * lum, 0.0, 1.0);
	float cc = clamp(2.0 * (1.0 - lum), 0.0, 1.0);
	float bb = 1.0 - aa - cc;
	return mix(color, 1.0-(bb*HSVtoRGB(u_colorizeHSV)+cc), u_colorizeIntensity);
}

uniform float u_posterizationEnable;
uniform float u_posterizationColFactor;

vec3 ApplyPosterization(vec3 color) {
	color = floor(color * u_posterizationColFactor) / u_posterizationColFactor;
	return color;
}

uniform float u_invertColorsEnable;
uniform float u_invertColorsIntensity;

vec3 ApplyInvertColors(vec3 color) {
	return mix(color, 1.0-color, u_invertColorsIntensity);
}

uniform float u_curvesEnable;
uniform float u_curvesPreserveLuminance;
uniform float u_curvesUseYRGB;
uniform float u_curvesUseHHSL;
uniform sampler2D u_curvesYRGBTexture;
uniform sampler2D u_curvesHHSLTexture;

vec3 ApplyColorCurves(vec3 color) {
	vec3 linearCol = color;
	// HHSL
	float saturation;
	if (u_curvesUseHHSL > 0.5) {
		// convert to hsv space
		vec3 hsv = RGBtoHSV(linearCol);
		saturation = Saturate(texture2D(u_curvesHHSLTexture, vec2(hsv.x, 0.0)).y) * 2.0; // hue x sat
		saturation *= Saturate(texture2D(u_curvesHHSLTexture, vec2(hsv.y, 0.0)).z) * 2.0; // sat x sat
		saturation *= Saturate(texture2D(u_curvesHHSLTexture, vec2(GetLuminance(linearCol), 0.0)).w) * 2.0; // lum x sat
		
		// hue shift
		float hue = hsv.x + u_hueshiftHSV.x;
		hue += Saturate(texture2D(u_curvesHHSLTexture, vec2(hue, 0.0)).x) - 0.5; // hue x hue
		hsv.x = fract(hue);
		
		// back to linear RGB space
		linearCol = HSVtoRGB(hsv);
		
		// saturation
		float lum = GetLuminance(linearCol);
		linearCol = mix(vec3(lum), linearCol, saturation * u_hueshiftHSV.y);
	}
	
	vec3 original_lum = RGBtoHSL(linearCol);
	
	// YRGB
	if (u_curvesUseYRGB > 0.5) {
		// Y (main)
		float yred = Saturate(texture2D(u_curvesYRGBTexture, vec2(linearCol.r, 0.0)).w);
		float ygreen = Saturate(texture2D(u_curvesYRGBTexture, vec2(linearCol.g, 0.0)).w);
		float yblue = Saturate(texture2D(u_curvesYRGBTexture, vec2(linearCol.b, 0.0)).w);
		linearCol = vec3(yred, ygreen, yblue);
		
		// RGB
		float red = Saturate(texture2D(u_curvesYRGBTexture, vec2(linearCol.r, 0.0)).x);
		float green = Saturate(texture2D(u_curvesYRGBTexture, vec2(linearCol.g, 0.0)).y);
		float blue = Saturate(texture2D(u_curvesYRGBTexture, vec2(linearCol.b, 0.0)).z);
		linearCol = vec3(red, green, blue);
	}
	
	// preserve luminance
	linearCol.rgb = RGBtoHSL(linearCol.rgb);
	linearCol.z = mix(linearCol.z, original_lum.z, step(0.5, u_curvesPreserveLuminance));
	linearCol.rgb = HSLtoRGB(linearCol.rgb);
	return linearCol;
}

uniform float u_toneMappingEnable;
uniform int u_toneMappingMode;
uniform float u_toneMappingWhite;

vec3 ApplyToneMapping(vec3 color) {
	float white = u_toneMappingWhite;
	//if (u_toneMappingMode == 0) {
		// linear
	//} else
	if (u_toneMappingMode == 1) {
		// reinhard
		color = tonemap_reinhard_white(color, white);
	} else
	if (u_toneMappingMode == 2) {
		// ACES
		color = tonemap_ACES(color, white);
	} else
	if (u_toneMappingMode == 3) {
		// ACES Film
		color = LinearToGamma(color);
		color = tonemap_ACESFilm(color);
		color = GammaToLinear(color);
	}
	color = clamp(color, 0.0, 1.0);
	return color;
}

#endregion

void main() {
	// image
	vec4 destinationTex = texture2D(gm_BaseTexture, v_vTexcoord);
	vec3 color = destinationTex.rgb;
	
	#region Apply Effects
	// Note: GameMaker does not perform color space management by default.
	// I only did the conversion here because I observed better results in tone mapping.
	
	// < Gamma to Linear >
	color = GammaToLinear(color);
	
	// White Balance
	if (u_whiteBalanceEnable > 0.5) color = ApplyWhiteBalance(color);
	
	// Exposure
	if (u_exposureEnable > 0.5) color = ApplyExposure(color);
	
	// Tone Mapping
	if (u_toneMappingEnable > 0.5) color = ApplyToneMapping(max(color, 0.0));
	
	// < Linear to Gamma >
	color = LinearToGamma(color);
	
	// Contrast (after tone mapping allows better control)
	if (u_contrastEnable > 0.5) color = ApplyContrast(color);
	
	// Brightness
	if (u_brightnessEnable > 0.5) color = ApplyBrightness(color);
	
	// Channel Mixer
	if (u_channelMixerEnable > 0.5) color = ApplyChannelMixer(color);
	
	// Shadows, Midtones, Highlights
	if (u_colorBalanceEnable > 0.5) color = ApplyShadowsMidtonesHighlights(color);
	
	// Lift, Gamma, Gain
	if (u_liftGammaGainEnable > 0.5) color = ApplyLiftGammaGain(color);
	
	// < Color Grading (creative adjustments) Must be applied after tone mapping, because it receives LDR pixels >
	// > Prevent Negative Values
	color = max(color, 0.0);
	
	// Saturation
	if (u_saturationEnable > 0.5) color = ApplySaturation(color);
	
	// HUE Shift
	if (u_hueshiftEnable > 0.5) color = ApplyHueShift(color);
	
	// Color Tint
	if (u_colortintEnable > 0.5) color = ApplyColorTint(color);
	
	// Colorize
	if (u_colorizeEnable > 0.5) color = ApplyColorize(color);
	
	// Posterize
	if (u_posterizationEnable > 0.5) color = ApplyPosterization(color);
	
	// Invert Colors
	if (u_invertColorsEnable > 0.5) color = ApplyInvertColors(color);
	
	// Color Curves (LDR)
	if (u_curvesEnable > 0.5) color = ApplyColorCurves(color);
	
	// LUT
	if (u_LUTenable > 0.5) color = ApplyLUT(color);
	
	#endregion
	
	gl_FragColor = vec4(color.rgb, destinationTex.a);
}
