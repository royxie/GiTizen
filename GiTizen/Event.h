//
//  Event.h
//  GiTizen
//
//  Created by XieShiyu on 25/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * g_loc_addr;
@property (nonatomic, retain) NSString * g_loc_icon;
@property (nonatomic, retain) NSString * g_loc_id;
@property (nonatomic, retain) NSString * g_loc_name;
@property (nonatomic, retain) NSString * gtid;
@property (nonatomic, retain) NSString * number_joined;
@property (nonatomic, retain) NSString * number_of_peo;
@property (nonatomic, retain) NSString * object_id;
@property (nonatomic, retain) NSString * starttime;
@property (nonatomic, retain) NSString * g_loc_lon;
@property (nonatomic, retain) NSString * g_loc_lat;
@property (nonatomic, retain) NSString * desc;

@end
