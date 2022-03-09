// id_CompTrans © 2022 Bob Maple
// bobm-matchbox [at] idolum.com

uniform sampler2D  in_outgoing, in_incoming, in_inmatte, in_outmatte;
uniform     float  adsk_result_w, adsk_result_h;
uniform      bool  premult, out_over_in;

void main(void) {

	// Convert pixel coords to UV coords for texture2D
	vec2 uv   = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );

	vec3 bg;
	vec4 fg;

	if( out_over_in ) {		// Swap in the inputs and matte
		bg = vec3( texture2D( in_incoming, uv ).rgb );
		fg = vec4( texture2D( in_outgoing, uv ).rgb, texture2D( in_outmatte, uv ).g );
	}
	else {
		bg = vec3( texture2D( in_outgoing, uv ).rgb );
		fg = vec4( texture2D( in_incoming, uv ).rgb, texture2D( in_inmatte, uv ).g );
	}

	// Unpremultiply the FG pixel if enabled and alpha is non-zero

	if( premult == true && fg.a != 0.0 )
		fg.rgb = vec3( ((fg.rgb - (vec3(0.0,0.0,0.0) * (1.0 - fg.a))) / fg.a) );

    gl_FragColor = vec4( mix( bg, fg.rgb, fg.a ), 1.0 );
}
