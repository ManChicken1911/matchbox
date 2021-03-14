// id_CompTrans © 2021 Bob Maple
// bobm-matchbox [at] idolum.com

uniform sampler2D  in_outgoing, in_incoming, in_matte;
uniform     float  adsk_result_w, adsk_result_h;
uniform      bool  premult;

void main(void) {

    // Convert pixel coords to UV coords for texture2D
	vec2 uv   = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );

	vec3 bg   = vec3( texture2D( in_outgoing, uv ).rgb );
	vec4 fg   = vec4( texture2D( in_incoming, uv ).rgb, texture2D( in_matte, uv ).g );

	// Unpremultiply the FG pixel if enabled and alpha is non-zero

	if( premult == true && fg.a != 0.0 )
		fg.rgb = vec3( ((fg.rgb - (vec3(0.0,0.0,0.0) * (1.0 - fg.a))) / fg.a) );

    gl_FragColor = vec4( mix( bg, fg.rgb, fg.a ), 1.0 );
}
