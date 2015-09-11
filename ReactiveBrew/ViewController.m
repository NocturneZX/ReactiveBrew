//
//  ViewController.m
//  ReactiveBrew
//
//  Created by Julio Reyes on 8/18/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//
#import "Coffee.h"
#import "CoffeeAPIRapper.h"
#import "JR3PersistenceController.h"

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *brewTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) JR3PersistenceController *persistenceController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Entry point established.");
    
    [[[CoffeeAPIRapper sharedCoffee]fetchmeSomeCoffee]subscribeNext:^(NSArray* x) {
        
        Coffee *randomBrew = [x objectAtIndex:0];
        NSLog(@"%@", randomBrew.desc);

        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSFetchedResultsController *)fetchedResultsController{
    if (self.fetchedResultsController) return self.fetchedResultsController;
    
    NSManagedObjectContext *moc = [[self persistenceController]mainManagedObjectContext];
    NSFetchRequest *brewFetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"CoffeeEntity"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"coffee_id" ascending:YES];
    [brewFetchRequest setSortDescriptors:@[sort]];
    
    NSFetchedResultsController *brewFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:brewFetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:@"MainCache"];
    
    
    return self.fetchedResultsController;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
