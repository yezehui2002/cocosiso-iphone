/*
 *  IsoTileset.m
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

#import "IsoTileset.h"
#import "NSDictionary_JSONExtensions.h"

@interface IsoTileset (Private)

- (void)parseTilesetFile:(NSString*)filename;

@end


@implementation IsoTileset

@synthesize texture=_texture;

+ (id)tilesetWithFileNamed:(NSString*)filename
{
	return [[[self alloc] initWithFileNamed:filename] autorelease];
}
- (id)initWithFileNamed:(NSString*)filename
{
    if ((self = [super init])) {
		[self parseTilesetFile:filename];
    }
    return self;
}


- (void)parseTilesetFile:(NSString*)filename
{
	NSError *error = nil;
	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:nil]];
	NSDictionary *dict = [NSDictionary dictionaryWithJSONData:data error:&error];
	
	NSString *imageFile = [dict valueForKey:@"image"];
	NSArray *tileList = [dict valueForKey:@"tiles"];
	_tileProperties = [[NSMutableArray alloc] initWithCapacity:[tileList count]];
	
	// Add texture
	_texture = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:imageFile]];
	[_texture setAliasTexParameters];
	
	// Allocate memory for our tile list
	_tiles = malloc(sizeof(IsoTile) * [tileList count]);
	
	int i = 0;
	CGRect r;
	NSUInteger o;
	NSArray *rect;
	for (NSDictionary *tileInfo in tileList) {
		rect = [tileInfo valueForKey:@"rect"];
		o = [[tileInfo valueForKey:@"origin"] integerValue];
		r = CGRectMake(
                [[rect objectAtIndex:0] floatValue],
                [[rect objectAtIndex:1] floatValue],
                [[rect objectAtIndex:2] floatValue],
                [[rect objectAtIndex:3] floatValue]
            );
		
		[_tileProperties addObject:[tileInfo valueForKey:@"properties"]];
		_tiles[i++] = (IsoTile) { r, o };
	}
	
}

- (IsoTile)tileAtIndex:(NSUInteger)idx
{
	return _tiles[idx];
}

- (NSDictionary*)tilePropertiesAtIndex:(NSUInteger)idx
{
	return [_tileProperties objectAtIndex:idx];
}


- (void)dealloc
{
	free(_tiles);
	[_tileProperties release];
	[_texture release];
	[super dealloc];
}


@end
