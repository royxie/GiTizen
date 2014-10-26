//
//  User.h
//  GiTizen
//
//  Created by XieShiyu on 26/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * gtid;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * username;

@end
