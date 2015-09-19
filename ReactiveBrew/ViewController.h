//
//  ViewController.h
//  ReactiveBrew
//
//  Created by Julio Reyes on 8/18/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mantle/Mantle.h>
#import <MTLManagedObjectAdapter.h>
#import <SDWebImage/UIImageView+WebCache.h>

@import CoreData;

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property JR3PersistenceController *persistenceController;

@end

