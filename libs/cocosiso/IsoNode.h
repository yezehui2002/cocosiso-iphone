//
//  IsoNode.h
//
//  Created by Ryan Williams on 21/08/10.
//  Copyright 2010 Ryan Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Geometry3D.h"

@interface IsoNode : CCNode {
	Box3D _box; // It's position and size in 3D space
	float scaleZ_;
	
	// If dirty then the IsoLayer will memcpy the verticies
	BOOL _dirty;
	
	BOOL _solid;
}

@property (readonly) Box3D box;
@property (assign, getter=isDirty) BOOL dirty;
@property (assign) float scaleZ;
@property (assign, getter=isSolid) BOOL solid;


- (void)setIsoPosition:(Point3D)p;
- (Point3D)isoPosition;

@end
