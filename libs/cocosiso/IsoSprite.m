//
//  IsoSprite.m
//
//  Created by Ryan Williams on 14/08/10.
//  Copyright 2010 Ryan Williams All rights reserved.
//

#import "IsoSprite.h"
#import "IsoLayer.h"


@implementation IsoSprite

@synthesize verticies=_verticies, textureCoords=_textureCoords;

- (id)initWithIsoLayer:(IsoLayer*)layer tileIndex:(NSUInteger)idx
{
	if ((self = [super init])) {
		_tile = [[layer tileset] tileAtIndex:idx];
        _layer = layer; // Weak ref
		
		NSDictionary *tileProperties = [[layer tileset] tilePropertiesAtIndex:idx];
		
		if ([tileProperties objectForKey:@"hidden"]) {
			[self setVisible:![[tileProperties objectForKey:@"hidden"] boolValue]];
		}
		
		if ([tileProperties objectForKey:@"solid"]) {
			[self setSolid:[[tileProperties objectForKey:@"solid"] boolValue]];
		}
		
		// 1 block = 3 quads = 6 triangles = 18 verts = 54 floats
		_verticies = GLfloatArrayNew(54); //malloc(sizeof(GLfloat) * 54);
		// Texture is the same as above but only 2 coords per vert
        _textureCoords = GLfloatArrayNew(36); //malloc(sizeof(GLfloat) * 36);
		
		[self setDirty:YES];
		
		
		// Calculate actualy 3D block size
		CGSize s = _tile.rect.size;
		
		float isoWidth = _tile.origin;   // A
        float isoDepth = s.width - isoWidth;   // B
        float nearX = isoDepth/2;      // D
        float farX = isoWidth/2;         // C
        float isoHeight = s.height - farX - nearX;    // E
        
        _box.origin = (Point3D){ 0, 0, 0 };
        _box.size = (Size3D){ isoWidth, isoDepth, isoHeight };

		
		
		// Calculate 3D box size with margin
		
		// Margin is used to compensate for differences in polygon edges depending on the pixel it's drawn at
		_margin = 0;
		
		// Add margin around texture rect
		_outerRect = _tile.rect;
		_outerRect.origin.x -= _margin;
		_outerRect.origin.y -= _margin;
		_outerRect.size.width += _margin*2;
		_outerRect.size.height += _margin*2;
		
		s = _outerRect.size;
		
		isoWidth = _tile.origin + _margin;   // A
        isoDepth = s.width - isoWidth;   // B
        nearX = isoDepth/2;      // D
        farX = isoWidth/2;         // C
        isoHeight = s.height - farX - nearX;    // E
        
        _outerBox.origin = (Point3D){ -_margin, -_margin, -_margin };
        _outerBox.size = (Size3D){ isoWidth, isoDepth, isoHeight };
		
	
		[self updateVerticies];
		[self updateTextureCoords];
		
	}
	return self;
}

