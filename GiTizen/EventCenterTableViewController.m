//
//  EventCenterTableViewController.m
//  GiTizen
//
//  Created by Zhao Yiwei on 10/19/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "EventCenterTableViewController.h"


@interface EventCenterTableViewController ()

@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *l_events;
@property (strong, nonatomic) EventCenterTableViewCell *eventCell;

@end

@implementation EventCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init_field];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.navigationItem.title = @"Event Center";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterEvents)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postNewEvents)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self loadEvents];
}

-(void) init_field {
    self.events = [NSMutableArray new];
    self.l_events = [NSMutableArray new];
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
    return self.l_events.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.eventCell = [tableView dequeueReusableCellWithIdentifier:@"EventCenterTableViewCell"];// forIndexPath:indexPath];
    
    self.eventCell = [[[NSBundle mainBundle] loadNibNamed:@"EventCenterTableViewCell" owner:self options:nil] lastObject];

    [self configureCell:self.l_events atIndexPath:indexPath];
    
    return self.eventCell;
}

- (void)configureCell:(NSMutableArray*)evts atIndexPath:(NSIndexPath *)indexPath
{
    Event *event = evts[indexPath.row];
    
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
    
    [self performSegueWithIdentifier:@"eventDetail" sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"eventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Event *selectedEvent = self.l_events[indexPath.row];
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


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


-(void)loadEvents
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/events"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.events = mappingResult.array;
                                                  [self.l_events removeAllObjects];
                                                  
                                                  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                                                  dateFormatter.dateFormat = @"MM-dd-yyyy HH:mm";
                                                  NSDate *now = [NSDate date];
                                                  for(Event* evt in self.events) {
                                                      NSDate * date = [dateFormatter dateFromString:evt.starttime];
                                                      if ([date compare:now] > 0) {
                                                          [self.l_events addObject:evt];
                                                      }
                                                  }
                                                  [self.l_events sortUsingComparator:^NSComparisonResult(Event* a, Event* b) {
                                                      
                                                      NSDate *date1 = [dateFormatter dateFromString:a.starttime];
                                                      NSDate *date2 = [dateFormatter dateFromString:b.starttime];
                                                      
                                                      return [date1 compare:date2];
                                                  }];
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
}

@end
