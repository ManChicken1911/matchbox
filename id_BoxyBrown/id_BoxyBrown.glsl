// id_BoxyBrown by Bob Maple
// https://github.com/ManChicken1911/matchbox
// Version 2025.11.04


uniform      vec2  box_size, offset_xy;
uniform      vec3  box_color;
uniform     float  edge_soft, corner_rad;
uniform      bool  mask_fg, premult;

uniform     float  adsk_result_w, adsk_result_h;
uniform sampler2D  in_front, in_matte;



// Temp

const float border_size = 1.0;


//

float calc_distance( vec2 position, vec2 size, float radius ) {
    return( length( max( abs(position) - size + radius, 0.0 ) ) - radius );
}


void main(void) {

    vec2 pxres    = vec2( adsk_result_w, adsk_result_h );

    // Convert pixel coords to UV for texture2D
    vec2 uv       = gl_FragCoord.xy / pxres;
    vec4 bg_px    = vec4( texture2D( in_front, uv ).rgb, texture2D( in_matte, uv ).g );

    vec2  box_uv  = (gl_FragCoord.xy - offset_xy) / pxres * 2.0 - 1.0;
    float aspect  = pxres.x / pxres.y;
    box_uv.x     *= aspect;

    vec2 size     = box_size * 0.01;     // Turn percentage into UV
    size         -= edge_soft / 2.0;

    // Calculate distance and fill

    float distance       = calc_distance( box_uv, size, (corner_rad * 0.01) );
    float smoothed_alpha = 1.0 - smoothstep( 0.0, edge_soft, distance );
    float border_alpha   = 1.0 - smoothstep( border_size - edge_soft, border_size, abs(distance) );
    float outalpha       = mix( 0.0, mix( 0.0, 1.0, border_alpha ), smoothed_alpha );

    // Comp everything together

    if( mask_fg == true ) {

        if( premult == true ) {
            gl_FragColor = mix( vec4(0.0,0.0,0.0,0.0), vec4( bg_px.rgb, 1.0 ), outalpha );
        }
        else {
            gl_FragColor = vec4( bg_px.rgb, outalpha );
        }
    }
    else {
        gl_FragColor = mix( bg_px, vec4( box_color, 1.0 ), outalpha );
    }
}
