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
#import "BrewDetailsViewController.h"

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
     }
     error:^(NSError *error) {
         self.coffees = [self.brewFetchedResultsController fetchedObjects];
     }
     completed:^{
         @strongify(self);
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
    return [self.coffees count] > 0 ? [self.coffees count] : 0;
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
    
    coffeecell.brewTitle.text = currentBrew.name;
    coffeecell.brewDescription.text = currentBrew.desc;
    [coffeecell.brewImage sd_setImageWithURL:[NSURL URLWithString:currentBrew.imageurl]
                        placeholderImage:[UIImage imageNamed:@"placeholder"]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                            {
                                if (!error) {
                                    NSManagedObject *brewObject = [[self brewFetchedResultsController] objectAtIndexPath:indexPath];
                                    NSManagedObjectContext *moc = [self.brewFetchedResultsController managedObjectContext];
                                    
                                    NSData *imageData = UIImagePNGRepresentation(image);
                                    [brewObject setValue:imageData forKey:@"image"];
                                    
                                    NSError *saveError;
                                    if (![moc save:&saveError]) {
                                        NSLog(@"Unable to save context for %@", [Coffee managedObjectEntityName]);
                                    }
                                }
                            }];
    
    return coffeecell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        
        
        NSIndexPath *currentIDX = [self.brewTableView indexPathForSelectedRow];
        CoffeeEntity *selectedBrew = (self.coffees)[currentIDX.row];

        
        @weakify(self)
        [[[CoffeeAPIRapper sharedCoffee]fetchmeMoreCoffeeInfo:selectedBrew.coffee_id]
         subscribeNext:^(id newInfo) {
            @strongify(self)
            NSString *dateUpdated = [newInfo valueForKey:@"last_updated_at"];
             NSString *description = [newInfo valueForKey:@"desc"];
             
            NSManagedObject *brewObject = [[self brewFetchedResultsController] objectAtIndexPath:currentIDX];
            NSManagedObjectContext *moc = [self.brewFetchedResultsController managedObjectContext];
            [brewObject setValue:dateUpdated forKey:@"last_updated_at"];
            [brewObject setValue:description forKey:@"desc"];

            NSError *error;
            if (![moc save:&error]) {
                NSLog(@"Unable to save context for %@", [Coffee managedObjectEntityName]);
            }

        }];
        
        selectedBrew = [[self brewFetchedResultsController] objectAtIndexPath:currentIDX];
        BrewDetailsViewController *detailsVC = (BrewDetailsViewController *)segue.destinationViewController;
        
        detailsVC.persistenceController = self.persistenceController;
        detailsVC.currentBrew = selectedBrew;
        
    }
}

@end
