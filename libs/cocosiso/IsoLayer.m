/*
 *  IsoLayer.m
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

#import "IsoLayer.h"
#import "IsoSprite.h"
#import "IsoTileset.h"
#import "NSDictionary_JSONExtensions.h"

@interface IsoLayer (Private)

- (void)parseTilesetFile:(NSString *)filename;
- (void)updateBlocks;
- (void)updateBlocks:(BOOL)force;

@end

@implementation IsoLayer

@synthesize tileset=_tileset, texture=_texture;

+ (id)layerWithTileset:(IsoTileset*)tileset
{
	return [[[self alloc] initWithTileset:tileset] autorelease];
}

- (id)initWithTileset:(IsoTileset*)tileset
{
    if ((self = [super init])) {
		_tileset = [tileset retain];
		
		NSUInteger defaultCapacity = 32;
		
        // 1 block = 3 quads = 6 triangles = 18 verts = 54 floats. Start with room for 32 blocks
        _blockVerticies = GLfloatArrayNew(54 * defaultCapacity); //malloc(sizeof(GLfloat) * 54 * _capacity);
		
        // Texture is the same as above but only 2 coords per vert
        _textureCoords = GLfloatArrayNew(36 * defaultCapacity); //malloc(sizeof(GLfloat) * 36 * _capacity);
		
		_blockOffsets = [[CCArray alloc] initWithCapacity:defaultCapacity];
		
		_texture = [tileset texture]; // weak ref
		[self scheduleUpdate];
		
    }
    return self;
}


- (void)addChild:(CCNode *)child
{
	NSAssert( child != nil, @"Argument must be non-nil");
	NSAssert( [child isKindOfClass:[IsoNode class]], @"IsoLayer only supports IsoNode as children");
	
	if ([child visible]) {
		GLfloatArray *v = [(IsoSprite*)child verticies];
		GLfloatArray *t = [(IsoSprite*)child textureCoords];
		
		[_blockOffsets addObject:[NSNumber numberWithInt:(_blockVerticies->num)/3]];
		
		GLfloatArrayAppendArrayWithResize(_blockVerticies, v);
		GLfloatArrayAppendArrayWithResize(_textureCoords, t);
	} else {
		[_blockOffsets addObject:[NSNumber numberWithInt:0]];
	}
	
	[super addChild:child];
}

- (void)updateBlock:(NSUInteger)idx
{
	IsoSprite *s = [children_ objectAtIndex:idx];
	
	// TODO supports removing tiles that were previously visible
	if ([s visible]) {
		GLfloatArray *v = [s verticies];
		GLfloatArray *t = [s textureCoords];
		
		NSUInteger offset = [[_blockOffsets objectAtIndex:idx] integerValue];

		memcpy(_blockVerticies->arr + (offset *3), v->arr, v->num * sizeof(GLfloat));
		memcpy(_textureCoords->arr + (offset *2), t->arr, t->num * sizeof(GLfloat));
	}
}

- (void)removeChild:(CCNode *)node cleanup:(BOOL)cleanup
{
	//NSAssert(NO, @"remove child not implemented yet");
	
	[super removeChild:node cleanup:cleanup];
}

- (void)update:(ccTime)dt
{
	int i = 0;
	for (IsoSprite *child in children_) {
		if ([child isDirty]) {
			[self updateBlock:i];
			[child setDirty:NO];
		}
		
		i++;
	}
}

- (void)draw
{
	
	// Enable depth testing
	glClearDepthf(1.0f);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LEQUAL);
	
	// Enable alpha blending
	glEnable(GL_ALPHA_TEST);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glAlphaFunc(GL_GREATER, 0.1);

	// Disable colour
	glDisableClientState(GL_COLOR_ARRAY);
	
	// Bind the texture
	glBindTexture(GL_TEXTURE_2D, [_texture name]);

	glColor4f(1, 1, 1, 1);
	
	glPushMatrix();
		glVertexPointer(3, GL_FLOAT, 0, _blockVerticies->arr);
		glTexCoordPointer(2, GL_FLOAT, 0, _textureCoords->arr);
	
		// Push back a bit so its behind the UI
		glTranslatef(0, 0, -512);
	
		// Rotate view to an isometric angle
		glRotatef(30, 1, 0, 0);
		glRotatef(-45, 0, 1, 0);
	
		glDrawArrays(GL_TRIANGLES, 0, _blockVerticies->num/3);
	glPopMatrix();
	
	// Reset the stuff we enabled
	glDisable(GL_ALPHA_TEST);
	glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[_blockOffsets release];
    GLfloatArrayFree(_blockVerticies);
    GLfloatArrayFree(_textureCoords);
	[_tileset release];
    [_blocks release];
    [super dealloc];
}

- (BOOL)collidesWithNode:(IsoNode*)node
{
    Box3D box = [node box];
    for (IsoNode *n in [self children]) {
		if (n == node) {
			continue;
		}
		
		if ([n isSolid] && Box3DIntersectsBox3D(box, [n box])) {
            return YES;
        }
    }

    return NO;
}

@end
