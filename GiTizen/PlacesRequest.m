//
//  PlacesRequest.m
//  GooglePlaceAPIFun
//
//  Created by user on 8/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "PlacesRequest.h"
#import "PlacesClient.h"

//place search example fom google
//https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&sensor=false&key=AddYourOwnKeyHere&types=police&

//text search example
//https://maps.googleapis.com/maps/api/place/textsearch/output?parameters

//place detail search example
//https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJN1t_tDeuEmsRUsoyG83frY4&key=AddYourOwnKeyHere

@interface PlacesRequest()

@end

@implementation PlacesRequest

+(void)placeRequest:(Request*)request withParameters:(NSDictionary*)parameters completion:(SearchCompletionBlock)completion
{
    NSString* optionString = nil;
    NSString* requestString = nil;

    if (request.search == Photo) {
        optionString = [self parseParametersToStringt:parameters];
        requestString = [NSString stringWithFormat:@"%@%@%@&key=%@",kAPIBaseURL,search(request.search), optionString, kAppKey];
    }
    else{
        optionString = [self parseParametersToStringt:parameters];
        requestString = [NSString stringWithFormat:@"%@%@%@%@&key=%@",kAPIBaseURL,search(request.search), format(request.format), optionString, kAppKey];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (request.type == URL) {
        [self sharedDownloadSession:requestString completion:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            //NSLog(@"%@location:%@\nrespone:%@\nerror:%@\n",nil,location, response, error);
            completion(nil, location, response, error);
        }];
    }
    else {
        [self sharedDataSession:requestString completion:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            //NSLog(@"date:%@%@\nresponse:%@\nerror:%@\n", data, nil, response, error);
            completion(data, nil, response, error);
        }];
    }
}


#pragma mark Option String Creation Method

+(NSString*)parseParametersToStringt:(NSDictionary*)parameters
{
    NSString* result = @"";
    NSArray* keys = [parameters allKeys];
    
    if (!keys) {
        return nil;
    }
    
    for (NSString* key in keys) {

        NSString* str  = [NSString stringWithFormat:@"&%@=%@",key,parameters[key]];
        result = [result stringByAppendingString:str];
    }
    
    //strip the first ampersand
    result = [result substringFromIndex:1];
    return result;
}

+(NSString*)parseNameOption:(NSDictionary*)options
{
    NSString* result = @"&";
    
    NSArray* names = options[@"name"];
    
    if (!names) {
        return nil;
    }
    
    for (NSString* name in names) {
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%@ ",name]];
    }

    return result;
}

+(NSString*)parseLocationOption:(NSDictionary*)option
{
    CLLocation* location = option[@"location"];
    return [NSString stringWithFormat:@"location=%f,%f",location.coordinate.latitude, location.coordinate.longitude];
}

+(NSString*)parseTypesOption:(NSDictionary*)options
{
    NSString* result = @"types=";
    NSArray* types = options[@"types"];
    
    if (!types) {
        return nil;
    }
    
    for (NSString* type in types) {
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%@|",type]];
    }
    
    //remove trailing pipe
    //TODO: validate that this works correctly
    result  = [result substringToIndex:result.length];
    return result;
}

+(NSString*)parseNameZagatselected:(NSDictionary*)options
{
    if (!options[@"zagatselected"]) {
        return nil;
    }
    return @"&zagatselected";;
}



#pragma mark Networking Methods

/*
 * Create and execute an NSURLSession object with default configuration utilizing a download task
 * @param NSString url string to process
 * @return void
 */
+(void)sharedDownloadSession:(NSString*)urlString completion:(DownloadTaskCompletionBlock)completion
{

    NSURL* url = [NSURL URLWithString:urlString];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask* task;
    
    task  = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
       
        if(error){
            completion(nil,response,error);
        }
        else{
            completion(location,response,error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    [task resume];
}

/*
 * Create and execute an NSURLSession object with default configuration utilizing a data task
 * @param NSString url string to process
 * @return void
 */
+(void)sharedDataSession:(NSString*)urlString completion:(DataTaskCompletionBlock)completion
{
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task;
    task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            
            completion(nil,response, error);
        }
        else{
            completion(data,response,error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];

    [task resume];
}


@end
