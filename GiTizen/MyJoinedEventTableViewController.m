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
@property (strong, nonatomic) NSMutableArray *p_events;
@property (strong, nonatomic) NSMutableArray *l_events;
@property (strong, nonatomic) EventCenterTableViewCell *eventCell;

@end

@implementation MyJoinedEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init_field];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.navigationItem.title = @"My Joined Events";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterEvents)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self loadJoinedEvents];
}

-(void) init_field
{
    self.events = [NSMutableArray new];
    self.joinedEvents = [NSMutableArray new];
    self.p_events = [NSMutableArray new];
    self.l_events = [NSMutableArray new];
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
    self.eventCell = [tableView dequeueReusableCellWithIdentifier:@"EventCenterTableViewCell"];
    
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.eventCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"joinedEventDetail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"joinedEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Event *selectedEvent;
        if(indexPath.section == 0) {
            selectedEvent = self.l_events[indexPath.row];
        }
        else {
            NSLog(@"p_row: %ld", (long)indexPath.row);
            selectedEvent = self.p_events[indexPath.row];
        }
        [[segue destinationViewController] setDetailItem:selectedEvent];
    }
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

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (indexPath.section == 0) {
            [self deleteEvents: self.l_events atIndexPath: indexPath];
        }
        else [self deleteEvents: self.p_events atIndexPath: indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

-(void)loadJoinedEvents
{
    NSString* userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    NSString* myPath = [@"/api/joins/gtid/" stringByAppendingString:userid];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:myPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSLog(@"successfully load joinedEvents");
                                                  self.joinedEvents = mappingResult.array;
                                                  [self.events removeAllObjects];
                                                  [self.p_events removeAllObjects];
                                                  [self.l_events removeAllObjects];
                                                  int num = 0;
                                                  for(Join* join in self.joinedEvents) {
                                                      if(join.event_id != nil) num++;
                                                  }
                                                  for(Join* join in self.joinedEvents) {
                                                      if(join.event_id != nil) {
                                                          [self loadEvents: join.event_id inTotalNum: num];
                                                      }
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
    
}

-(void)loadEvents: (NSString*)event_id inTotalNum: (int) numOfEvent
{
    NSString* myPath = [@"/api/events/" stringByAppendingString:event_id];
    [[RKObjectManager sharedManager] getObjectsAtPath:myPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  Event* evt = mappingResult.firstObject;
                                                  [self.events addObject:evt];
                                                  int count = [self.events count];
                                                  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                                                  dateFormatter.dateFormat = @"MM-dd-yyyy HH:mm";
                                                  NSDate *now = [NSDate date];
                                                  NSDate * date = [dateFormatter dateFromString:evt.starttime];
                                                  if ([date compare:now] <= 0) {
                                                      [self.p_events addObject:evt];
                                                  }
                                                  else [self.l_events addObject:evt];
                                                  NSLog(@"successfully load events");
                                                  //NSLog(@"numofevent: %d, count: %d", numOfEvent, count);
                                                  if(count>=numOfEvent) {
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
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
}

@end
