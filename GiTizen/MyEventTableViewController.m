//
//  MyEventTableViewController.m
//  GiTizen
//
//  Created by XieShiyu on 25/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "MyEventTableViewController.h"
#import "ProgressHUD.h"


@interface MyEventTableViewController ()

@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *p_events;
@property (strong, nonatomic) NSMutableArray *l_events;
@property (strong, nonatomic) EventCenterTableViewCell *eventCell;

@end

@implementation MyEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init_field];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.navigationItem.title = @"My Post";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterEvents)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postNewEvents)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //[self loadEvents];
}

-(void) init_field {
    self.events = [NSMutableArray new];
    self.p_events = [NSMutableArray new];
    self.l_events = [NSMutableArray new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (ifUserLogin() == NO)
        LoginUser(self);
    
    [self loadEvents];
    [self.tableView reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section == 0)
        return self.l_events.count;
    else
        return self.p_events.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.eventCell = [tableView dequeueReusableCellWithIdentifier:@"EventCenterTableViewCell"];// forIndexPath:indexPath];
    
    self.eventCell = [[[NSBundle mainBundle] loadNibNamed:@"EventCenterTableViewCell" owner:self options:nil] lastObject];
    
    if(indexPath.section == 0)
        [self configureCell:self.l_events atIndexPath:indexPath];
    
    if(indexPath.section == 1)
        [self configureCell:self.p_events atIndexPath:indexPath];
    
    return self.eventCell;
}

- (void)configureCell:(NSMutableArray*)evts atIndexPath:(NSIndexPath *)indexPath
{
    Event *event = evts[indexPath.row];
    
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


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Upcoming";
            break;
        case 1:
            sectionName = @"History";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.eventCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"eventDetail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"eventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Event *selectedEvent;
        if(indexPath.section == 0) {
            selectedEvent = self.l_events[indexPath.row];
        }
        else {
            selectedEvent = self.p_events[indexPath.row];
        }
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
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


-(void)loadEvents
{
    NSString* userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    NSString* myPath = [@"/api/events/gtid/" stringByAppendingString:userid];
    
    [ProgressHUD show:nil];
    [[RKObjectManager sharedManager] getObjectsAtPath:myPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.events = mappingResult.array;
                                                  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                                                  dateFormatter.dateFormat = @"MM-dd-yyyy HH:mm";
                                                  
                                                  [self.p_events removeAllObjects];
                                                  [self.l_events removeAllObjects];
                                                  NSDate *now = [NSDate date];
                                                  for(Event* evt in self.events) {
                                                      NSDate * date = [dateFormatter dateFromString:evt.starttime];
                                                      if ([date compare:now] <= 0) {
                                                          //self.p_events = [self.events subarrayWithRange:NSMakeRange(0, 10)];
                                                          [self.p_events addObject:evt];
                                                      }
                                                      else [self.l_events addObject:evt];
                                                  }
                                                  [self.l_events sortUsingComparator:^NSComparisonResult(Event* a, Event* b) {
                                                      
                                                      NSDate *date1 = [dateFormatter dateFromString:a.starttime];
                                                      NSDate *date2 = [dateFormatter dateFromString:b.starttime];
                                                      
                                                      return [date1 compare:date2];
                                                  }];
                                                  [self.p_events sortUsingComparator:^NSComparisonResult(Event* a, Event* b) {
                                                      
                                                      NSDate *date1 = [dateFormatter dateFromString:a.starttime];
                                                      NSDate *date2 = [dateFormatter dateFromString:b.starttime];
                                                      
                                                      return [date2 compare:date1];
                                                  }];
                                                  
                                                  [self.tableView reloadData];
                                                  [ProgressHUD dismiss];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                                  [ProgressHUD showError:@"Network error."];
                                              }];
}

- (void)deleteEvents:(NSIndexPath *)indexPath
{
    Event *selectedEvent = self.l_events[indexPath.row];
    NSString* path = [@"/api/events/" stringByAppendingString:selectedEvent.object_id];
    //NSLog(@"%@", path);
    [[RKObjectManager sharedManager]  deleteObject:selectedEvent
                                              path:path
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               [self.l_events removeObjectAtIndex:indexPath.row];
                                               [self.tableView reloadData];
                                               NSLog(@"Successfully deleted");
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
