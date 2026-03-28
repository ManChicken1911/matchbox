// id_Solid by Bob Maple
// https://github.com/ManChicken1911/matchbox
// Version 2026.03.27


uniform	vec3    	solid_color;
uniform bool        matte_passthru;
uniform float       adsk_result_w, adsk_result_h;
uniform sampler2D   in_matte;

//

void main(void) {

    float matte  = (matte_passthru == true) ? texture2D( in_matte, gl_FragCoord.xy / vec2(adsk_result_w, adsk_result_h) ).g : 1.0;
    gl_FragColor = vec4( solid_color, matte );
}
