//
//  IsoLayer.h
//
//  Created by Ryan Williams on 14/08/10.
//  Copyright 2010 Ryan Williams All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GLfloatArray.h"

@class IsoNode, IsoTileset;

@interface IsoLayer : CCNode {
	NSMutableArray *_blocks;
	IsoTileset *_tileset;
	CCTexture2D *_texture;
	
	
	GLfloatArray *_blockVerticies;
	GLfloatArray *_textureCoords;
	
	// Optimisation, stores the locations where each block starts in the above arrays
	CCArray *_blockOffsets;
}

@property (readonly) IsoTileset *tileset;
@property (readonly) CCTexture2D *texture;

+ (id)layerWithTileset:(IsoTileset*)tileset;
- (id)initWithTileset:(IsoTileset*)tileset;
- (BOOL)collidesWithNode:(IsoNode*)node;

@end
