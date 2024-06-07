// Zippy Zaps by SnoopethDuckDuck - https://www.shadertoy.com/view/XXyGzh
// Adapted from Shadertoy to Flame by Bob Maple
// Version 20240609
//
// Note: Doesn't really work right on Mac, I have no idea why and no
// real means to figure it out

#version 130

uniform float adsk_time;
uniform float adsk_result_w, adsk_result_h;

uniform float red_bias, green_bias, blue_bias, speed_fps;

void main( void )
{
  // FragColor and FragCoord come in to Shadertoy as the first
  // two arguments to main() so we hotwire those here

    vec4 o;
    vec2 u = gl_FragCoord.xy;

  // Shadertoy iTime is in seconds (adsk_time is in frames)
  // and runs at 60fps ideally

    float iTime = (1.0 / speed_fps) * (adsk_time-1);

  // Shadertoy iResolution.xy

    vec2 v = vec2( adsk_result_w, adsk_result_h );

    vec2 w = u = .2*(u+u-v)/v.y;
    vec4 z = o = vec4(red_bias, green_bias, blue_bias, 0);
     
    for( float a = 0.5, t = iTime, i=0.0; ++i < 19.0; ) {
  
        v = cos(++t - 7.0*u*pow(a += .03, i)) - 5.*u;
        u *= mat2(cos(i + 0.02*t - vec4(0,11,33,0)));
        u += tanh(40.0*dot(u,u)*cos(1e2*u.yx + t)) / 2e2 + 0.2 * a * u + cos(4.0/exp(dot(o,o)/1e2) + t) / 3e2;
        o += (1.0 + cos(z+t)) / length((1.0+i*dot(v,v)) * sin(1.5*u/(.5-dot(u,u)) - 9.*u.yx + t));
    }
              
    o = pow(1.0-sqrt(exp(-o*o*o/2e2)), 0.3*z/z) - dot(w-=u,w) / 250.0;

    gl_FragColor = o;
}
