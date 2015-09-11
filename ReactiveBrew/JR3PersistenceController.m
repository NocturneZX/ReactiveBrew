//
//  JR3PersistenceController.m
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/9/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//
//  Based off Marcus Zarra's Core Data Stack at http://martiancraft.com/blog/2015/03/core-data-stack/
//
//


#import "JR3PersistenceController.h"

@interface JR3PersistenceController ()
@property (strong, readwrite) NSManagedObjectContext *mainManagedObjectContext;
@property (strong) NSManagedObjectContext *privateContext;

@property (copy) InitialCallbackBlock initCallback;
- (void)initializeCoreData;
@end

@implementation JR3PersistenceController

-(instancetype)initWithCallback:(InitialCallbackBlock)callback{
    if (!(self = [super init])) {
        return nil;
    }
    [self setInitCallback:callback];
    [self initializeCoreData];
    
    return self;
}

-(void) initializeCoreData{
    if ([self mainManagedObjectContext]) return;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ReactiveBrew" withExtension:@"momd"];
    NSManagedObjectModel *brewObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:brewObjectModel];
    
    [self setMainManagedObjectContext:[[NSManagedObjectContext alloc]initWithConcurrencyType:
                                       NSMainQueueConcurrencyType]];
    [self setPrivateContext:[[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType]];
    [[self privateContext] setPersistentStoreCoordinator:coordinator];
    [[self mainManagedObjectContext] setParentContext:[self privateContext]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSPersistentStoreCoordinator *psc = [[self privateContext]persistentStoreCoordinator];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
        options[NSInferMappingModelAutomaticallyOption] = @YES;
        options[NSSQLitePragmasOption] = @{ @"journal_mode":@"DELETE" };
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL =[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"ReactiveBrew.sqlite"];

        NSError *error = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";

        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        if (![self initCallback]) return;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self initCallback]();
        });
        
    }); // end dispatch_async
}
-(void)saveContext{
    
    // If no changes have been made when the app change state
    if (![[self privateContext] hasChanges] && ![[self mainManagedObjectContext] hasChanges]) return;
    
    [[self mainManagedObjectContext] performBlockAndWait:^{ // Save main context
        NSError *error = nil;
        if (![[self mainManagedObjectContext] save:&error]) {
            NSLog(@"Failed to save main context: %@\n%@", [error localizedDescription], [error userInfo]);
        }
        
        [[self privateContext] performBlock:^{ // Save private context
            NSError *privateError = nil;
            if (![[self privateContext] save:&privateError]) {
                NSLog(@"Error saving private context: %@\n%@", [privateError localizedDescription], [privateError userInfo]);
            }
        }];
    }];
}

//if (managedObjectContext != nil) {
//    NSError *error = nil;
//    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//}
@end
