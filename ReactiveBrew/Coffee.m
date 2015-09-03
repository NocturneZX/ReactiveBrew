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
             @"image_url" : @"image_url",
             @"id" : @"id",
             @"name" : @"name",
             @"last_updated_at" : @"last_updated_at"
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
             @"image_url" : @"image_url",
             @"id" : @"id",
             @"name" : @"name",
             @"last_updated_at" : @"last_updated_at"
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
