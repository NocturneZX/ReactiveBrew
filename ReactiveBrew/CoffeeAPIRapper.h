//
//  CoffeeAPIRapper.h
//  ReactiveBrew
//
//  Created by Julio Reyes on 8/31/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "Mantle.h"

@class RACSignal;
@interface CoffeeAPIRapper : NSObject<NSURLSessionDataDelegate>


+(CoffeeAPIRapper *)sharedCoffee;

/*
 * Fetches some coffee from the server using ReactiveCocoa
 *
 */
- (RACSignal *)fetchmeSomeCoffee;

- (RACSignal *)resetData;

-(instancetype)initWithCoffeeURL:(NSURL *)urll;

@end
