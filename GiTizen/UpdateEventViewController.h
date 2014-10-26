//
//  UpdateEventViewController.h
//  GiTizen
//
//  Created by XieShiyu on 26/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Place.h"

@interface UpdateEventViewController : UIViewController

@property (strong,nonatomic) Place* gPlace;
@property (strong,nonatomic) Event* myEvent;
@property (strong,nonatomic) Event* eventToPut;

@end
