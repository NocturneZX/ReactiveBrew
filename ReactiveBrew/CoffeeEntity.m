//
//  Coffee.m
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/3/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import "CoffeeEntity.h"

@implementation CoffeeEntity

@dynamic desc;
@dynamic coffee_id;
@dynamic imageurl;
@dynamic last_updated_at;
@dynamic name;

-(NSString *)description{
    return [NSString stringWithFormat:@"%@, %@, %@, %@", self.coffee_id, self.name, self.desc, self.imageurl, self.last_updated_at];
}
@end
