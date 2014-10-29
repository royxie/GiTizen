//
//  Join.h
//  GiTizen
//
//  Created by XieShiyu on 28/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Join : NSManagedObject

@property (nonatomic, retain) NSString * gtid;
@property (nonatomic, retain) NSString * event_id;

@end
