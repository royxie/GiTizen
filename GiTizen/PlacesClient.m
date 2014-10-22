//
//  PlacesClient.m
//  GooglePlaceAPIFun
//
//  Created by user on 8/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "PlacesClient.h"
#import "PlacesRequest.h"

static NSString* applicationKey;

@interface PlacesClient()

@end

@implementation PlacesClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //default request is nearyby and json
        self.request = [[Request alloc]init];
    }
    return self;
}

+ (instancetype)sharedClient
{
    static id _sharedInstance = nil;
    
    if (!_sharedInstance) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _sharedInstance = [[PlacesClient alloc]init];
        });
        
    }
    return _sharedInstance;
}

+(void)setApplicationKey:(NSString*)appKey
{
    applicationKey = appKey;
}

+(NSString*)applicationKey
{
    return applicationKey;
}

#pragma mark Google Places Search Request Methods
-(void)placeRequest:(Request*)request withParameters:(NSDictionary*)parameters completion:(SearchCompletionBlock)completion;
{
    if (!parameters) {
        return;
    }
    
    switch (request.search) {
        case 0:
            //place search requires location and radius
            if (!parameters[@"location"] && !parameters[@"radius"]) {
                return;
            }
            break;
        case 1:
            //text search requires query
            if (!parameters[@"query"]) {
                return;
            }
            break;
        case 2:
            //details search requires placeID
            if (!parameters[@"placeid"]) {
                return;
            }
            break;
        case 3:
            //photo requires reference and either width or height
            if (!parameters[@"photoreference"] && (!parameters[@"maxwidth"] || !parameters[@"maxheight"])) {
                return;
            }
            break;
            
        default:
            break;
    }

    [PlacesRequest placeRequest:request withParameters:parameters completion:^(NSData *data, NSURL *url, NSURLResponse *response, NSError *error) {
        completion(data, url, response, error);
    }];

}

@end
