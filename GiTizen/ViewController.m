//
//  ViewController.m
//  GiTizen
//
//  Created by XieShiyu on 19/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Username;
@property (weak, nonatomic) IBOutlet UITextField *Firstname;
@property (weak, nonatomic) IBOutlet UITextField *Lastname;
@property (weak, nonatomic) IBOutlet UILabel *WelcomeMessage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"username"]) {
        NSString* Userinfo = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        [self.WelcomeMessage setText:[NSString stringWithFormat:@"Welcome back, %@",Userinfo]];
        [self.Username setText:Userinfo];
        NSString* Userfirstname = [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"];
        [self.Firstname setText:Userfirstname];
        NSString* Userlastname = [[NSUserDefaults standardUserDefaults] stringForKey:@"userLastName"];
        [self.Lastname setText:Userlastname];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"userLogin"]) {
        NSString *signInName = self.Username.text;
        [[NSUserDefaults standardUserDefaults] setObject:signInName forKey:@"username"];
        NSString *firstName = self.Firstname.text;
        [[NSUserDefaults standardUserDefaults] setObject:firstName forKey:@"userFirstName"];
        NSString *lastName = self.Lastname.text;
        [[NSUserDefaults standardUserDefaults] setObject:lastName forKey:@"userLastName"];
        
    }
}

@end
