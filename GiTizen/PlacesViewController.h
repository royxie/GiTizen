//
//  ViewController.h
//  GooglePlaceAPIFun
//
//  Created by user on 5/10/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailGViewController.h"
#import "DetailViewController.h"
#import "Constants.h"
#import "PlacesClient.h"
#import "Place.h"

@interface PlacesViewController : UIViewController

@property (strong,nonatomic) NSString* searchText;

@end
