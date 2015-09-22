//
//  BrewDetailsViewController.m
//  ReactiveBrew
//
//  Created by Julio Reyes on 9/21/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import "CoffeeEntity.h"
#import "BrewDetailsViewController.h"

@interface BrewDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *brewDetailsTitle;
@property (nonatomic, weak) IBOutlet UIImageView *brewDetailsImageView;
@property (nonatomic, weak) IBOutlet UITextView *brewDetailsTextView;
@property (nonatomic, weak) IBOutlet UILabel *brewDetailsUpdatedTime;

@end

@implementation BrewDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.brewDetailsTitle.text = _currentBrew.coffee_id;
    self.brewDetailsTextView.text = _currentBrew.desc;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
