//
//  IsoMap.h
//
//  Created by Ryan Williams on 15/08/10.
//  Copyright 2010 Ryan Williams All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class IsoLayer;

@interface IsoMap : CCNode {
	CCRenderTexture *_renderTexture;
	NSMutableArray *_layers;
	
	BOOL _useRenderTexture;
}

@property (assign) BOOL useRenderTexture;

+ (id)mapWithFile:(NSString*)filename;
- (id)initWithFile:(NSString*)filename;

@end
