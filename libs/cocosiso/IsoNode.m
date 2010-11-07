//
//  IsoNode.m
//
//  Created by Ryan Williams on 21/08/10.
//  Copyright 2010 Ryan Williams. All rights reserved.
//

#import "IsoNode.h"


@implementation IsoNode

@synthesize box=_box, scaleZ=scaleZ_, dirty=_dirty, solid=_solid;

- (id)init
{
	if ((self = [super init])) {
		scaleZ_ = 1;
		_box = b3d(0, 0, 0, 32, 32, 32);
		_solid = YES;
	}
	return self;
}

- (void)setIsoPosition:(Point3D)p
{
	_box.origin = p;
}

- (Point3D)isoPosition
{
	return _box.origin;
}


- (void)setScale:(float)s
{
	[super setScale:s];
	[self setScaleZ:s];
}

@end
