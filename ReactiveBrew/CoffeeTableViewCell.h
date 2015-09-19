//
//  CoffeeTableViewCell.h
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/16/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoffeeTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *brewImage;
@property (nonatomic, weak) IBOutlet UILabel *brewLabel;
@property (nonatomic, weak) IBOutlet UITextView *brewTextView;
@end
