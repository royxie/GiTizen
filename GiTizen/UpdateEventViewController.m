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
#import <QuartzCore/QuartzCore.h>
#import "ProgressHUD.h"


@interface UpdateEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *categoryStr;
@property (weak, nonatomic) IBOutlet UITextField *nopStr;
@property (weak, nonatomic) IBOutlet UITextField *titleStr;
@property (weak, nonatomic) IBOutlet UITextView *descStr;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *myEventDatePicker;

@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) UIPickerView *catPicker;
@property (strong, nonatomic) UIToolbar *catPickerToolbar;

@end

@implementation UpdateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initField];
    self.navigationItem.title = @"Update Event";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(putEvents)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.myEventDatePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
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
}

- (void)initField
{
    self.types = [NSArray arrayWithObjects:@"Reading", @"Bar", @"Hangout", @"Food", @"Sport", @"Concert", @"Hiking", @"Drama", nil];
    
    [self.descStr.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.descStr.layer setBorderWidth:2.0];
    self.descStr.layer.cornerRadius = 5;
    self.descStr.clipsToBounds = YES;
    
    self.eventToPut = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
    self.titleStr.text = self.myEvent.g_loc_name;
    self.categoryStr.text = self.myEvent.category;
    self.nopStr.text = self.myEvent.number_of_peo;
    self.descStr.text = self.myEvent.desc;
    
    self.eventToPut = self.myEvent;
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    self.eventToPut.starttime = strDate;
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
    self.eventToPut.number_of_peo = self.nopStr.text;
    self.eventToPut.desc = self.descStr.text;
    //NSLog(@"eventToPut.category: %@, time: %@, number_of_peo: %@, gtid: %@", self.eventToPut.category, self.eventToPut.starttime, self.eventToPut.number_of_peo, self.eventToPut.gtid);
    
    [ProgressHUD show:@"Please wait..."];
    NSString* path = [@"/api/events/" stringByAppendingString:self.eventToPut.object_id];
    [[RKObjectManager sharedManager]       putObject:self.eventToPut
                                                path:path
                                          parameters:nil
                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                 NSLog(@"Successfully updated");
                                                 [ProgressHUD showSuccess:@"Successfully updated"];
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
