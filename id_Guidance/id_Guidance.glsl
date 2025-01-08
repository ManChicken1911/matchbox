// Guidance (C)2017-2025 Bob Maple
// bobm-matchbox [at] idolum.com
// Version 20250107

uniform sampler2D  in_front;
uniform     float  adsk_result_w, adsk_result_h;
uniform      bool  enable_h, enable_v;
uniform	      int  amount_h, amount_v;
uniform      vec2  offset_xy;
uniform      vec3  guide_color;
uniform     float  guide_trans;
uniform      bool  thicker;


//


void main(void) {

    // Convert pixel coords to UV position for texture2D
    // and fetch the input pixel into px

    vec2 uv  = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
    vec4 px  = vec4( texture2D( in_front, uv ).rgb, 1.0 );

    // Figure out where to draw the guides

    float guide_rx = (adsk_result_w / 2.0) + (amount_h / 2.0);
    float guide_lx = (adsk_result_w / 2.0) - (amount_h / 2.0 - 1);

    float guide_uy = (adsk_result_h / 2.0) + (amount_v / 2.0);
    float guide_ly = (adsk_result_h / 2.0) - (amount_v / 2.0 - 1);

    // Add the guide offsets

    guide_rx += floor(offset_xy[0]);
    guide_lx += floor(offset_xy[0]);

    guide_uy += floor(offset_xy[1]);
    guide_ly += floor(offset_xy[1]);

    // Draw the guides

	if( enable_v ) {

		if( floor(gl_FragCoord.x) == guide_lx || floor(gl_FragCoord.x) == guide_rx )
			px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );

		if( thicker )
			if( floor(gl_FragCoord.x) == guide_lx-1 || floor(gl_FragCoord.x) == guide_rx+1 )
				px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );
	}

	if( enable_h ) {

		if( floor(gl_FragCoord.y) == guide_uy || floor(gl_FragCoord.y) == guide_ly )
        	px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );

		if( thicker )
			if( floor(gl_FragCoord.y) == guide_uy+1 || floor(gl_FragCoord.y) == guide_ly-1 )
	        	px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );
	}

	gl_FragColor = px;
}
