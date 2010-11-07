//
//  cocosisoAppDelegate.h
//  cocosiso
//
//  Created by Ryan Williams on 7/11/10.
//  Copyright Ryan Williams 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface cocosisoAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
