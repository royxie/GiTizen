//
//  DetailViewController.m
//  GooglePlaceAPIFun
//
//  Created by user on 5/24/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "DetailGViewController.h"
#import "PostEventViewController.h"
#import "PlacesClient.h"

@interface DetailGViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *ratingTextField;
@property (weak, nonatomic) IBOutlet UITextField *websiteTextField;


@end

@implementation DetailGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"confirm" style:UIBarButtonItemStylePlain target:self action:@selector(selectLocation)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.nameTextField.text = self.place.name;
    self.ratingTextField.text = [NSString stringWithFormat:@"%@",self.place.rating ? self.place.rating:@""];

    
    PlacesClient* client = [PlacesClient sharedClient];

    NSDictionary* parameters = @{@"placeid":self.place.placeId};
    client.request.search = Details;
    client.request.type = Data;
    
    [client placeRequest:client.request withParameters:parameters completion:^(NSData *data, NSURL *url, NSURLResponse *response, NSError *error) {
        [self processJSONData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.addressTextView.text = self.place.formattedAddress;
            self.urlTextField.text = self.place.url;
            self.phoneTextField.text = self.place.phoneNumber;
            self.websiteTextField.text =  self.place.website;
        });

    }];
    
}

-(void) selectLocation
{
    // goes back to the postevent view on stack.
    //UIViewController* postEventViewController = [[PostEventViewController alloc] init];
    //[[self navigationController] popToViewController: postEventViewController animated:YES];
    PostEventViewController *peViewController = [self.navigationController.viewControllers objectAtIndex:1];
    [peViewController setGPlace:self.place];
    [self.navigationController popToViewController: peViewController animated:YES];
}


/*
 * Process the data returned from the call to Google places API
 * @param NSData JSON data to be processed
 * @return void
 */
- (void)processJSONData:(NSData *)data
{
    
    NSDictionary* placeDetails = nil;
    
    NSError* error = nil;
    NSDictionary* jsondata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if ([jsondata[@"status"] isEqualToString:@"OK"])
    {
        placeDetails = jsondata[@"result"];
        
        //covnert JSON data to custom object
        [self processPlacesDetailsData:placeDetails];
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

- (void)processPlacesDetailsData:(NSDictionary*)placesDetail
{
    self.place.formattedAddress = placesDetail[@"formatted_address"];
    self.place.phoneNumber = placesDetail[@"formatted_phone_number"];
    self.place.website = placesDetail[@"website"];
    self.place.url = placesDetail[@"url"];
}


@end
