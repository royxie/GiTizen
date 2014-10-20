//
//  JSONParser.h
//  GooglePlaceAPIFun
//
//  Created by user on 8/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface JSONParser : NSObject

- (void)processGooglePlacesData:(NSArray*)placesData;

@end
