//
//  RatingViewControllerTableViewController.m
//  MyPrettyIcons
//
//  Created by chang on 16/9/1.
//  Copyright © 2016年 chang. All rights reserved.
//

#import "RatingViewController.h"
#import "Icon.h"

@interface RatingViewController ()

@end

@implementation RatingViewController


- (void)refresh {
    
    for (int i = 0; i < NumRatingTypes; ++i) {

        NSIndexPath *myIP = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:myIP];
        cell.accessoryType = (int) self.icon.rating == i ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return NumRatingTypes;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // You asked for a cell, but you don't know if it is nil or not
    // In Swift, here the cell should be a conditional
    
    // First, check if the cell is nil
    if ( cell == nil ) {
        // Cell is nil. To avoid crashes, we instantiate an actual cell
        // With Swift conditional should be something similar
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [Icon ratingToString:indexPath.row];
    
    return cell;
}





#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.icon.rating = indexPath.row;
    [self refresh];
}




@end
