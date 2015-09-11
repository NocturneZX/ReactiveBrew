//
//  JR3PersistenceController.h
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/9/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^InitialCallbackBlock)(void);

@interface JR3PersistenceController : NSObject
@property(strong, nonatomic, readonly) NSManagedObjectContext *mainManagedObjectContext;
-(instancetype)initWithCallback:(InitialCallbackBlock)callback;
-(void)saveContext;

@end
