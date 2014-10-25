//
//  ViewController.m
//  GooglePlaceAPIFun
//
//  Created by user on 5/10/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "PlacesViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "PlacesClient.h"

@interface PlacesViewController ()< UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate >


@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic) NSArray* googlePlaces;
@property (nonatomic) NSMutableArray* places;
@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) CLLocation* currentLocation;
@property (nonatomic) NSNumber* radius;
@property (nonatomic) UIRefreshControl* refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic)PlacesClient* client;

@end

@implementation PlacesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.searchBar.text = self.searchText;
    NSLog(@"self.searchBar: %@",self.searchBar.text);

    self.places = [NSMutableArray new];
    
    _radius = [NSNumber numberWithInt:5000];
    
    //create a locaiton manager and set ourselves as delegate
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    
    //get the users current location
    [_locationManager startUpdatingLocation];
    
    //create a table view controller to allow for refresh control
    UITableViewController *tableViewController = [[UITableViewController alloc]init];

    //set the table view controller's table view
    tableViewController.tableView =  self.myTableView;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    //create a refresh control
    self.refreshControl = [[UIRefreshControl alloc]init];
    
    //configure the refresh control
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    //set the table view controllers refresh control
    tableViewController.refreshControl = self.refreshControl;
    
    //create instance of shared client
    _client = [PlacesClient sharedClient];
    
    // invoke the search automatically
    [self searchBarSearchButtonClicked:self.searchBar];
    
}

#pragma mark - Managing the search text item
- (void)setSearchText:(NSString*)newsearchText {
    if (_searchText != newsearchText) {
        _searchText = newsearchText;
    }
}

#pragma mark - UIRefreshControl Method

- (void)refresh:(id)sender
{
   [self.refreshControl endRefreshing];
}

// remove space in a string
-(NSString*) removeSpace:(NSString*) s
{
    return [s stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - UISearchBarControllerDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (![searchBar.text isEqualToString:@""] )
    {
        self.searchText = [self removeSpace:searchBar.text];
        //NSLog(@"searchBar: %@",self.searchText);
        NSString* location = [NSString stringWithFormat:@"%f,%f",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
        
        NSDictionary* parameters = @{@"query":self.searchText, @"location":location, @"radius":@5000};
        _client.request.search = Text;
        
        [_client placeRequest:_client.request withParameters:parameters completion:^(NSData *data, NSURL *url, NSURLResponse *response, NSError *error) {
            if (!error) {
                [self processJSONData:data];
            }
            else{
                NSLog(@"error %@",[error userInfo]);
            }
        }];
    }
    
    [self.searchBar endEditing:YES];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar endEditing:YES];
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _googlePlaces.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"CellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    Place* place = _places[indexPath.row];
    //NSLog(@"place: %@",place);
    cell.textLabel.text = place.name; //place[@"name"];
    cell.detailTextLabel.text = place.address; //place[@"vicinity"];
    
    if (place.photoReference) {
        
        NSDictionary* parameters = @{@"photoreference":place.photoReference, @"maxwidth":@1000};;
        _client.request.search = Photo;
        
        [_client placeRequest:_client.request withParameters:parameters completion:^(NSData *data, NSURL *url, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = [self resizeImage:[UIImage imageWithData:data] toWidth:300 andHeight:300];
                [cell setNeedsLayout];
            });
        }];
        
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"default_location"];
    }
    
    //TODO: we need to update the place details once the place is on the screen
    
    return cell;
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLocation = locations.firstObject;
    
    [_locationManager stopUpdatingLocation];
    
    NSString* location = [NSString stringWithFormat:@"%f,%f",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
    
    NSDictionary* parameters = @{@"location":location, @"radius":@5000};


    //set request type NearBy, Text, Details or Photo (default is NearBy)
    _client.request.search = NearBy;
    
    //set the request type data or local url
    _client.request.type = Data;
    
    //set the format type JSON or XML (default is XML)
    _client.request.format = JSON;
    
    
    [_client placeRequest:_client.request withParameters:parameters completion:^(NSData *data, NSURL *url, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            [self processJSONData:data];
        }
        else{
            [error userInfo];
        }
    }];
}


/*
 *
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"])
    {
        NSIndexPath* indexPath = [self.myTableView indexPathForCell:sender];
        DetailGViewController *vc = segue.destinationViewController;
        vc.place = self.places[[indexPath row]];
        //NSLog(@"%@",vc.place);
    }
}


/*
 * Process the data returned from the call to Google places API
 * @param NSData JSON data to be processed
 * @return void
 */
- (void)processJSONData:(NSData *)data
{
    //clear the Places arrat
    [self.places removeAllObjects];
    
    NSError* error = nil;
    NSDictionary* jsondata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if ([jsondata[@"status"] isEqualToString:@"OK"])
    {
        _googlePlaces = jsondata[@"results"];
    
        //covnert JSON data to custom object
        [self processGooglePlacesData];

    }
    else if(![jsondata[@"status"] isEqualToString:@"OK"])
    {
        NSString * status = jsondata[@"status"];
        
        //create and display alert view
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:status delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    else
    {
        NSLog(@"error %@",[error userInfo]);
    }
}


/*
 * Convert the array of data returned from the Google places API
 * @param void
 * @return void
 */
- (void)processGooglePlacesData
{
    Place* place = nil;
    
    for (NSDictionary* location in self.googlePlaces)
    {
        place = [[Place alloc]init];
        place.name = location[@"name"];
        place.address = location[@"vicinity"];
        place.photoReference = [location[@"photos"] firstObject][@"photo_reference"];
        place.imageURL = [location[@"photos"]firstObject][@"photo_reference"];
        place.placeId = location[@"place_id"];
        place.icon = location [@"icon"];
        place.rating = location[@"rating"];
        [self.places addObject:place];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myTableView reloadData];
        });
    }
}


/*
 * Simple function to resize the image. This function does not retain the true aspect of 
 * the image that is scaled
 * @param UIImage, width, height
 * @return UIImage
 */
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}


@end