- (void)updateTextureCoords
{
	GLfloat *t = _textureCoords->arr;
	// Don't bother with side faces if we have no height
	_textureCoords->num = _box.size.height > 0 ? 36 : 12;	// We have 18 2D coords to plot which we'll add manually
	
	int i = 0;
	
	// TOP QUAD
	
	t[i++] = _outerRect.size.width;	t[i++] = _outerBox.size.height + (_outerRect.size.width - (_tile.origin + _margin))/2.0;
	t[i++] = _outerRect.size.width - (_tile.origin + _margin);	t[i++] = _outerRect.size.height;
	t[i++] = 0.0;			t[i++] = _outerBox.size.height + (_tile.origin + _margin)/2.0;
	
	t[i++] = (_tile.origin + _margin);	t[i++] = _outerBox.size.height;
	t[i++] = _outerRect.size.width;	t[i++] = _outerBox.size.height + (_outerRect.size.width - (_tile.origin + _margin))/2;
	t[i++] = 0;			t[i++] = _outerBox.size.height + (_tile.origin + _margin) /2;
	
	if (_box.size.height > 0) {
		// RIGHT QUAD
		t[i++] = (_tile.origin + _margin);					t[i++] = 0;
		t[i++] = _outerRect.size.width;	t[i++] = (_outerRect.size.width - (_tile.origin + _margin))/2;
		t[i++] = (_tile.origin + _margin);					t[i++] = _outerBox.size.height;
		
		t[i++] = _outerRect.size.width;	t[i++] = (_outerRect.size.width - (_tile.origin + _margin))/2;
		t[i++] = _outerRect.size.width;	t[i++] = (_outerRect.size.width - (_tile.origin + _margin))/2 +_outerBox.size.height;	
		t[i++] = (_tile.origin + _margin);					t[i++] = _outerBox.size.height;
		
		// LEFT QUAD
		t[i++] = (_tile.origin + _margin);	t[i++] = 0;
		t[i++] = (_tile.origin + _margin);	t[i++] = _outerBox.size.height;
		t[i++] = 0;			t[i++] = (_tile.origin + _margin) /2;
		
		t[i++] = (_tile.origin + _margin);	t[i++] = _outerBox.size.height;
		t[i++] = 0;			t[i++] = _outerBox.size.height + (_tile.origin + _margin) /2;
		t[i++] = 0;			t[i++] = (_tile.origin + _margin) /2;
	}
	
	
	// Adjust for location in texture
	float atlasWidth = [[_layer texture] pixelsWide];
	float atlasHeight = [[_layer texture] pixelsHigh];
	
	for (int i=0; i<_textureCoords->num; i+=2) {
		t[i] +=  _outerRect.origin.x;
		// Image is flipped vertically
		t[i+1] = _outerRect.size.height - (t[i+1] - _outerRect.origin.y);
		t[i] /= atlasWidth;
		t[i+1] /= atlasHeight;
	}

}


- (void)updateVerticies
{
	static GLfloat cubeVertices[] = {
        // TOP
        1.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 1.0f,
		
		1.0f, 1.0f, 1.0f,
        1.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 1.0f,
		
		
        // LEFT
        1.0f, 0.0f, 1.0f,
        1.0f, 0.0f, 0.0f,
        1.0f, 1.0f, 1.0f,
        
		
        1.0f, 0.0f, 0.0f,
		1.0f, 1.0f, 0.0f,
        1.0f, 1.0f, 1.0f,
		
        // RIGHT
        1.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f,
		
        1.0f, 1.0f, 1.0f,
		0.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f,
		
    };

	// Initialise a default block
	// Only copy top face if we have no height
	GLfloatArrayCopyFromCArray(_verticies, cubeVertices, _box.size.height > 0 ? 54 : 18);
	
	GLfloat *v = _verticies->arr;
	
	// Move block to desired coordinates and adjust sizes for rotation
	for (int i=0; i<_verticies->num; i+=3) {
		
		// X
		v[i] = ((v[i] * _outerBox.size.width * scaleX_) + _outerBox.origin.x) * M_SQRT2;
		
		// Z
		v[i+1] = ((v[i+1] * _outerBox.size.height * scaleZ_) + _outerBox.origin.z) / 0.875;
		
		// Y -- Slight adjustment to revese the Y coordinate
		v[i+2] = ((v[i+2] * _outerBox.size.depth * scaleY_) - _outerBox.origin.y - _outerBox.size.depth) * M_SQRT2;
	}
	
}

- (void)setIsoPosition:(Point3D)p
{
	[super setIsoPosition:p];
	_outerBox.origin = p;
	_outerBox.origin.x -= _margin/2;
	_outerBox.origin.y -= _margin/2;
	_outerBox.origin.z -= _margin/2;
	
	[self updateVerticies];
	[self setDirty:YES];
}

- (void)setScale:(float)s
{
	[super setScale:s];
	[self updateVerticies];
	[self setDirty:YES];
}

- (void)dealloc
{
	GLfloatArrayFree(_verticies);
	GLfloatArrayFree(_textureCoords);
	[super dealloc];
}

@end
