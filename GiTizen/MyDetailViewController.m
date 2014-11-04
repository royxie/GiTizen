//
//  DetailViewController.m
//  sample
//
//  Created by Zhao Yiwei on 10/19/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "MyDetailViewController.h"
#import "UpdateEventViewController.h"

@interface MyDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *categoryText;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (weak, nonatomic) IBOutlet UILabel *nopText;
@property (weak, nonatomic) IBOutlet UILabel *nojText;
@property (weak, nonatomic) IBOutlet UILabel *addrTextView;
@property (weak, nonatomic) IBOutlet UILabel *desTextView;

@end

@implementation MyDetailViewController

@synthesize mapView         = _mapView;
@synthesize newAnnotation   = _newAnnotation;
@synthesize locationManager = _locationManager;

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editEvent)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self configureView];
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(Event*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
}

- (void)editEvent {
    [self performSegueWithIdentifier:@"updateEvent" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"updateEvent"]) {
        [[segue destinationViewController] setMyEvent:self.detailItem];
    }
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
        self.desTextView.text = self.detailItem.desc;
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
