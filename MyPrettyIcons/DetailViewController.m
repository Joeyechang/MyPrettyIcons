//
//  DetailViewController.m
//  MyPrettyIcons
//
//  Created by chang on 16/9/1.
//  Copyright © 2016年 chang. All rights reserved.
//

#import "DetailViewController.h"
#import "Icon.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    self.imageView.image = self.icon.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
