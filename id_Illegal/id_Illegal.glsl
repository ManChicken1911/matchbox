// Illegal (C)2017 Bob Maple
// bobm-matchbox [at] idolum.com

uniform sampler2D  in_front, in_matte;
uniform     float  adsk_result_w, adsk_result_h;
uniform      bool  showRed, showGreen, showBlue, showMatte;
uniform      vec3  colorOver, colorUnder;

vec3 adsk_rgb2yuv( vec3 );
vec3 adsk_yuv2rgb( vec3 );

//


void main(void) {

	// Convert pixel coords to UV position for texture2D
	// and fetch the input pixel into px

	vec2 uv  = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
	vec3 px  = texture2D( in_front, uv );

	vec4  pxOver  = vec4( colorOver, 1.0 );
	vec4  pxUnder = vec4( colorUnder, 1.0 );
	vec4  npx = vec4( px, 0.0 );

	// Do something important

	vec3 rgbPx = adsk_yuv2rgb( adsk_rgb2yuv( px.rgb ) );

	if( showRed ) {
		npx = rgbPx.r > 1.0 ? pxOver  : npx;
		npx = rgbPx.r < 0.0 ? pxUnder : npx;
	}
	if( showGreen ) {
		npx = rgbPx.g > 1.0 ? pxOver  : npx;
		npx = rgbPx.g < 0.0 ? pxUnder : npx;
	}
	if( showBlue ) {
		npx = rgbPx.b > 1.0 ? pxOver  : npx;
		npx = rgbPx.b < 0.0 ? pxUnder : npx;
	}

	if( !showMatte )
		npx.a = texture2D( in_matte, uv ).r;

	gl_FragColor = npx;
}
