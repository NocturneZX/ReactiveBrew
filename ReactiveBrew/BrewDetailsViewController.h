//
//  BrewDetailsViewController.h
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/21/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

@import UIKit;
@import CoreData;
#import "JR3PersistenceController.h"

@interface BrewDetailsViewController : UIViewController

@property (nonatomic, strong) CoffeeEntity *currentBrew;

@property JR3PersistenceController *persistenceController;

@end
