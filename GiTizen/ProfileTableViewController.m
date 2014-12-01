//
//  ProfileTableViewController.m
//  GiTizen
//
//  Created by XieShiyu on 26/11/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "utilities.h"
#import "ProfileCell.h"
#import <RestKit/RestKit.h>
#import "User.h"
#import "ProgressHUD.h"


@interface ProfileTableViewController ()

@property (strong, nonatomic) User *currentUser;

@end

@implementation ProfileTableViewController

@synthesize currentUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    //currentUser = [User new];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(actionLogout)];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    
    [self loadUser];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (ifUserLogin() == NO)
        LoginUser(self);

    [self loadUser];
    [self.tableView reloadData];
}

- (void)actionLogout
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Log out", nil];
    [action showFromTabBar:[[self tabBarController] tabBar]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        LogoutUser(self);
        LoginUser(self);
    }
}

- (void)dismissKeyboard

{
    [self.view endEditing:YES];
}

- (IBAction)actionSave:(id)sender
{
    [self dismissKeyboard];
    [self saveProfile];
}

-(void) saveProfile
{
    ProfileCell *cellUsername, *cellEmail, *cellSig;
    cellUsername = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cellEmail = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cellSig = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    User* currentUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
    currentUser.gtid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    currentUser.username = cellUsername.fieldName.text;
    currentUser.email = cellEmail.fieldName.text;
    currentUser.sign = cellSig.fieldName.text;
    NSLog(@"%@, %@, %@", currentUser.username, currentUser.email, currentUser.sign);
    
    [ProgressHUD show:@"Please wait..."];
    NSString* path = [@"/api/users/" stringByAppendingString:currentUser.gtid];
    [[RKObjectManager sharedManager]    putObject:currentUser
                                              path:path
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               NSLog(@"Update succeeded");
                                               [ProgressHUD showSuccess:@"Saved."];
                                               /*
                                               UIAlertView* saveSuccess = [[UIAlertView alloc] initWithTitle:@"Save Profile" message:@"Profile Saved" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                               [saveSuccess show];
                                               [self.navigationController popViewControllerAnimated:YES];
                                                */
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* cellArray = [[NSBundle mainBundle] loadNibNamed:@"ProfileTableViewController" owner:self options:nil];
    ProfileCell* cell;
    if (indexPath.row == 3) cell = cellArray[1];
    else {
        cell = cellArray[0];
        if (indexPath.row == 0) {
            cell.fieldName.placeholder = @"Username";
            //NSString* username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
            //if (username != nil) cell.fieldName.text = username;
            if (currentUser.username != nil) cell.fieldName.text = currentUser.username;
        }
        if (indexPath.row == 1) {
            cell.fieldName.placeholder = @"Email";
            //NSString* email = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
            //if (email != nil) cell.fieldName.text = email;
            if (currentUser.email != nil) cell.fieldName.text = currentUser.email;
        }
        if (indexPath.row == 2) {
            cell.fieldName.placeholder = @"Signature";
            //NSString* signature = [[NSUserDefaults standardUserDefaults] stringForKey:@"signature"];
            //if (signature != nil) cell.fieldName.text = signature;
            if (currentUser.sign != nil) cell.fieldName.text = currentUser.sign;
        }
    }
    return cell;
}

- (void) refresh {
    [self loadUser];
    [self.refreshControl endRefreshing];
}

-(void)loadUser
{
    [ProgressHUD show:nil];
    NSString* userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userGTID"];
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/users"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSArray* users = mappingResult.array;
                                                  for (User* user in users) {
                                                      if ([user.gtid isEqualToString:userId]) {
                                                          currentUser = user;
                                                      }
                                                  }
                                                  NSLog(@"gtid2: %@", currentUser.gtid);
                                                  [self.tableView reloadData];
                                                  [ProgressHUD dismiss];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
}


/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
