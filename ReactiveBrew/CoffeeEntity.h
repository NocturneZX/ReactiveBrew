//
//  Coffee.h
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/3/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoffeeEntity : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * coffee_id;
@property (nonatomic, retain) NSString * imageurl;
@property (nonatomic, retain) NSString * last_updated_at;
@property (nonatomic, retain) NSString * name;

@end
