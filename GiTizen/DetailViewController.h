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
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"


//#define kPhoenixLat 35.17939
//#define kPhoenixLong -89.83051
//#define kXBldgLat 35.15581
//#define kXBldgLong -90.04616
/**
 * Change these values for region zooming when the map loads
 */
#define kDeltaLat 1.0f
#define kDeltaLong 1.0f
@interface DetailViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView *_mapView;
    Annotation *_newAnnotation;
    CLLocationManager *_locationManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (strong, nonatomic) Event* detailItem;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) Annotation* theNewAnnotation;
@property (strong, nonatomic, getter=theNewAnnotation) Annotation *newAnnotation;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)setCurrentLocation:(CLLocation *)location;

@end

