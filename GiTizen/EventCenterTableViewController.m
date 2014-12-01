//
//  EventCenterTableViewController.m
//  GiTizen
//
//  Created by Zhao Yiwei on 10/19/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "EventCenterTableViewController.h"
#import "ProgressHUD.h"


@interface EventCenterTableViewController ()

@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *l_events;
@property (strong, nonatomic) EventCenterTableViewCell *eventCell;

@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) UIPickerView *catPicker;
@property (strong, nonatomic) UIToolbar *catPickerToolbar;
@property (strong, nonatomic) NSString* selectedCat;

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
    
    //[self loadEvents];
    [self loadPickerView];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (ifUserLogin() == NO)
        LoginUser(self);
    
    [self loadEvents];
}


-(void) init_field {
    self.events = [NSMutableArray new];
    self.l_events = [NSMutableArray new];
    self.types = [NSArray arrayWithObjects:@"Reading", @"Bar", @"Hangout", @"Food", @"Sport", @"Concert", @"Hiking", @"Drama", nil];
}



-(void) loadPickerView {
    
    self.catPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 420, 420, 500)];
    self.catPicker.delegate = self;
    self.catPicker.showsSelectionIndicator = YES;
    self.catPicker.hidden = YES;
    [self.view addSubview:[self catPicker]];
    self.catPicker.backgroundColor = [UIColor whiteColor];
    [self.catPicker setDataSource: self];
    [self.catPicker setDelegate: self];
    //self.categoryStr.inputView = self.catPicker;
    
    self.catPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 380, 320, 40)];
    self.catPickerToolbar.delegate = self;
    self.catPickerToolbar.hidden = YES;
    [self.view addSubview:[self catPickerToolbar]];
    self.catPickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    //self.catPickerToolbar.tintColor = [UIColor blueColor];
    self.catPickerToolbar.tintColor = [UIColor yellowColor];
    self.catPickerToolbar.alpha = 0.7;
    [self.catPickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    
    [barItems addObject:doneBtn];
    
    [self.catPickerToolbar setItems:barItems animated:YES];
}


-(void)pickerDoneClicked {
    self.catPickerToolbar.hidden=YES;
    self.catPicker.hidden=YES;
    self.tableView.scrollEnabled = YES;
    [self loadEventswithCategory:[self selectedCat]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component {
    self.selectedCat = self.types[row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.types count];
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.types objectAtIndex:row];
}



- (void) filterEvents {
    self.catPicker.hidden = NO;
    self.catPickerToolbar.hidden = NO;
    self.tableView.scrollEnabled = NO;
    [self.view insertSubview:[self catPicker] aboveSubview:nil];
    //[self refresh];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    [ProgressHUD show:nil];
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
                                                  [ProgressHUD dismiss];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                                  [ProgressHUD showError:@"Network error."];
                                              }];
}

-(void)loadEventswithCategory:(NSString*)category
{
    [ProgressHUD show:nil];
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
                                                      BOOL catmatch = [category isEqualToString:evt.category];
                                                      if ([date compare:now] > 0 && catmatch) {
                                                          [self.l_events addObject:evt];
                                                      }
                                                  }
                                                  [self.l_events sortUsingComparator:^NSComparisonResult(Event* a, Event* b) {
                                                      NSDate *date1 = [dateFormatter dateFromString:a.starttime];
                                                      NSDate *date2 = [dateFormatter dateFromString:b.starttime];
                                                      return [date1 compare:date2];
                                                  }];
                                                  
                                                  [self.tableView reloadData];
                                                  [ProgressHUD dismiss];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
}

@end
