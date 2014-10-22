//
//  Place.h
//  GooglePlaceAPIFun
//
//  Created by user on 5/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (nonatomic)NSString* name;

//place searcg components
@property (nonatomic)NSString* address;
@property (nonatomic)NSString* latitude;
@property (nonatomic)NSString* longitude;
@property (nonatomic)NSString* placeId;
@property (nonatomic)NSString* rating;


//image components
@property (nonatomic)NSString* icon;
@property (nonatomic)NSString* photoReference;
@property (nonatomic)NSString* imageURL;
@property (nonatomic)int photoWidth;
@property (nonatomic)int photoHeigth;

//Place Details attrbiutes
@property (nonatomic)NSString* phoneNumber;
@property (nonatomic)NSString* formattedAddress;
@property (nonatomic)NSString* website;
@property (nonatomic)NSString* url;

@end
