//
//  CoffeeTableViewCellLite.h
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/22/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoffeeTableViewCellLite : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *brewTitle;
@property (nonatomic, weak) IBOutlet UILabel *brewDescription;
@end
