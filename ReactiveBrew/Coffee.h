//
//  Coffee.h
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/3/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import "MTLModel.h"

#import <Mantle/Mantle.h>
#import <CoreData/CoreData.h>

#import "MTLManagedObjectAdapter.h"

@interface Coffee : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>
@property (strong, nonatomic, readwrite) NSString * desc;
@property (strong, nonatomic, readwrite) NSString * coffee_id;
@property (strong, nonatomic, readwrite) NSString * imageURL;
@property (strong, nonatomic, readwrite) NSString * name;

@end
