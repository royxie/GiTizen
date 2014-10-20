//
//  JSONParser.m
//  GooglePlaceAPIFun
//
//  Created by user on 8/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "JSONParser.h"
#import "Place.h"
#import <UIKit/UIKit.h>
#import <UIkit/UIApplication.h>

@implementation JSONParser


/*
 * Process the data returned from the call to Google places API
 * @param NSData JSON data to be processed
 * @return void
 */
- (void)processJSONData:(NSData *)data
{

    NSArray* googlePlaces = nil;
    
    NSError* error = nil;
    NSDictionary* jsondata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if ([jsondata[@"status"] isEqualToString:@"OK"])
    {
        googlePlaces = jsondata[@"results"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        //covnert JSON data to custom object
        [self processGooglePlacesData:googlePlaces];        
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
 * Convert the array of data returned from the Google places API in Place Objects
 * @param void
 * @return void
 */
- (void)processGooglePlacesData:(NSArray*)placesData
{
    Place* place = nil;
    
    NSMutableArray* places = [NSMutableArray new];
    
    for (NSDictionary* location in placesData)
    {
        place = [[Place alloc]init];
        place.name = location[@"name"];
        place.address = location[@"vicinity"];
        place.photoReference = [location[@"photos"] firstObject][@"photo_reference"];
        place.imageURL = [location[@"photos"]firstObject][@"photo_reference"];
        place.placeId = location[@"place_id"];
        place.icon = location [@"icon"];
        place.rating = location[@"rating"];
        place.phoneNumber = location[@"formattedPhoneNumber"] ? location[@"formattedPhoneNumber"]:nil;
        [places addObject:place];
    }
}

- (void)processPlacesDetailsData:(Place*)place details:(NSDictionary*)details
{
    place.formattedAddress = details[@"formatted_address"];
    place.phoneNumber = details[@"formatted_phone_number"];
    place.website = details[@"website"];
    place.url = details[@"url"];
}

@end
