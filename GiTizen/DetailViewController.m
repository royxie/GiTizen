//
//  DetailViewController.m
//  sample
//
//  Created by Zhao Yiwei on 10/19/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *categoryText;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (weak, nonatomic) IBOutlet UILabel *nopText;
@property (weak, nonatomic) IBOutlet UILabel *addrTextView;
@property (weak, nonatomic) IBOutlet UILabel *desTextView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(Event*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Join now!" style:UIBarButtonItemStylePlain target:self action:@selector(joinEvent)];
        self.navigationItem.rightBarButtonItem = rightButton;
        [self configureView];
    }
}

- (void)joinEvent {
    UIAlertView* joinSuccess = [[UIAlertView alloc] initWithTitle:@"Join" message:@"Successfully joined!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [joinSuccess show];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.categoryText.text = self.detailItem.category;
        self.nameText.text = self.detailItem.g_loc_name;
        self.timeText.text = self.detailItem.starttime;
        self.nopText.text = self.detailItem.number_of_peo;
        self.addrTextView.text = self.detailItem.g_loc_addr;
        self.desTextView.text = @"All welcome!!";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
