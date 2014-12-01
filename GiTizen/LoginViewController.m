//
//  ViewController.m
//  GiTizen
//
//  Created by XieShiyu on 19/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "User.h"
#import <RestKit/RestKit.h>

@interface LoginViewController ()

@property (strong, nonatomic) User* userToPost;

@property (weak, nonatomic) IBOutlet UITextField *Username;

@property (weak, nonatomic) IBOutlet UITextField *Firstname;

@property (weak, nonatomic) IBOutlet UITextField *Lastname;

@property (weak, nonatomic) IBOutlet UITextField *GTID;

@property (weak, nonatomic) IBOutlet UILabel *WelcomeMessage;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[LoginView alloc] init]];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)initField
{
    self.userToPost = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)GTIDisGood:(NSString *)userGTID {
    if ([userGTID isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"]] || userGTID.length == 0 ) {
        return NO;
    }
    else {
        return YES;
    };
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"userLogin"]) {
        self.userToPost.gtid = self.GTID.text;
        self.userToPost.username = self.Username.text;
        self.userToPost.firstname = self.Firstname.text;
        self.userToPost.lastname = self.Lastname.text;
        [[NSUserDefaults standardUserDefaults] setObject:self.userToPost.gtid forKey:@"userGTID"];
        [[NSUserDefaults standardUserDefaults] setObject:self.userToPost.username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:self.userToPost.firstname forKey:@"userFirstName"];
        [[NSUserDefaults standardUserDefaults] setObject:self.userToPost.lastname forKey:@"userLastName"];
        if ([self GTIDisGood:self.userToPost.gtid]) {
            [[RKObjectManager sharedManager]    postObject:self.userToPost
                                                      path:@"/api/users"
                                                parameters:nil
                                                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                       NSLog(@"Post succeeded");
                                                   }
                                                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                       NSLog(@"error occurred': %@", error);
                                                   }];
        }
    }
}


@end
