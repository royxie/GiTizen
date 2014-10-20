//
//  PostEventViewController.m
//  GiTizen
//
//  Created by Zhao Yiwei on 10/19/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "PostEventViewController.h"
#import "EventCenterTableViewCell.h"
#import "Event.h"
#import <RestKit/RestKit.h>

@interface PostEventViewController ()

@property (strong, nonatomic) Event *eventToPost;
@property (weak, nonatomic) IBOutlet UITextField *locationStr;
@property (weak, nonatomic) IBOutlet UITextField *categoryStr;
@property (weak, nonatomic) IBOutlet UITextField *timeStr;
@property (weak, nonatomic) IBOutlet UITextField *nopStr;

@end

@implementation PostEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init_event];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postIt)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)init_event
{
    self.eventToPost = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
}

- (void)postIt {
    
    self.eventToPost.category = self.categoryStr.text;
    self.eventToPost.starttime = self.timeStr.text;
    self.eventToPost.g_loc_name = self.locationStr.text;
    self.eventToPost.number_of_peo = self.nopStr.text;
    
    [[RKObjectManager sharedManager]    postObject:self.eventToPost
                                              path:@"/api/events"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               NSLog(@"Post succeeded");
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
