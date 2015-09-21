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
#import "CoffeeTableViewCell.h"
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *brewTableView;
@property (strong, nonatomic) NSFetchedResultsController *brewFetchedResultsController;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSArray *coffees;

@end

@implementation ViewController

static NSString * const reuseIdentifier = @"CoffeeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Entry point established.");
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Drip Image"]];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // I SHAN'T NOT DO THIS EVER AGAIN!!!
    //         id applicationDelegate = [[UIApplication sharedApplication] delegate];
    //         self.persistenceController = [applicationDelegate persistenceController];
    
    @weakify(self);
    // GET ALL THE BREWS VIA REACTIVECOCOA
    [[[CoffeeAPIRapper sharedCoffee]fetchmeSomeCoffee]
     subscribeNext:^(id x) {
         @strongify(self);
         [x enumerateObjectsUsingBlock:^(id brewObj, NSUInteger idx, BOOL *stop) {
             
             Coffee *currentBrew = brewObj;
             NSManagedObjectContext *moc = [self.persistenceController mainManagedObjectContext];
             NSError *error;
             
             [MTLManagedObjectAdapter managedObjectFromModel:currentBrew
                                        insertingIntoContext:moc error:&error];
             
             if (![moc save:&error]) {
                 NSLog(@"Unable to save context for %@", [Coffee managedObjectEntityName]);
             }
             
         }];
     }completed:^{
         self.coffees = [self.brewFetchedResultsController fetchedObjects];
         [self.brewTableView reloadData];

         NSLog(@"%lu", (unsigned long)self.coffees.count);
     }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSFetchedResultsController *)brewFetchedResultsController{
    if (_brewFetchedResultsController) return _brewFetchedResultsController;
    
    NSManagedObjectContext *moc = [[self persistenceController]mainManagedObjectContext];

    NSFetchRequest *brewFetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"CoffeeEntity"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:NO];
    [brewFetchRequest setSortDescriptors:@[sort]];
    
    NSFetchedResultsController *brewFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:brewFetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    [self setBrewFetchedResultsController:brewFRC];
    [[self brewFetchedResultsController] setDelegate:self];
    
    NSError *error;
    NSAssert([_brewFetchedResultsController performFetch:&error], @"Unresolved error %@\n%@", [error localizedDescription], [error userInfo]);

    return _brewFetchedResultsController;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self brewFetchedResultsController]sections] objectAtIndex:section];
//    return [sectionInfo numberOfObjects] ? 0 : [sectionInfo numberOfObjects];
    return [self.coffees count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoffeeTableViewCell *coffeecell = [tableView
                                       dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (!coffeecell) {
        coffeecell = [[CoffeeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:reuseIdentifier];
    }
    
    // rac_prepareForResuseSignal?
    [coffeecell prepareForReuse];
    
    CoffeeEntity *currentBrew = [self.coffees objectAtIndex:indexPath.row];
    NSLog(@"%@", currentBrew.description);
    
    coffeecell.brewTitle.text = currentBrew.name;
    
    coffeecell.brewDescription.text = currentBrew.desc;
    
    [coffeecell.brewImage sd_setImageWithURL:[NSURL URLWithString:currentBrew.imageurl]
                                                    placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return coffeecell;
}

#pragma mark - NSFetchedResultsControllerDelegate Methods

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [[self brewTableView]beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self brewTableView] insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self brewTableView] deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSArray *newArray = nil;
    NSArray *oldArray = nil;
    
    if (newIndexPath) {
        newArray = [NSArray arrayWithObject:newIndexPath];
    }
    
    if (indexPath) {
        oldArray = [NSArray arrayWithObject:indexPath];
    }
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self brewTableView] insertRowsAtIndexPaths:newArray withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self brewTableView] deleteRowsAtIndexPaths:oldArray withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
        {
            UITableViewCell *cell = [[self brewTableView] cellForRowAtIndexPath:indexPath];
            NSManagedObject *object = [[self brewFetchedResultsController] objectAtIndexPath:indexPath];
            [[cell textLabel] setText:[object valueForKey:@"dataItem"]];
            break;
        }
        case NSFetchedResultsChangeMove:
            [[self brewTableView] deleteRowsAtIndexPaths:oldArray withRowAnimation:UITableViewRowAnimationFade];
            [[self brewTableView] insertRowsAtIndexPaths:newArray withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self brewTableView] endUpdates];
}

@end
