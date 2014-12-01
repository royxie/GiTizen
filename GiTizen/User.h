//
//  User.h
//  GiTizen
//
//  Created by XieShiyu on 30/11/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * gtid;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * sign;

@end
