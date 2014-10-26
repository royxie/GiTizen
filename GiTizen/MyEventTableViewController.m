//
//  MyEventTableViewController.m
//  GiTizen
//
//  Created by XieShiyu on 25/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "MyEventTableViewController.h"

@interface MyEventTableViewController ()

@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) EventCenterTableViewCell *eventCell;

@end

@implementation MyEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.navigationItem.title = @"My Event";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterEvents)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postNewEvents)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self loadEvents];
}

- (void) filterEvents {
    
}

- (void) postNewEvents {
    [self performSegueWithIdentifier:@"post" sender:nil];
}

- (void) refresh {
    [self loadEvents];
    [self.refreshControl endRefreshing];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
    self.eventCell.addrLabel.text = event.g_loc_addr;
    self.eventCell.npLabel.text = event.number_of_peo;
    self.eventCell.njLabel.text = event.number_joined;
    //NSLog(@"event is: %@",event);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.eventCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"eventDetail" sender:nil];
    
    /*
     //allocate your view controller
     DetailViewController *detailedViewController = [[DetailViewController alloc] init];
     
     //push it to the navigationController
     [[self navigationController] pushViewController:detailedViewController animated:YES];
     //[detailedViewController setDetailItem: self.eventCell];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"eventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Event *selectedEvent = self.events[indexPath.row];
        [[segue destinationViewController] setDetailItem:selectedEvent];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
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


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)loadEvents
{
    NSString* userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    NSString* myPath = [@"/api/events/gtid/" stringByAppendingString:userid];
    //NSLog(@"gtid: %@", userid);
    [[RKObjectManager sharedManager] getObjectsAtPath:myPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.events = mappingResult.array;
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
}

- (void)deleteEvents:(NSIndexPath *)indexPath
{
    Event *selectedEvent = self.events[indexPath.row];
    NSString* path = [@"/api/events/" stringByAppendingString:selectedEvent.object_id];
    NSLog(@"%@", path);
    [[RKObjectManager sharedManager]  deleteObject:NULL
                                              path:path
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               NSLog(@"Successfully deleted");
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
