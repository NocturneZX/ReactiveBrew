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

@end
