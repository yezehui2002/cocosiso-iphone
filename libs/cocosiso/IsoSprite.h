//
//  IsoSprite.h
//
//  Created by Ryan Williams on 14/08/10.
//  Copyright 2010 Ryan Williams All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Geometry3D.h"
#import "GLfloatArray.h"
#import "IsoTileset.h"
#import "IsoNode.h"

@class IsoLayer;

@interface IsoSprite : IsoNode {
    IsoLayer *_layer;
	IsoTile _tile;
	
	Box3D _outerBox; // Box including margin
	CGRect _outerRect; // Tile rect including margin
	
    // Values for OpenGL drawing
	GLfloatArray *_verticies;		// GLfloat
	GLfloatArray *_textureCoords;	// GLfloat
	
	int _margin;
}

@property (readonly) GLfloatArray *verticies;
@property (readonly) GLfloatArray *textureCoords;


- (id)initWithIsoLayer:(IsoLayer*)layer tileIndex:(NSUInteger)idx;
- (void)updateVerticies;
- (void)updateTextureCoords;

@end
