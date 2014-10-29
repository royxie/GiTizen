//
//  EventCenterTableViewCell.h
//  GiTizen
//
//  Created by XieShiyu on 19/10/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCenterTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *locLabel;
@property (strong, nonatomic) IBOutlet UILabel *tsLabel;
@property (strong, nonatomic) IBOutlet UILabel *npLabel;
@property (strong, nonatomic) IBOutlet UILabel *njLabel;

@end
