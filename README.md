MTPencil
========

A library for animated line drawing (like an invisible pencil). Allows you to declare a series of drawing steps, set the speed (points per second) and then tell it to start drawing.
I'm just getting started on this library so it's very basic right now. More awesomeness to come.

### Installation

In your Podfile, add this line:

    pod "MTPencil"

pod? => https://github.com/CocoaPods/CocoaPods/

NOTE: You may need to add `-all_load` to "Other Linker Flags" in your targets build settings if the pods library only contains categories.

### Example Usage

Here we create a pencil object, telling it what view to draw in. Then, we define a series of moving or drawing steps, all starting where the last one left off, then you tell it to begin drawing.

	@interface MTTestView ()
	@property (strong) MTPencil *pencil;
	@end
	
	@implementation MTTestView
	
	- (void)drawPicture
	{
	    MTPencilSpeed speed = MTPencilSpeedVerySlow;
		
		_pencil = [MTPencil pencilWithView:self.view];
	    [[[_pencil config] delay:0.25] strokeColor:[UIColor darkGrayColor]];
		[[[_pencil stroke] angle:MTPencilStepAngleUpRight  distance:20]  speed:speed];
		[[[_pencil stroke] angle:MTPencilStepAngleUp       distance:50]  speed:speed];
		[[[_pencil stroke] angle:MTPencilStepAngleRight    distance:100] speed:speed];
		[[[_pencil stroke] angle:MTPencilStepAngleDown     distance:200] speed:speed];
		[[[_pencil stroke] angle:MTPencilStepAngleLeft     distance:100] speed:speed];
		[[[_pencil stroke] angle:MTPencilStepAngleUp       distance:123] speed:speed];
		[[[_pencil stroke] angle:MTPencilStepAngleUpLeft   distance:20]  speed:speed];
		[[[_pencil stroke] to:CGPointMake(200, 200)]                     speed:speed];
		[_pencil beginWithCompletion:^(MTPencil *pencil) {
	    }];
	}
	
	@end

Using relative directions and to edges:

	_pencil = [MTPencil pencilWithView:self.view];

	[[[[_pencil move] to:CGPointMake(100, 200)] speed:300] width:1];
    [[_pencil draw] angle:-20 distance:100];
    [[_pencil draw] up:20];
    [[_pencil draw] right:50];
    [[_pencil draw] down:20];
    [[_pencil draw] left:20];
    [[_pencil draw] toEdge:UIRectEdgeRight];
    [[[_pencil draw] toEdge:UIRectEdgeBottom] inset:5];
    [[[_pencil draw] toEdge:UIRectEdgeLeft] inset:10];
    [[[_pencil draw] toEdge:UIRectEdgeTop] inset:10];
    [[_pencil draw] toEdge:UIRectEdgeRight];

Draw any CGPath:

	_pencil = [MTPencil pencilWithView:self.view];

    CGRect frame = CGRectMake(0, 90, 290, 289);
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 111.5, CGRectGetMinY(frame) + 178.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 47.5, CGRectGetMinY(frame) + 127.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 84.5, CGRectGetMinY(frame) + 179.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 47.5, CGRectGetMinY(frame) + 127.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 67.5, CGRectGetMinY(frame) + 81.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 47.5, CGRectGetMinY(frame) + 127.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 35.32, CGRectGetMinY(frame) + 21.56)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 120.5, CGRectGetMinY(frame) + 108.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 99.68, CGRectGetMinY(frame) + 141.44) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.56, CGRectGetMinY(frame) + 160.44)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 137.5, CGRectGetMinY(frame) + 36.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 100.44, CGRectGetMinY(frame) + 56.56) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 108.58, CGRectGetMinY(frame) - 41.99)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 202.5, CGRectGetMinY(frame) + 253.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 166.42, CGRectGetMinY(frame) + 114.99) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 193.71, CGRectGetMinY(frame) + 361.46)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 166.5, CGRectGetMinY(frame) + 84.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 211.29, CGRectGetMinY(frame) + 145.54) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 141.25, CGRectGetMinY(frame) + 87.96)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 191.5, CGRectGetMinY(frame) + 29.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 191.75, CGRectGetMinY(frame) + 81.04) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 217.32, CGRectGetMinY(frame) + 35.41)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 247.5, CGRectGetMinY(frame) + 16.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 165.68, CGRectGetMinY(frame) + 23.59) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 253.95, CGRectGetMinY(frame) + 2.74)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 198.5, CGRectGetMinY(frame) + 90.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 241.05, CGRectGetMinY(frame) + 30.26) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 199.96, CGRectGetMinY(frame) + 46.94)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 217.5, CGRectGetMinY(frame) + 255.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 197.04, CGRectGetMinY(frame) + 134.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 217.08, CGRectGetMinY(frame) + 247.94)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 273.5, CGRectGetMinY(frame) + 144.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 217.92, CGRectGetMinY(frame) + 263.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 302.26, CGRectGetMinY(frame) + 183.11)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 240.5, CGRectGetMinY(frame) + 169.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 244.74, CGRectGetMinY(frame) + 105.89) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 240.5, CGRectGetMinY(frame) + 169.5)];

    [[[_pencil draw] path:bezierPath.CGPath] duration:5];

Draw a string of text:

	_pencil = [MTPencil pencilWithView:self.view];
    [[_pencil move] to:CGPointMake(10, 100)];
    [[[[_pencil draw] string:@"Mysterious\nTrousers"] font:[UIFont systemFontOfSize:60]] duration:3];

Scrub the drawing of an entire series of pencil steps:

	- (IBAction)scrubSliderDidChange:(UISlider *)sender
	{
    	[_pencil scrub:sender.value];
	}
	
Use jQuery easing functions to make your drawing feel a little more natural:

	_pencil = [MTPencil pencilWithView:self.view];
    [[_pencil config] easingFunction:kMTPencilEaseOutExpo];
    [[_pencil config] duration:1.0];
	[[_pencil move] to:CGPointMake(100, 150)];
	[[[_pencil draw] angle:MTPencilStepAngleUpRight    distance:20]     easingFunction:kMTPencilEaseOutBounce];
	[[[_pencil draw] angle:MTPencilStepAngleUp         distance:50]     easingFunction:kMTPencilEaseInExpo];
	[[[_pencil draw] angle:MTPencilStepAngleRight      distance:100]	easingFunction:kMTPencilEaseInOutExpo];
    [[[_pencil draw] angle:MTPencilStepAngleDown       distance:200]	easingFunction:kMTPencilEaseInBounce];
	[[[_pencil draw] angle:MTPencilStepAngleLeft       distance:100]	easingFunction:kMTPencilEaseOutElastic];
	[[[_pencil draw] angle:MTPencilStepAngleUp         distance:123]	easingFunction:kMTPencilEaseInOutExpo];
	[[[_pencil draw] angle:MTPencilStepAngleUpLeft     distance:20]     easingFunction:kMTPencilEaseLinear];