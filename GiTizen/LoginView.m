//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//#import <Parse/Parse.h>
//#import "ProgressHUD.h"

//#import "AppConstant.h"
//#import "pushnotification.h"

#import <RestKit/RestKit.h>
#import "LoginView.h"
#import "User.h"
#import "ProgressHUD.h"


//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface LoginView()

@property (strong, nonatomic) IBOutlet UITableViewCell *cellGtid;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellButton;

@property (strong, nonatomic) IBOutlet UITextField *fieldGtid;
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;

@property (strong, nonatomic) User *currentUser;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation LoginView

@synthesize cellGtid, cellPassword, cellButton;
@synthesize fieldGtid, fieldPassword;
@synthesize currentUser;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
    [self initField];
	self.title = @"Login";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.tableView.separatorInset = UIEdgeInsetsZero;
    NSLog(@"loginview");
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	[fieldGtid becomeFirstResponder];
}

- (void)initField
{
    currentUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.view endEditing:YES];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionLogin:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *gtid = fieldGtid.text;
	NSString *password = fieldPassword.text;
    if (gtid.length != 0 && password.length != 0) {
        currentUser.gtid = gtid;
        [self loadUser];
        [[NSUserDefaults standardUserDefaults] setObject:gtid forKey:@"userGTID"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)loadUser
{
    [ProgressHUD show:@"Please wait…"];
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/users"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSArray* users = mappingResult.array;
                                                  BOOL flag = NO;
                                                  for (User* user in users) {
                                                      if ([user.gtid isEqualToString:currentUser.gtid]) {
                                                          currentUser = user;
                                                          flag = YES;
                                                      }
                                                  }
                                                  if (flag == YES) [self assignUserDefaults];
                                                  if (flag == NO) [self postUser];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"error occurred': %@", error);
                                              }];
}

-(void) assignUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:currentUser.username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:currentUser.email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject:currentUser.sign forKey:@"signature"];
    [ProgressHUD showSuccess:@"Welcome back !"];
}
     
-(void) postUser
{
    [[RKObjectManager sharedManager]    postObject:currentUser
                                              path:@"/api/users"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               NSLog(@"Post succeeded");
                                               [ProgressHUD dismiss];
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];

}


#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 3;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.row == 0) return cellGtid;
	if (indexPath.row == 1) return cellPassword;
	if (indexPath.row == 2) return cellButton;
	return nil;
}

#pragma mark - UITextField delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (textField == fieldGtid)
	{
		[fieldPassword becomeFirstResponder];
	}
	if (textField == fieldPassword)
	{
		[self actionLogin:nil];
	}
	return YES;
}

@end
