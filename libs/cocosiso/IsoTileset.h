//
//  IsoTileset.h
//
//  Created by Ryan Williams on 15/08/10.
//  Copyright 2010 Ryan Williams All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef struct _IsoTile  {
	CGRect rect;
	NSUInteger origin;
} IsoTile;

@interface IsoTileset : NSObject {	
	CCTexture2D *_texture;	
	IsoTile *_tiles; // C Array of tiles
	
	NSMutableArray *_tileProperties;
}

@property (readonly) CCTexture2D *texture;

+ (id)tilesetWithFileNamed:(NSString*)filename;
- (id)initWithFileNamed:(NSString*)filename;
- (IsoTile)tileAtIndex:(NSUInteger)idx;
- (NSDictionary*)tilePropertiesAtIndex:(NSUInteger)idx;


@end
