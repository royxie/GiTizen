//
//  Request.m
//  GooglePlaceAPIFun
//
//  Created by user on 8/15/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "Request.h"

@implementation Request

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.search = NearBy;
        self.type = Data;
        self.format = JSON;
        
    }
    return self;
}

@end
