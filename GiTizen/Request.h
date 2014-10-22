//
//  Request.h
//  GooglePlaceAPIFun
//
//  Created by user on 8/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Request : NSObject

@property(nonatomic) SearchType search;
@property(nonatomic) RequestFormat format;
@property(nonatomic) RequestType type;

@end
