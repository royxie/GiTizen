//
//  PlacesRequest.h
//  GooglePlaceAPIFun
//
//  Created by user on 8/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>

@protocol PlacesRequestDelegate;
@class  Request;

@interface PlacesRequest : NSObject

@property(nonatomic,weak) id <PlacesRequestDelegate> delegate;

+(void)placeRequest:(Request*)request withParameters:(NSDictionary*)parameters completion:(SearchCompletionBlock)completion;

@end

@protocol PlacesRequestDelegate <NSObject>



@end
