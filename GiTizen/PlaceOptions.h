//
//  PlaceSearchOptions.h
//  GooglePlaceAPIFun
//
//  Created by user on 8/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceOptions : NSObject

@property(nonatomic)NSDictionary* rankby;
@property(nonatomic)NSArray* names;
@property(nonatomic)NSArray* types;
@property(nonatomic)NSString* keyword;
@property(nonatomic)NSString* language;
@property(nonatomic)NSString* zagatselected;
@property(nonatomic)NSString* opennow;
@property(nonatomic)NSString* minPrice;
@property(nonatomic)NSString* maxPrice;

@end
