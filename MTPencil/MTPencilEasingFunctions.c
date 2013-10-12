//
//  MTPencilEasingFunctions.c
//  NSBKeyframeAnimation
//
//  Created by Nacho Soto on 8/6/12.
//  Copyright (c) 2012 Nacho Soto. All rights reserved.
//

#include <math.h>
#include <stdlib.h>

#import "MTPencilEasingFunctions.h"

// source: http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
// t: current time, b: begInnIng value, c: change In value, d: duration

// TODO: Apply exaggeration to everything. (currently only applied to some).

double MTPencilEasingFunctionEaseLinear(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t + b;
}

double MTPencilEasingFunctionEaseInQuad(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t*t + b;
}

double MTPencilEasingFunctionEaseOutQuad(double t, double b, double c, double d, double s)
{
    t/=d;
    return -c *t*(t-2) + b;
}

double MTPencilEasingFunctionEaseInOutQuad(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    if (t < 1) return c/2*t*t + b;
    --t;
    return -c/2 * (t*(t-2) - 1) + b;
}

double MTPencilEasingFunctionEaseInCubic(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t*t*t + b;
}

double MTPencilEasingFunctionEaseOutCubic(double t, double b, double c, double d, double s)
{
    t=t/d-1;
    return c*(t*t*t + 1) + b;
}

double MTPencilEasingFunctionEaseInOutCubic(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    if (t < 1) return c/2*t*t*t + b;
    t-=2;
    return c/2*(t*t*t + 2) + b;
}

double MTPencilEasingFunctionEaseInQuart(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t*t*t*t + b;
}

double MTPencilEasingFunctionEaseOutQuart(double t, double b, double c, double d, double s)
{
    t=t/d-1;
    return -c * (t*t*t*t - 1) + b;
}

double MTPencilEasingFunctionEaseInOutQuart(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    if (t < 1) return c/2*t*t*t*t + b;
    t-=2;
    return -c/2 * (t*t*t*t - 2) + b;
}

double MTPencilEasingFunctionEaseInQuint(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t*t*t*t*t + b;
}

double MTPencilEasingFunctionEaseOutQuint(double t, double b, double c, double d, double s)
{
    t=t/d-1;
    return c*(t*t*t*t*t + 1) + b;
}

double MTPencilEasingFunctionEaseInOutQuint(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    if (t < 1) return c/2*t*t*t*t*t + b;
    t-=2;
    return c/2*(t*t*t*t*t + 2) + b;
}

double MTPencilEasingFunctionEaseInSine(double t, double b, double c, double d, double s)
{
    return -c * cos(t/d * (M_PI_2)) + c + b;
}

double MTPencilEasingFunctionEaseOutSine(double t, double b, double c, double d, double s)
{
    return c * sin(t/d * (M_PI_2)) + b;
}

double MTPencilEasingFunctionEaseInOutSine(double t, double b, double c, double d, double s)
{
    return -c/2 * (cos(M_PI*t/d) - 1) + b;
}

double MTPencilEasingFunctionEaseInExpo(double t, double b, double c, double d, double s)
{
    return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
}

double MTPencilEasingFunctionEaseOutExpo(double t, double b, double c, double d, double s)
{
    return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b;
}

double MTPencilEasingFunctionEaseInOutExpo(double t, double b, double c, double d, double s)
{
    if (t==0) return b;
    if (t==d) return b+c;
    t/=(d/2);
    if (t < 1) return c/2 * pow(2, 10 * (t - 1)) + b;
    --t;
    return c/2 * (-pow(2, -10 * t) + 2) + b;
}

double MTPencilEasingFunctionEaseInCirc(double t, double b, double c, double d, double s)
{
    t/=d;
    return -c * (sqrt(1 - t*t) - 1) + b;
}

double MTPencilEasingFunctionEaseOutCirc(double t, double b, double c, double d, double s)
{
    t=t/d-1;
    return c * sqrt(1 - t*t) + b;
}

double MTPencilEasingFunctionEaseInOutCirc(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    if (t < 1) return -c/2 * (sqrt(1 - t*t) - 1) + b;
    t-=2;
    return c/2 * (sqrt(1 - t*t) + 1) + b;
}

double MTPencilEasingFunctionEaseInElastic(double t, double b, double c, double d, double s)
{
    double p=0; double a=c;

    t/=d;
    if (t==0) return b;  if (t==1) return b+c;  if (!p) p=d*.3;
    if (a < abs(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    t-=1;
    return -(a*pow(2,10*t) * sin( (t*d-s)*(2*M_PI)/p )) + b;
}

double MTPencilEasingFunctionEaseOutElastic(double t, double b, double c, double d, double s)
{
    double p=0, a=c;
    t/=d;
    if (t==0) return b;  if (t==1) return b+c;  if (!p) p=d*.3;
    if (a < abs(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b;
}

double MTPencilEasingFunctionEaseInOutElastic(double t, double b, double c, double d, double s)
{
    double p=0, a=c;
    t/=(d/2);
    if (t==0) return b;  if (t==2) return b+c;  if (!p) p=d*(.3*1.5);
    if (a < abs(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin(c/a);
    if (t < 1) {
        t-=1;
        return -.5*(a*pow(2,10*t) * sin( (t*d-s)*(2*M_PI)/p )) + b;
    }
    t-=1;
    return a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p )*.5 + c + b;
}

double MTPencilEasingFunctionEaseInBack(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t*t*((s+1)*t - s) + b;
}

double MTPencilEasingFunctionEaseOutBack(double t, double b, double c, double d, double s)
{
    t=t/d-1;
    return c*(t*t*((s+1)*t + s) + 1) + b;
}

double MTPencilEasingFunctionEaseInOutBack(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    s*=(1.525);
    if (t < 1) return c/2*(t*t*((s+1)*t - s)) + b;
    t-=2;
    return c/2*(t*t*((s+1)*t + s) + 2) + b;
}

double MTPencilEasingFunctionEaseInBounce(double t, double b, double c, double d, double s)
{
    return c - MTPencilEasingFunctionEaseOutBounce(d-t, 0, c, d, s) + b;
}

double MTPencilEasingFunctionEaseOutBounce(double t, double b, double c, double d, double s)
{
    t/=d;
    if (t < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        t-=(1.5/2.75);
        return c*(7.5625*t*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        t-=(2.25/2.75);
        return c*(7.5625*t*t + .9375) + b;
    } else {
        t-=(2.625/2.75);
        return c*(7.5625*t*t + .984375) + b;
    }
}

double MTPencilEasingFunctionEaseInOutBounce(double t, double b, double c, double d, double s)
{
    if (t < d/2)
        return MTPencilEasingFunctionEaseInBounce (t*2, 0, c, d, s) * .5 + b;
    else
        return MTPencilEasingFunctionEaseOutBounce(t*2-d, 0, c, d, s) * .5 + c*.5 + b;
}
