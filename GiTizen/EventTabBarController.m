//
//  EventTabBarController.m
//  GiTizen
//
//  Created by XieShiyu on 28/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "EventTabBarController.h"

@interface EventTabBarController ()

@end

@implementation EventTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadTabBar];
}

-(void) loadTabBar {
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *centerTabBarItem = [tabBar.items objectAtIndex:0];
    UITabBarItem *postTabBarItem = [tabBar.items objectAtIndex:1];
    UITabBarItem *joinTabBarItem = [tabBar.items objectAtIndex:2];
    UITabBarItem *profileTabBarItem = [tabBar.items objectAtIndex:3];
    
    centerTabBarItem.title = @"All Events";
    postTabBarItem.title = @"My Post";
    joinTabBarItem.title = @"My Join";
    profileTabBarItem.title = @"Profile";
    
    [centerTabBarItem setImage:[UIImage imageNamed:@"EventCenter"]];
    [postTabBarItem setImage:[UIImage imageNamed:@"PostedEvent"]];
    [joinTabBarItem setImage:[UIImage imageNamed:@"JoinedEvent"]];
    [profileTabBarItem setImage:[UIImage imageNamed:@"Profile"]];
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
