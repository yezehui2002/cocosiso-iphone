//
//  IsoMap.m
//
//  Created by Ryan Williams on 15/08/10.
//  Copyright 2010 Ryan Williams All rights reserved.
//

#import "IsoMap.h"
#import "NSDictionary_JSONExtensions.h"
#import "IsoLayer.h"
#import "Geometry3D.h"
#import "IsoTileset.h"
#import "IsoSprite.h"

@implementation IsoMap

@synthesize useRenderTexture=_useRenderTexture;

+ (id)mapWithFile:(NSString*)filename
{
    return [[[self alloc] initWithFile:filename] autorelease];
}

- (id)initWithFile:(NSString*)filename
{
	if ((self = [self init])) {
		
//		_renderTexture = [[CCRenderTexture alloc] initWithWidth:480 height:320];
//		[[[_renderTexture sprite] texture] setAliasTexParameters];
//		[_renderTexture setPosition:ccp(240, 160)];
//		[self addChild:_renderTexture];
		
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:nil]];
        NSDictionary *dict = [NSDictionary dictionaryWithJSONData:data error:&error];
		
		_layers = [[NSMutableArray alloc] initWithCapacity:[[dict valueForKey:@"layers"] count]];
		
		IsoLayer *layer;
		IsoSprite *s;
		Point3D p;
		IsoTileset *tileset;
		for (NSDictionary *l in [dict valueForKey:@"layers"]) {
			tileset = [IsoTileset tilesetWithFileNamed:[l valueForKey:@"tileset"]];
			layer = [IsoLayer layerWithTileset:tileset];
			
			
			// Add tiles to layer
			for (NSDictionary *t in [l valueForKey:@"tiles"]) {
				NSUInteger idx = [[t valueForKey:@"id"] integerValue];
				NSArray *coords = [t objectForKey:@"position"];
				p = p3d([[coords objectAtIndex:0] floatValue], [[coords objectAtIndex:1] floatValue], [[coords objectAtIndex:2] floatValue]);

				NSDictionary *tileProperties = [tileset tilePropertiesAtIndex:idx];

				// Create node using class specified in .tileset file, or use IsoSprite if none specified
				NSString *className = [tileProperties objectForKey:@"class"];
				className = className ? className : @"IsoSprite";
				
				Class IsoClass = NSClassFromString(className);
				
				s = [[IsoClass alloc] initWithIsoLayer:layer tileIndex:idx];
				[s setIsoPosition:p];
				[layer addChild:s];
				[s release];
			}
			
			// Add layer to map
			[self addChild:layer];
			//[_layers addObject:layer];
			[layer setPosition:ccp(0,132)];
		}
		
		//[self scheduleUpdate];
	}
	return self;
	
}

- (void)update:(ccTime)dt
{
	[_renderTexture begin];
	glEnable(GL_DEPTH_TEST);

	for (CCNode *l in _layers) {
		[l visit];
	}
	[_renderTexture end];
}

- (void)dealloc
{
	[_layers release];
	[_renderTexture release];
	[super dealloc];
}

@end
