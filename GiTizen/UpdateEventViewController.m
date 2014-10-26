//
//  UpdateEventViewController.m
//  GiTizen
//
//  Created by XieShiyu on 26/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "UpdateEventViewController.h"
#import "EventCenterTableViewCell.h"
#import "PlacesViewController.h"
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UpdateEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *categoryStr;
@property (weak, nonatomic) IBOutlet UITextField *timeStr;
@property (weak, nonatomic) IBOutlet UITextField *nopStr;
@property (weak, nonatomic) IBOutlet UITextField *titleStr;
@property (weak, nonatomic) IBOutlet UITextView *descStr;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation UpdateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initField];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(putEvents)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)initField
{
    self.eventToPut = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
    self.titleStr.text = self.myEvent.g_loc_name;
    self.categoryStr.text = self.myEvent.category;
    self.timeStr.text = self.myEvent.starttime;
    self.nopStr.text = self.myEvent.number_of_peo;
    self.descStr.text = self.myEvent.desc;
    
    self.eventToPut = self.myEvent;
}

#pragma mark - Managing the event item to update
- (void)setMyEvent:(Event*)newMyEvent {
    if (_myEvent != newMyEvent) {
        _myEvent = newMyEvent;
    }
}

#pragma mark - Managing the Google location information item
- (void)setGPlace:(Place*) googlePlace {
    if (_gPlace != googlePlace) {
        _gPlace = googlePlace;
        self.titleStr.text = _gPlace.name;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchLoc"])
    {
        [segue.destinationViewController setSearchText:self.titleStr.text];
    }
}

-(void)putEvents
{
    if(self.gPlace){
        self.eventToPut.g_loc_name = self.gPlace.name;
        self.eventToPut.g_loc_addr = self.gPlace.formattedAddress;
        self.eventToPut.g_loc_id = self.gPlace.placeId;
        self.eventToPut.g_loc_icon = self.gPlace.icon;
        self.eventToPut.g_loc_lat = self.gPlace.latitude;
        self.eventToPut.g_loc_lon = self.gPlace.longitude;
    }
    self.eventToPut.category = self.categoryStr.text;
    self.eventToPut.starttime = self.timeStr.text;
    self.eventToPut.number_of_peo = self.nopStr.text;
    self.eventToPut.desc = self.descStr.text;
    //NSLog(@"eventToPut.category: %@, time: %@, number_of_peo: %@, gtid: %@", self.eventToPut.category, self.eventToPut.starttime, self.eventToPut.number_of_peo, self.eventToPut.gtid);
    
    NSString* path = [@"/api/events/" stringByAppendingString:self.eventToPut.object_id];
    [[RKObjectManager sharedManager]       putObject:self.eventToPut
                                                path:path
                                          parameters:nil
                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                 NSLog(@"Successfully updated");
                                             }
                                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                 NSLog(@"error occurred': %@", error);
                                             }];
    
    NSArray* views = self.navigationController.viewControllers;
    [self.navigationController popToViewController: views[views.count-3] animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
