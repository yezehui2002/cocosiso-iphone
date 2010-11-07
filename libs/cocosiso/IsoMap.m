/*
 *  IsoMap.m
 *
 * Copyright (c) 2010 Ryan Williams
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

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
