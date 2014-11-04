//
//  PostEventViewController.m
//  GiTizen
//
//  Created by Zhao Yiwei on 10/19/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "PostEventViewController.h"
#import "EventCenterTableViewCell.h"
#import "PlacesViewController.h"
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface PostEventViewController ()<CLLocationManagerDelegate, UISearchBarDelegate >

@property (strong, nonatomic) Event *eventToPost;
@property (weak, nonatomic) IBOutlet UITextField *categoryStr;
@property (weak, nonatomic) IBOutlet UITextField *nopStr;
@property (weak, nonatomic) IBOutlet UITextField *titleStr;
@property (weak, nonatomic) IBOutlet UITextView *descStr;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventDatePicker;

@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) UIPickerView *catPicker;
@property (strong, nonatomic) UIToolbar *catPickerToolbar;

@end

@implementation PostEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initField];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postIt)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.eventDatePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self loadPickerView];
}

-(void) loadPickerView {
    self.catPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, 320, 480)];
    self.catPicker.backgroundColor = [UIColor clearColor];
    [self.catPicker setDataSource: self];
    [self.catPicker setDelegate: self];
    self.catPicker.showsSelectionIndicator = YES;
    self.categoryStr.inputView = self.catPicker;
    
    self.catPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.catPickerToolbar.barStyle = UIBarStyleBlackOpaque;
    self.catPickerToolbar.tintColor = [UIColor blueColor];
    self.catPickerToolbar.alpha = 0.7;
    [self.catPickerToolbar sizeToFit];
    
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    
    [barItems addObject:doneBtn];
    
    [self.catPickerToolbar setItems:barItems animated:YES];
    
    self.categoryStr.inputAccessoryView = self.catPickerToolbar;
}

-(void)pickerDoneClicked {
    //NSLog(@"Done Clicked");
    [self.categoryStr resignFirstResponder];
    //self.catPickerToolbar.hidden=YES;
    //self.catPicker.hidden=YES;
}

- (void)initField
{
    self.types = [NSArray arrayWithObjects:@"Reading", @"Bar", @"Hangout", @"Food", @"Sport", @"Concert", @"Hiking", @"Drama", nil];
    
    self.eventToPost = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
    //UIImage *btnImage = [UIImage imageNamed:@"image.png"];
    //[self.searchButton setImage:btnImage forState:UIControlStateNormal];
    //[self.searchButton addTarget:self action:@selector(buttonCLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.descStr.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.descStr.layer setBorderWidth:2.0];
    self.descStr.layer.cornerRadius = 5;
    self.descStr.clipsToBounds = YES;
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    self.eventToPost.starttime = strDate;
    NSLog(@"date: %@", self.eventToPost.starttime);
}

#pragma mark - Managing the Google location information item
- (void)setGPlace:(Place*) googlePlace {
    if (_gPlace != googlePlace) {
        _gPlace = googlePlace;
        self.titleStr.text = _gPlace.name;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchLoc"])
    {
        [segue.destinationViewController setSearchText:self.titleStr.text];
    }
}
    
- (void)postIt {
    if(self.gPlace){
        self.eventToPost.g_loc_name = self.gPlace.name;
        self.eventToPost.g_loc_addr = self.gPlace.formattedAddress;
        self.eventToPost.g_loc_id = self.gPlace.placeId;
        self.eventToPost.g_loc_icon = self.gPlace.icon;
        self.eventToPost.g_loc_lat = self.gPlace.latitude;
        self.eventToPost.g_loc_lon = self.gPlace.longitude;
    }
    
    NSString* userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    self.eventToPost.gtid = userid;
    //NSLog(@"longtitude: %@, altitude: %@",self.gPlace.longitude, self.gPlace.latitude);

    self.eventToPost.category = self.categoryStr.text;
    self.eventToPost.number_of_peo = self.nopStr.text;
    self.eventToPost.number_joined = [NSString stringWithFormat:@"%ld", (long)1];
    self.eventToPost.desc = self.descStr.text;
    
    [[RKObjectManager sharedManager]    postObject:self.eventToPost
                                              path:@"/api/events"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               NSLog(@"Post succeeded");
                                               [self postJoin];
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) postJoin {
    
    Join* joinedEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Join" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
    
    NSString* userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    joinedEvent.gtid = userid;
    joinedEvent.event_id = self.eventToPost.object_id;
    
    [[RKObjectManager sharedManager]    postObject:joinedEvent
                                              path:@"/api/joins"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               NSLog(@"Joined event post succeeded");
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component {
    self.categoryStr.text = self.types[row];
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

@end
