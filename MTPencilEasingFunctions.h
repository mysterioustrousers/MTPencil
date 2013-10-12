//
//  MTPencilEasingFunctions.h
//  NSBKeyframeAnimation
//
//  Created by Nacho Soto on 8/6/12.
//  Copyright (c) 2012 Nacho Soto. All rights reserved.
//


typedef double (*MTPencilEasingFunction)(double, double, double, double, double);

double MTPencilEasingFunctionEaseLinear(double t, double b, double c, double d, double s);

double MTPencilEasingFunctionEaseInQuad(double t, double b, double c, double d, double s);
double MTPencilEasingFunctionEaseOutQuad(double t, double b, double c, double d, double s);
double MTPencilEasingFunctionEaseInOutQuad(double t, double b, double c, double d, double s);

double MTPencilEasingFunctionEaseInCubic(double t, double b, double c, double d, double s);
double MTPencilEasingFunctionEaseOutCubic(double t, double b, double c, double d, double s);
double MTPencilEasingFunctionEaseInOutCubic(double t,double b, double c, double d, double s);

double MTPencilEasingFunctionEaseInQuart(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseOutQuart(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseInOutQuart(double t,double b, double c, double d, double s);

double MTPencilEasingFunctionEaseInQuint(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseOutQuint(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseInOutQuint(double t,double b, double c, double d, double s);

double MTPencilEasingFunctionEaseInSine(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseOutSine(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseInOutSine(double t,double b, double c, double d, double s);

double MTPencilEasingFunctionEaseInExpo(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseOutExpo(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseInOutExpo(double t,double b, double c, double d, double s);

double MTPencilEasingFunctionEaseInCirc(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseOutCirc(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseInOutCirc(double t,double b, double c, double d, double s);

double MTPencilEasingFunctionEaseInElastic(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseOutElastic(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseInOutElastic(double t,double b, double c, double d, double s);

double MTPencilEasingFunctionEaseInBack(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseOutBack(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseInOutBack(double t,double b, double c, double d, double s);

double MTPencilEasingFunctionEaseInBounce(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseOutBounce(double t,double b, double c, double d, double s);
double MTPencilEasingFunctionEaseInOutBounce(double t,double b, double c, double d, double s);







#define kMTPencilEaseLinear      	&MTPencilEasingFunctionEaseLinear
#define kMTPencilEaseInQuad      	&MTPencilEasingFunctionEaseInQuad
#define kMTPencilEaseOutQuad     	&MTPencilEasingFunctionEaseOutQuad
#define kMTPencilEaseInOutQuad   	&MTPencilEasingFunctionEaseInOutQuad
#define kMTPencilEaseInCubic     	&MTPencilEasingFunctionEaseInCubic
#define kMTPencilEaseOutCubic    	&MTPencilEasingFunctionEaseOutCubic
#define kMTPencilEaseInOutCubic  	&MTPencilEasingFunctionEaseInOutCubic
#define kMTPencilEaseInQuart     	&MTPencilEasingFunctionEaseInQuart
#define kMTPencilEaseOutQuart    	&MTPencilEasingFunctionEaseOutQuart
#define kMTPencilEaseInOutQuart  	&MTPencilEasingFunctionEaseInOutQuart
#define kMTPencilEaseInQuint     	&MTPencilEasingFunctionEaseInQuint
#define kMTPencilEaseOutQuint    	&MTPencilEasingFunctionEaseOutQuint
#define kMTPencilEaseInOutQuint  	&MTPencilEasingFunctionEaseInOutQuint
#define kMTPencilEaseInSine      	&MTPencilEasingFunctionEaseInSine
#define kMTPencilEaseOutSine     	&MTPencilEasingFunctionEaseOutSine
#define kMTPencilEaseInOutSine   	&MTPencilEasingFunctionEaseInOutSine
#define kMTPencilEaseInExpo      	&MTPencilEasingFunctionEaseInExpo
#define kMTPencilEaseOutExpo     	&MTPencilEasingFunctionEaseOutExpo
#define kMTPencilEaseInOutExpo   	&MTPencilEasingFunctionEaseInOutExpo
#define kMTPencilEaseInCirc      	&MTPencilEasingFunctionEaseInCirc
#define kMTPencilEaseOutCirc     	&MTPencilEasingFunctionEaseOutCirc
#define kMTPencilEaseInOutCirc   	&MTPencilEasingFunctionEaseInOutCirc
#define kMTPencilEaseInElastic   	&MTPencilEasingFunctionEaseInElastic
#define kMTPencilEaseOutElastic  	&MTPencilEasingFunctionEaseOutElastic
#define kMTPencilEaseInOutElastic	&MTPencilEasingFunctionEaseInOutElastic
#define kMTPencilEaseInBack      	&MTPencilEasingFunctionEaseInBack
#define kMTPencilEaseOutBack     	&MTPencilEasingFunctionEaseOutBack
#define kMTPencilEaseInOutBack   	&MTPencilEasingFunctionEaseInOutBack
#define kMTPencilEaseInBounce    	&MTPencilEasingFunctionEaseInBounce
#define kMTPencilEaseOutBounce   	&MTPencilEasingFunctionEaseOutBounce
#define kMTPencilEaseInOutBounce 	&MTPencilEasingFunctionEaseInOutBounce
