//
//  EditViewController.m
//  MyPrettyIcons
//
//  Created by chang on 16/8/31.
//  Copyright © 2016年 chang. All rights reserved.
//

#import "EditViewController.h"
#import "Icon.h"
#import "ImageViewCell.h"
#import "MetaDataCell.h"
#import "RatingViewController.h"
#import "DetailViewController.h"

@interface EditViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UITextField *titleTextField;
@property (strong, nonatomic) UITextField *subtitleTextField;
//@property (strong, nonatomic) UILabel *ratingTextField;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.iconImageView.image = self.icon.image;
    self.titleTextField.text = self.icon.title;
    self.subtitleTextField.text = self.icon.subtitle;
    
    [self refresh];
    
}

- (void)refresh {
    
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:2 inSection:1];
    UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:myIP];
    if (cell) {
        UILabel * ratinglbl = (UILabel *)[cell viewWithTag:111333];
        ratinglbl.text = [Icon ratingToString:self.icon.rating];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.icon.image = self.iconImageView.image;
    self.icon.title = self.titleTextField.text;
    self.icon.subtitle = self.subtitleTextField.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return indexPath;
    } else if(indexPath.row == 2 && indexPath.section == 1){
        return indexPath;
    }else {
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return 1;
    }else if(section==1){
        return 3;
    }else{
        return 0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;
    
    if (section==0) {
        ImageViewCell * cell= [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell"];
        if (cell==nil) {
            NSArray *subviews = [[NSBundle mainBundle] loadNibNamed:@"ImageViewCell" owner:self options:nil];
            if (subviews && [subviews isKindOfClass:[NSArray class]]) {
                for (id subview in subviews) {
                    if (subview && [subview isKindOfClass:[ImageViewCell class]]) {
                        cell = subview;
                        break;
                    }
                }
            }
            
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
        }
        
        
        
        cell.iconImgView.image = self.icon.image;
        self.iconImageView = cell.iconImgView;
        
        return cell;
    }else{
        MetaDataCell * cell= [tableView dequeueReusableCellWithIdentifier:@"MetaDataCell"];
        if (cell==nil) {
            NSArray *subviews = [[NSBundle mainBundle] loadNibNamed:@"MetaDataCell" owner:self options:nil];
            if (subviews && [subviews isKindOfClass:[NSArray class]]) {
                for (id subview in subviews) {
                    if (subview && [subview isKindOfClass:[MetaDataCell class]]) {
                        cell = subview;
                        break;
                    }
                }
            }
        }
        if (index==0) {
            self.titleTextField = cell.titleTxtField;
            
            cell.title.text = @"Title";
            cell.titleTxtField.text = self.icon.title;
        } else if (index==1) {
            self.subtitleTextField = cell.titleTxtField;
            
            cell.title.text = @"Subtitle";
            cell.titleTxtField.text = self.icon.subtitle;
            
        } else if (index==2) {
            
            cell.title.text = @"Rating";
            cell.titleTxtField.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel * ratinglbl = (UILabel *)[cell viewWithTag:111333];
            if (!ratinglbl) {
                ratinglbl = [self creatRatinglbl];
                [cell.contentView addSubview:ratinglbl];
            }
            ratinglbl.text = [Icon ratingToString:self.icon.rating];

        }
        return cell;
    }
}

/**
 *  创建label
 *
 *  @return
 */
-(UILabel *)creatRatinglbl{
    UILabel * ratinglbl =[[UILabel alloc] initWithFrame:CGRectMake(108, 7, 92, 30)];
    ratinglbl.tag = 111333;
    return ratinglbl;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        return 200;
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = NO;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        RatingViewController * ratingViewController = [[RatingViewController alloc] init];
        ratingViewController.icon = self.icon;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
        
        [self.navigationController pushViewController:ratingViewController animated:YES];
    }
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{

    DetailViewController * detailViewController = [[DetailViewController alloc] init];
    detailViewController.icon = self.icon;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.icon.image = image;
    self.iconImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
