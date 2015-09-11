//
//  Coffee.m
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/3/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import "Coffee.h"

@implementation Coffee
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"desc" : @"desc",
             @"imageURL" : @"image_url",
             @"coffee_id" : @"id",
             @"name" : @"name",
             };
}

+ (NSValueTransformer *)coffeeJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:Coffee.class];
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName
{
    return @"CoffeeEntity";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
             @"desc" : @"desc",
             @"imageURL" : @"image_url",
             @"coffee_id" : @"id",
             @"name" : @"name",
             };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing
{
    return [NSSet setWithObject:@"id"];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{
             @"coffees:": Coffee.class,
    };
}
@end
