//
//  ViewController.m
//  ReactiveBrew
//
//  Created by Julio Reyes on 8/18/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//
#import "Coffee.h"
#import "CoffeeEntity.h"
#import "CoffeeAPIRapper.h"
#import "JR3PersistenceController.h"

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *brewTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, readwrite) JR3PersistenceController *persistenceController;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSArray *coffees;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Entry point established.");
    
    NSLog(@"%@", self.coffees);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    @weakify(self);
    // GET ALL THE BREWS VIA REACTIVECOCOA
    [[[[CoffeeAPIRapper sharedCoffee]fetchmeSomeCoffee]deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray* x){
         @strongify(self);
         [self setPersistenceController:[[JR3PersistenceController alloc]initWithCallback:^{
             [x enumerateObjectsUsingBlock:^(id brewObj, NSUInteger idx, BOOL *stop) {
                 
                 Coffee *currentBrew = brewObj;
                 NSLog(@"%@", currentBrew);
                 
                 NSManagedObjectContext *moc = [self.persistenceController mainManagedObjectContext];
                 NSError *error;
                 
                 [MTLManagedObjectAdapter managedObjectFromModel:currentBrew
                                            insertingIntoContext:moc error:&error];
                 
                 if (![moc save:&error]) {
                     NSLog(@"Unable to save context for %@", [Coffee managedObjectEntityName]);
                 }
               //  NSLog(@"%@", self.fetchedResultsController);
             }];
         }]];
         
         // Will crash if I invoke fecthedResultsController
        // self.coffees = [self.fetchedResultsController fetchedObjects];
     }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSFetchedResultsController *)fetchedResultsController{
//    if (self.fetchedResultsController != nil){
//        return self.fetchedResultsController;
//    }
    
    NSManagedObjectContext *moc = [[self persistenceController]mainManagedObjectContext];
//    if (!moc) {
//        return nil;
//    }
    NSFetchRequest *brewFetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"CoffeeEntity"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"coffee_id" ascending:YES];
    [brewFetchRequest setSortDescriptors:@[sort]];
    
    NSFetchedResultsController *brewFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:brewFetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:@"MainCache"];
    [self setFetchedResultsController:brewFRC];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@\n%@", [error localizedDescription], [error userInfo]);
    }
    
    return self.fetchedResultsController;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return [[[self fetchedResultsController] sections] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController]sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects] ? 0 : [sectionInfo numberOfObjects];
   // return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - NSFetchedResultsControllerDelegate Methods

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [[self brewTableView]beginUpdates];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self brewTableView] endUpdates];
}

@end
