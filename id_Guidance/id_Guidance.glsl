// Guidance (C)2017 Bob Maple
// bobm-matchbox [at] idolum.com

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

    int guide_rx = int(((adsk_result_w / 2) + (amount_h / 2)));
    int guide_lx = int(((adsk_result_w / 2) - (amount_h / 2) - 1));

    int guide_uy = int(((adsk_result_h / 2) + (amount_v / 2)));
    int guide_ly = int(((adsk_result_h / 2) - (amount_v / 2) - 1));

    // Add the guide offsets

    guide_rx += int(floor(offset_xy[0]));
    guide_lx += int(floor(offset_xy[0]));

    guide_uy += int(floor(offset_xy[1]));
    guide_ly += int(floor(offset_xy[1]));

    // Draw the guides

	if( enable_v ) {

		if( int(floor(gl_FragCoord.x)) == guide_lx || int(floor(gl_FragCoord.x)) == guide_rx )
			px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );

		if( thicker )
			if( int(floor(gl_FragCoord.x)) == guide_lx-1 || int(floor(gl_FragCoord.x)) == guide_rx+1 )
				px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );
	}

	if( enable_h ) {

		if( int(floor(gl_FragCoord.y)) == guide_uy || int(floor(gl_FragCoord.y)) == guide_ly )
        	px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );

		if( thicker )
			if( int(floor(gl_FragCoord.y)) == guide_uy+1 || int(floor(gl_FragCoord.y)) == guide_ly-1 )
	        	px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );
	}

	gl_FragColor = px;
}
