//
//  PlacesClient.h
//  GooglePlaceAPIFun
//
//  Created by user on 8/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Request.h"
#import <UIKit/UIKit.h>

@class CLLocation;

@interface PlacesClient : NSObject

+(id)sharedClient;

@property(nonatomic)Request* request;

+(void)setApplicationKey:(NSString*)appKey;
+(NSString*)applicationKey;


-(void)placeRequest:(Request*)request withParameters:(NSDictionary*)parameters completion:(SearchCompletionBlock)completion;;

@end
