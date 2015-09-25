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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_brewDetailsTitle, _brewDetailsTextView, _brewDetailsImageView, _brewDetailsUpdatedTime);
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [views enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [obj setAlpha:1.0];
            
            self.brewDetailsTitle.text = _currentBrew.name;
            self.brewDetailsTextView.text = _currentBrew.desc;
            self.brewDetailsImageView.image = [UIImage imageWithData:_currentBrew.image];
            self.brewDetailsUpdatedTime.text = [NSString stringWithFormat:@"Updated %@", _currentBrew.last_updated_at];
        }];

    } completion:^(BOOL finished) {
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Share"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(ShareBrew:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ShareBrew:(id)sender{
    
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
