//
//  HelloWorldLayer.m
//  cocosiso
//
//  Created by Ryan Williams on 7/11/10.
//  Copyright Ryan Williams 2010. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "IsoMap.h"

// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {

		// Load an isometric map
		IsoMap *map = [IsoMap mapWithFile:@"maps/example.map"];
		//[map setPosition:ccp(32, 128)];
		
		// Add map to the view
		[self addChild:map];
		
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
