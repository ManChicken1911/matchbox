// Zippy Zaps by SnoopethDuckDuck - https://www.shadertoy.com/view/XXyGzh
// Adapted from Shadertoy to Flame by Bob Maple
// Version 20241211
//
// Note: Doesn't really work right on Mac, I have no idea why and no
// real means to figure it out at the moment

#version 130

uniform float adsk_time;
uniform float adsk_result_w, adsk_result_h;

uniform float red_bias, green_bias, blue_bias, speed_fps, time_offset, clamp_min, clamp_max;
uniform bool  clamp_enable;

void main( void )
{
  // FragColor and FragCoord come in to Shadertoy as the first
  // two arguments to main() so we hotwire those here

    vec4 o;
    vec2 u = gl_FragCoord.xy;

  // Shadertoy iTime is in seconds (adsk_time is in frames)
  // and runs at 60fps ideally

    float iTime = ((1.0 / speed_fps) * (adsk_time-1.0)) + time_offset;

  // Shadertoy iResolution.xy

    vec2 v = vec2( adsk_result_w, adsk_result_h );

    vec2 w = u = 0.2*(u+u-v)/v.y;
    vec4 z = o = vec4(red_bias, green_bias, blue_bias, 0.0);
     
    for( float a = 0.5, t = iTime, i = 0.0; ++i < 19.0; ) {
  
        v = cos(++t - 7.0*u*pow(a += 0.03, i)) - 5.0*u;
        u *= mat2(cos(i + 0.02*t - vec4(0.0, 11.0, 33.0, 0.0)));
        u += tanh(40.0*dot(u,u)*cos(100.0*u.yx + t)) / 200.0 + 0.2 * a * u + cos(4.0/exp(dot(o,o)/100.0) + t) / 300.0;
        o += (1.0 + cos(z+t)) / length((1.0+i*dot(v,v)) * sin(1.5*u/(0.5-dot(u,u)) - 9.0*u.yx + t));
    }
              
    o = pow(1.0-sqrt(exp(-o*o*o/200.0)), 0.3*z/z) - dot(w-=u,w) / 250.0;

    gl_FragColor = clamp_enable ? clamp( o, clamp_min, clamp_max ) : o;
}
