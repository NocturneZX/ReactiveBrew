//
//  CoffeeTableViewCell.m
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/16/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import "CoffeeTableViewCell.h"

@implementation CoffeeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
                                reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // Initialization code
        _brewImage = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

-(void)prepareForReuse{
    self.brewImage.image = nil;
    
    self.contentView.bounds = self.contentView.bounds;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    
//    CGSize maxSize = CGSizeMake(260.0f, CGFLOAT_MAX);
//    CGSize requiredSize = [self.brewTitle sizeThatFits:maxSize];
//    self.brewTitle.frame = CGRectMake(self.brewTitle.frame.origin.x, self.brewTitle.frame.origin.y, requiredSize.width, requiredSize.height);
//    
//    requiredSize = [self.brewDescription sizeThatFits:maxSize];
//    self.brewDescription.frame = CGRectMake(self.brewDescription.frame.origin.x, self.brewDescription.frame.origin.y, requiredSize.width, requiredSize.height);
//    
//    requiredSize = [self.brewImage sizeThatFits:maxSize];
//    self.brewImage.frame = CGRectMake(self.brewImage.frame.origin.x, self.brewImage.frame.origin.y, requiredSize.width, requiredSize.height);

    
}

@end
