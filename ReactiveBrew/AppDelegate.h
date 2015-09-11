//
//  AppDelegate.h
//  ReactiveBrew
//
//  Created by Julio Reyes on 8/18/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class JR3PersistenceController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, readonly) JR3PersistenceController *persistenceController;

@end

