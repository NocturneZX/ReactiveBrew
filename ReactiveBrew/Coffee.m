//
//  Coffee.m
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/3/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import "Coffee.h"
#import "CoffeeEntity.h"

@implementation Coffee
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"desc" : @"desc",
             @"imageurl" : @"image_url",
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
             @"imageurl" : @"imageurl",
             @"coffee_id" : @"coffee_id",
             @"name" : @"name",
             @"last_updated_at" : @"last_updated_at"
             };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing
{
    return [NSSet setWithObject:@"coffee_id"];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{
             @"coffees:": Coffee.class,
    };
}

- (id)transformedValue:(id)value success:(BOOL *)success error:(NSError **)error{
    return nil;
}

@end
