// id_Splitsville by Bob Maple
// https://github.com/ManChicken1911/matchbox
// Version 2025.08.25

// (V) ▲
//     │
//     │
//     │
//     └───────►
//   0        (U)


uniform     float  adsk_result_w, adsk_result_h;

uniform       int  split_direction;
uniform     float  split_amount;

uniform sampler2D  in_front_a, in_front_b, in_matte_a, in_matte_b;
uniform      vec2  offset_a, offset_b;
uniform      bool  autocenter_a, autocenter_b, swap_ab;

uniform      bool  border;
uniform      vec3  border_color;
uniform     float  border_size;

//

void main(void) {

    vec2    uv, uva, uvb, center_a, center_b;
    float   uv_pos;
    vec4    new_pxl;


    // Calculate an additional offset value if auto-centering is turned on

    if( split_direction == 0 ) {
        center_a = autocenter_a ? vec2( (adsk_result_w / 2) * split_amount / 100, 0.0 ) : vec2( 0,0 );
        center_b = autocenter_b ? vec2( (adsk_result_w / 2) * -(100 - split_amount) / 100, 0.0 ) : vec2( 0,0 );
    }
    else {
        center_a = autocenter_a ? vec2( 0.0, (adsk_result_h / 2) * -split_amount / 100 ) : vec2( 0,0 );
        center_b = autocenter_b ? vec2( 0.0, (adsk_result_h / 2) * (100 - split_amount) / 100 ) : vec2( 0,0 );
    }

    uva = (gl_FragCoord.xy - offset_a - center_a) / vec2( adsk_result_w, adsk_result_h );
    uvb = (gl_FragCoord.xy - offset_b - center_b) / vec2( adsk_result_w, adsk_result_h );

    // Convert pixel-based gl_FragCoord to UV for texture2D and
    // UV position based on which split direction we care about

    uv      = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
    uv_pos  = (split_direction == 0) ? uv.x : (1.0 - uv.y);

    // Draw the splitscreen, swap A and B inputs if enabled

    if( swap_ab ) {
        new_pxl   = (uv_pos <= (split_amount / 100)) ? texture2D( in_front_a, uvb ) : texture2D( in_front_b, uva );
        new_pxl.a = (uv_pos <= (split_amount / 100)) ? texture2D( in_matte_a, uvb ).g : texture2D( in_matte_b, uva ).g;
    }
    else {
        new_pxl   = (uv_pos <= (split_amount / 100)) ? texture2D( in_front_b, uvb ) : texture2D( in_front_a, uva );
        new_pxl.a = (uv_pos <= (split_amount / 100)) ? texture2D( in_matte_b, uvb ).g : texture2D( in_matte_a, uva ).g;
    }

    // Draw border if enabled, but don't draw it if we're at 0% or 100%

    if( border && (split_amount > 0 && split_amount < 100) ) {

        float uvwidth = split_direction == 0 ? border_size / adsk_result_w : border_size / adsk_result_h;

        if( uv_pos < (split_amount / 100) + (uvwidth / 2) && uv_pos > (split_amount / 100) - (uvwidth / 2) ) {
            new_pxl = vec4( border_color, 1.0 );
        }
    }

    // Output the result

    gl_FragColor = new_pxl;
}
