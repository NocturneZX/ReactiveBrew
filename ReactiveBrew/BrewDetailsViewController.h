//
//  BrewDetailsViewController.h
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/21/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

@import UIKit;
@import CoreData;
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "JR3PersistenceController.h"
#import "ReactiveCocoa.h"

typedef NS_ENUM(NSInteger, JRTwitterInstantError) {
    JRTwitterInstantErrorAccessDenied,
    JRTwitterInstantErrorNoTwitterAccounts,
    JRTwitterInstantErrorInvalidResponse
};

static NSString * const JRTwitterDomain = @"TwitterBrew";

@interface BrewDetailsViewController : UIViewController

@property (nonatomic, strong) CoffeeEntity *currentBrew;

@property JR3PersistenceController *persistenceController;

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *accountType;

@end
