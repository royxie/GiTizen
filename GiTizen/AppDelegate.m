//
//  AppDelegate.m
//  Event
//
//  Created by Lammert Westerhoff on 2/21/13.
//  Copyright (c) 2013 Lammert Westerhoff. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "Event.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://106.185.44.27:8080"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GiTizen" ofType:@"momd"]];
    
    //Iniitalize CoreData with RestKit
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error = nil;
    
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"GiTizen.sqlite"];
    //NSLog(@"%@", path);
    objectManager.managedObjectStore = managedObjectStore;
    
    [objectManager.managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    
    [objectManager.managedObjectStore createManagedObjectContexts];
    
    
    RKEntityMapping *eventMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:managedObjectStore];
    [eventMapping addAttributeMappingsFromDictionary:@{
                                                       @"gtid" : @"gtid",
                                                       @"g_loc_icon" : @"g_loc_icon",
                                                       @"g_loc_id" : @"g_loc_id",
                                                       @"g_loc_name" : @"g_loc_name",
                                                       @"g_loc_addr" : @"g_loc_addr",
                                                       @"starttime" : @"starttime",
                                                       @"category" : @"category",
                                                       @"_id" : @"object_id",    // server side: _id; ios side: object_id
                                                       @"number_of_peo" : @"number_of_peo",
                                                       @"number_joined" : @"number_joined",
                                                       @"g_loc_lon" : @"g_loc_lon",
                                                       @"g_loc_lat" : @"g_loc_lat",
                                                       @"desc" : @"desc"
                                                       }];
    /*
    "number_of_peo": "5",
    "starttime": "19 OCT 2014 16:32",
    "g_loc_icon": "http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
    "g_loc_id": "7eaf747a3f6dc078868cd65efc8d3bc62fff77d7",
    "g_loc_name": "Tetsuya's",
    "g_loc_addr": "529 Kent Street, Sydney NSW, Australia",
    "gtid": "903060555",
    "category": "Hangout",
    "_id": "5444212b659e031508000002"
     */
    
    // Register our mappings with the provider
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/api/events"
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[eventMapping inverseMapping] objectClass:[Event class] rootKeyPath:nil method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
