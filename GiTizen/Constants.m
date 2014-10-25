//
//  Constants.m
//  GooglePlaceAPIFun
//
//  Created by user on 8/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "Constants.h"
#import "PlacesClient.h"

@implementation Constants

NSString* const kSensor = @"true";

NSString* const kAppKey = @"AIzaSyAgTzNZ2rVo5ms12X2OUOC5qizYk8PRDG8";

//format types
NSString* const kJSON = @"json?";
NSString* const kXML = @"xml?";

//request types
NSString* const kNearBy = @"nearbysearch/";
NSString* const kText = @"textsearch/";
NSString* const kDetails = @"details/";
NSString* const kPhoto = @"photo?";

NSString* const kAPIBaseURL = @"https://maps.googleapis.com/maps/api/place/";

//photo reference defaults
int const kMaxHeight = 300;
int const kMaxWidth = 300;

@end
