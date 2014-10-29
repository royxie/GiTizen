//
//  MyJoinedEventTableViewController.m
//  GiTizen
//
//  Created by XieShiyu on 29/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "MyJoinedEventTableViewController.h"

@interface MyJoinedEventTableViewController ()

@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *joinedEvents;
@property (strong, nonatomic) EventCenterTableViewCell *eventCell;

@end

@implementation MyJoinedEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init_field];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.navigationItem.title = @"My Event";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterEvents)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self loadJoinedEvents];
}

-(void) init_field
{
    self.events = [NSMutableArray new];
    self.joinedEvents = [NSMutableArray new];
}

- (void) filterEvents {
    
}

- (void) refresh {
    [self loadJoinedEvents];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.events.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.eventCell = [tableView dequeueReusableCellWithIdentifier:@"EventCenterTableViewCell"];// forIndexPath:indexPath];
    
    self.eventCell = [[[NSBundle mainBundle] loadNibNamed:@"EventCenterTableViewCell" owner:self options:nil] lastObject];
    
    [self configureCell:self.eventCell atIndexPath:indexPath];
    
    return self.eventCell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Event *event = self.events[indexPath.row];
    
    //self.eventCell.categoryLabel.text = event.category;
    //id food  = [NSString fontAwesomeIconStringForEnum:FAIconBook];
    
    id icon = [NSString fontAwesomeIconStringForEnum:FAIconBook];
    
    if ([event.category  isEqual: @"Sport"]) {
        icon = [NSString fontAwesomeIconStringForEnum:FAIconFlag];
    }
    if ([event.category  isEqual: @"Adventure"]) {
        icon = [NSString fontAwesomeIconStringForEnum:FAIconPlane];
    }
    if ([event.category  isEqual: @"Food"]) {
        icon = [NSString fontAwesomeIconStringForEnum:FAIconGlass];
    }
    if ([event.category  isEqual: @"Concert"]) {
        icon = [NSString fontAwesomeIconStringForEnum:FAIconMusic];
    }
    if ([event.category  isEqual: @"Drama"]) {
        icon = [NSString fontAwesomeIconStringForEnum:FAIconGroup];
    }
    if ([event.category  isEqual: @"Bar"]) {
        icon = [NSString fontAwesomeIconStringForEnum:FAIconGlass];
    }
    if ([event.category  isEqual: @"Hiking"]) {
        icon = [NSString fontAwesomeIconStringForEnum:FAIconGlobe];
    }
    if ([event.category  isEqual: @"Reading"]) {
        icon = [NSString fontAwesomeIconStringForEnum:FAIconBook];
    }
    
    self.eventCell.categoryLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:50.f];
    self.eventCell.categoryLabel.text = [NSString stringWithFormat:@"%@", icon];
    self.eventCell.locLabel.text = event.g_loc_name;
    self.eventCell.tsLabel.text = event.starttime;
    self.eventCell.npLabel.text = event.number_of_peo;
    self.eventCell.njLabel.text = event.number_joined;
    //NSLog(@"event is: %@",event);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.eventCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"joinedEventDetail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"joinedEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Event *selectedEvent = self.events[indexPath.row];
        [[segue destinationViewController] setDetailItem:selectedEvent];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteEvents:indexPath];
        [self.events removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)loadJoinedEvents
{
    NSString* userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    NSString* myPath = [@"/api/joins/gtid/" stringByAppendingString:userid];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:myPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSLog(@"successfully load joinedEvents");
                                                  self.joinedEvents = [NSMutableArray arrayWithArray: mappingResult.array];
                                                  [self.events removeAllObjects];
                                                  for(Join* join in self.joinedEvents) {
                                                      [self loadEvents: join.event_id];
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
    
}

-(void)loadEvents: event_id
{
    NSString* myPath = [@"/api/events/" stringByAppendingString:event_id];
    [[RKObjectManager sharedManager] getObjectsAtPath:myPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [self.events addObject:mappingResult.firstObject];
                                                  NSLog(@"successfully load events");
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
}

- (void)deleteEvents:(NSIndexPath *)indexPath
{
    Event *selectedEvent = self.events[indexPath.row];
    Join *joinedEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Join" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
    
    NSString* userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    joinedEvent.gtid = userid;
    joinedEvent.event_id = selectedEvent.object_id;
    [[RKObjectManager sharedManager]  deleteObject:joinedEvent
                                              path:@"/api/joins"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               NSLog(@"joins successfully deleted");
                                               UIAlertView* quitSuccess = [[UIAlertView alloc] initWithTitle:@"Quit" message:@"you have quited the event" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                               [quitSuccess show];
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
