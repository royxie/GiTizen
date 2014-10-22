//
//  Constants.h
//  GooglePlaceAPIFun
//
//  Created by user on 8/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString* const kJSON;

//base url
extern NSString* const kAPIBaseURL;

//format formate constants
extern NSString* const kXML;
extern NSString* const kAppKey;

//request types contants
extern NSString* const kNearBy;
extern NSString* const kText;
extern NSString* const kDetails;
extern NSString* const kPhoto;

extern NSString* const kSensor;
extern int const kMaxHeight;
extern int const kMaxWidth;

//create macros to convert enum to string
#define format(enum) [@[kJSON,kXML] objectAtIndex:enum]
#define search(enum) [@[kNearBy,kText,kDetails,kPhoto] objectAtIndex:enum]


@interface Constants : NSObject

//declare a completion block for retrieving JSON data vis NSURLConnection
typedef void (^NSURLCompletionBlock)(NSURLResponse *response, NSData *data, NSError *connectionError);

//declare a completion block for retrieving photo
typedef void (^PhotoCompletionBlock)(BOOL succeeded, UIImage *image, NSError* error);

//define completion block for retrieving JSON data vis NSURLSession
typedef void (^DownloadTaskCompletionBlock)(NSURL *location, NSURLResponse *response, NSError *error);
typedef void (^DataTaskCompletionBlock)(NSData *data, NSURLResponse *response, NSError *error);

typedef void (^SearchCompletionBlock)(NSData *data, NSURL* url, NSURLResponse *response, NSError *error);



typedef enum _SearchType {
    NearBy = 0,
    Text = 1,
    Details = 2,
    Photo = 3
} SearchType;


typedef enum _RequestFormat {
    JSON = 0,
    XML = 1,
} RequestFormat;

typedef enum _RequestType {
    Data  = 0,
    URL = 1,
} RequestType;


@end
