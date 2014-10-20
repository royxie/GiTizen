//
//  EventCenterTableViewController.m
//  GiTizen
//
//  Created by Zhao Yiwei on 10/19/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "EventCenterTableViewController.h"
#import <RestKit/RestKit.h>
#import "Event.h"
#import "EventCenterTableViewCell.h"
#import "DetailViewController.h"


@interface EventCenterTableViewController ()

@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) EventCenterTableViewCell *eventCell;

@end

@implementation EventCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterEvents)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postNewEvents)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self loadEvents];
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
    
    self.eventCell.categoryLabel.text = event.category;
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/events"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.events = mappingResult.array;
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
}

-(void)postEvents
{
     NSDictionary *queryParams = @{@"g_loc_name" : @"sxie40",
     @"starttime" : @"gatech",
     @"num_of_peo" : @"10am",
     @"category" : @"travel",     
     };
    
    
    Event* eventToPost;
    
    [[RKObjectManager sharedManager]    postObject:eventToPost
                                              path:@"/api/events"
                                        parameters:queryParams
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               self.events = mappingResult.array;
                                               [self.tableView reloadData];
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
}
/*
- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSAssert(object || path, @"Cannot make a request without an object or a path.");
    RKObjectRequestOperation *operation = [self appropriateObjectRequestOperationWithObject:object method:RKRequestMethodPOST path:path parameters:parameters];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [self enqueueObjectRequestOperation:operation];
}
*/

- (IBAction)refresh:(id)sender {
    [self loadEvents];
}


@end
