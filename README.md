MTPencil
========

A library for animated line drawing (like an invisible pencil). Allows you to declare a series of drawing steps, set the speed (points per second) and then tell it to start drawing.

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
		
		_pencil = [MTPencil pencilDrawingInView:self];
		
		[_pencil moveTo:CGPointMake(100, 100)];
		[_pencil drawAtAngle:MTPencilAngleUpRight	distance:20     speed:speed];
		[_pencil drawAtAngle:MTPencilAngleUp		distance:50     speed:speed];
		[_pencil drawAtAngle:MTPencilAngleRight		distance:100	speed:speed];
		[_pencil drawAtAngle:MTPencilAngleDown		distance:200	speed:speed];
		[_pencil drawAtAngle:MTPencilAngleLeft		distance:100	speed:speed];
		[_pencil drawAtAngle:MTPencilAngleUp		distance:123	speed:speed];
		[_pencil drawAtAngle:MTPencilAngleUpLeft	distance:20     speed:speed];
		[_pencil beginWithCompletion:^(MTPencil *pencil) {
	    }];
	}
	
	- (void)drawRect:(CGRect)rect
	{
		[_pencil animate];
	}
	
	@end

NOTE: You must call `animate` on the pencil in your view's drawRect:

### Options

You can tell the pencil to draw at any degree (ie 143), but here are some predefined enums to help out:

	MTPencilAngleUp			= -90
	MTPencilAngleDown		= 90
	MTPencilAngleLeft		= 180
	MTPencilAngleRight		= 0
	MTPencilAngleUpRight	= -45
	MTPencilAngleUpLeft		= -135
	MTPencilAngleDownRight	= 45
	MTPencilAngleDownLeft	= 135

You can tell it to draw at any speed in points per second (PPS), or you can use some defaults:

	MTPencilSpeedVerySlow   = 100
    MTPencilSpeedSlow       = 400
    MTPencilSpeedMedium     = 600
    MTPencilSpeedFast       = 800
    MTPencilSpeedVeryFast   = 1000

