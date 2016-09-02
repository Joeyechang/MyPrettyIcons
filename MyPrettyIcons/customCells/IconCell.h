//
//  IconCell.h
//  MyPrettyIcons
//
//  Created by chang on 16/8/30.
//  Copyright © 2016年 chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@end
