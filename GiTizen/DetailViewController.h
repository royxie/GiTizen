//
//  DetailViewController.h
//  sample
//
//  Created by Zhao Yiwei on 10/19/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventCenterTableViewController.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Event* detailItem;

@end

