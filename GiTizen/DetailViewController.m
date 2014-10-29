//
//  DetailViewController.m
//  sample
//
//  Created by Zhao Yiwei on 10/19/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *categoryText;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (weak, nonatomic) IBOutlet UILabel *nopText;
@property (weak, nonatomic) IBOutlet UILabel *nojText;
@property (weak, nonatomic) IBOutlet UILabel *addrTextView;
@property (weak, nonatomic) IBOutlet UILabel *desTextView;


@end

@implementation DetailViewController

@synthesize mapView         = _mapView;
@synthesize newAnnotation   = _newAnnotation;
@synthesize locationManager = _locationManager;

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
    
    UIBarButtonItem *joinButton = [[UIBarButtonItem alloc] initWithTitle:@"Join now!" style:UIBarButtonItemStylePlain target:self action:@selector(joinEvent)];
    UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:@"Quit" style:UIBarButtonItemStylePlain target:self action:@selector(quitEvent)];
    
    NSArray* views = self.navigationController.viewControllers;
    if ([views[views.count-2] class] == [EventCenterTableViewController class]) {
        self.navigationItem.rightBarButtonItem = joinButton;
    }
    else if ([views[views.count-2] class] == [MyJoinedEventTableViewController class]) {
        self.navigationItem.rightBarButtonItem = quitButton;
    }
    [self configureView];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(Event*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
}

- (void) quitEvent {
    [self deleteJoin];
}

- (void) deleteJoin {
    
    NSString* userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    NSString* path = [[@"/api/joins/" stringByAppendingString:userid] stringByAppendingString:@"/"];
    path = [path stringByAppendingString:self.detailItem.object_id];
    
    [[RKObjectManager sharedManager]  deleteObject:NULL
                                              path:path
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               NSLog(@"joins successfully deleted");
                                               UIAlertView* quitSuccess = [[UIAlertView alloc] initWithTitle:@"Quit" message:@"Successfully quited" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                               [quitSuccess show];
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
}


- (void) joinEvent {
    [self loadJoinedEvents];
}


-(void)loadJoinedEvents
{
    NSString* userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    NSString* myPath = [@"/api/joins/gtid/" stringByAppendingString:userid];
    NSString* object_id = self.detailItem.object_id;
    
    [[RKObjectManager sharedManager] getObjectsAtPath:myPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSLog(@"successfully load joinedEvents");
                                                  NSMutableArray* joinedEvents = [NSMutableArray new];
                                                  joinedEvents = [NSMutableArray arrayWithArray: mappingResult.array];
                                                  BOOL join_flag = false;
                                                  for(Join* join in joinedEvents) {
                                                      if([join.event_id isEqualToString: object_id]) {
                                                          UIAlertView* joinSuccess = [[UIAlertView alloc] initWithTitle:@"Join" message:@"you have already joined this event" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                          [joinSuccess show];
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                          join_flag = true;
                                                          break;
                                                      }
                                                  }
                                                  if(!join_flag){
                                                      [self postJoin];
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
    
}

-(void) postJoin {
    
    Join* joinedEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Join" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
    
    NSString* userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    joinedEvent.gtid = userid;
    joinedEvent.event_id = self.detailItem.object_id;
    
    [[RKObjectManager sharedManager]    postObject:joinedEvent
                                              path:@"/api/joins"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               NSLog(@"Joined event post succeeded");
                                               [self loadandUpdateEvent];
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
}

-(void)loadandUpdateEvent
{
    NSString* myPath = [@"/api/events/" stringByAppendingString:self.detailItem.object_id];

    [[RKObjectManager sharedManager] getObjectsAtPath:myPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSLog(@"Successfully load jointed event");
                                                  Event* event = mappingResult.firstObject;
                                                  int num = [event.number_joined intValue];
                                                  NSLog(@"num: %d", num);
                                                  if(num >= [event.number_of_peo intValue]) {
                                                      UIAlertView* joinSuccess = [[UIAlertView alloc] initWithTitle:@"Join" message:@"Sorry, no more seats available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                      [joinSuccess show];
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  }
                                                  else {
                                                      event.number_joined = [NSString stringWithFormat:@"%ld", (long)(num+1)];
                                                      NSLog(@"no. of joined: %@", event.number_joined);
                                                      [self putEvent: event];
                                                      UIAlertView* joinSuccess = [[UIAlertView alloc] initWithTitle:@"Join" message:@"Successfully joined!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                      [joinSuccess show];
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
}

-(void)putEvent: (Event*) eventToPut
{
    
    NSString* path = [@"/api/events/" stringByAppendingString:eventToPut.object_id];
    [[RKObjectManager sharedManager]       putObject:eventToPut
                                                path:path
                                          parameters:nil
                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                 NSLog(@"Successfully updated with number_joined incremented");
                                             }
                                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                 NSLog(@"error occurred': %@", error);
                                             }];
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.categoryText.text = self.detailItem.category;
        self.nameText.text = self.detailItem.g_loc_name;
        self.timeText.text = self.detailItem.starttime;
        self.nopText.text = self.detailItem.number_of_peo;
        self.nojText.text = self.detailItem.number_joined;
        self.addrTextView.text = self.detailItem.g_loc_addr;
        self.desTextView.text = @"All welcome!!";
    }
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate        = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    CGRect  viewRect = CGRectMake(0, (self.view.frame.size.height)*2/3, (self.view.frame.size.width), (self.view.frame.size.height)/3);
    self.mapView                   = [[MKMapView alloc] initWithFrame:viewRect];
    self.mapView.delegate          = self;
    self.mapView.showsUserLocation = YES;
    
    [self.view addSubview:self.mapView];
    [self.view bringSubviewToFront:self.mapView];
    
    NSMutableArray *poiAnnotationArray  = [[NSMutableArray alloc] init];
    NSMutableArray *selected = [[NSMutableArray alloc] init];
    
    CLLocationDegrees poiOneLat  = [self.detailItem.g_loc_lat doubleValue];
    CLLocationDegrees poiOneLong = [self.detailItem.g_loc_lon doubleValue];
    
    CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:poiOneLat longitude:poiOneLong];
    
    self.newAnnotation = [Annotation annotationWithCoordinate:firstLocation.coordinate];
    
    self.newAnnotation.title    = self.detailItem.g_loc_name;
    
    [poiAnnotationArray addObject:self.newAnnotation];
    
    [selected addObject:self.newAnnotation];
    
    
    [self.mapView addAnnotations:poiAnnotationArray];
    self.mapView.selectedAnnotations = selected;
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = poiOneLat;
    newRegion.center.longitude = poiOneLong;
    newRegion.span.latitudeDelta = 0.01;
    newRegion.span.longitudeDelta = 0.01;
    
    [self.mapView setRegion:newRegion animated:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    
}
@end
