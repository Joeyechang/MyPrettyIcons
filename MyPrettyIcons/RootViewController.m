//
//  RootViewController.m
//  MyPrettyIcons
//
//  Created by chang on 16/8/30.
//  Copyright © 2016年 chang. All rights reserved.
//

#import "RootViewController.h"
#import "IconSet.h"
#import "IconCell.h"
#import "Icon.h"
#import "EditViewController.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSMutableArray *iconSets;
@property (strong, nonatomic) NSMutableArray *filteredIcons;

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableDictionary *indicesDict;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconSets = [IconSet iconSets];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.myTableView.allowsSelectionDuringEditing = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.myTableView addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
   return self.iconSets.count;
 
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    IconSet *set = self.iconSets[section];
    return set.name;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    int adjustment = [self isEditing] ? 1 : 0;
    IconSet *set = self.iconSets[section];
    return set.icons.count + adjustment;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        // Configure the cell
        IconSet *set = self.iconSets[indexPath.section];
        if (indexPath.row >= set.icons.count && [self isEditing]) {
            static NSString * cellIdentifier=@"NewRowCell";
            UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell==nil){
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.textLabel.text = @"Add Icon";
            cell.detailTextLabel.text = nil;
            cell.imageView.image = nil;
            return cell;
        }else{
            IconCell * cell= [tableView dequeueReusableCellWithIdentifier:@"IconCell"];
            if (cell==nil) {
                NSArray *subviews = [[NSBundle mainBundle] loadNibNamed:@"IconCell" owner:self options:nil];
                if (subviews && [subviews isKindOfClass:[NSArray class]]) {
                    for (id subview in subviews) {
                        if (subview && [subview isKindOfClass:[IconCell class]]) {
                            cell = subview;
                            break;
                        }
                    }
                }
            }
            Icon *icon = set.icons[indexPath.row];
            cell.titleLabel.text = icon.title;
            cell.subtitleLabel.text = icon.subtitle;
            cell.iconImageView.image = icon.image;
            if (icon.rating == RatingTypeAwesome) {
                cell.favoriteImageView.image = [UIImage imageNamed:@"star_sel.png"];
            } else {
                cell.favoriteImageView.image = [UIImage imageNamed:@"star_uns.png"];
            }
            return cell;
        }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IconSet *set = self.iconSets[indexPath.section];
    if (indexPath.row >= set.icons.count && [self isEditing]) {
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
    }
    
    Icon *icon = [set.icons objectAtIndex:indexPath.row];
    EditViewController * editViewController = [[EditViewController alloc] init];
    editViewController.icon = icon;
    editViewController.title = icon.title;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Pretty Icons" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:editViewController animated:YES];
    
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        IconSet *set = self.iconSets[indexPath.section];
        [set.icons removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        IconSet *set = self.iconSets[indexPath.section];
        Icon *newIcon = [[Icon alloc] initWithTitle:@"New Icon" subtitle:@"" imageName:nil];
        [set.icons addObject:newIcon];
        [tableView insertRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    // 没有这句 编辑时候不显示红色-按钮 绿色+按钮
    [self.myTableView setEditing:editing animated:animated];
    
    if (editing) {
        
        [self.myTableView beginUpdates];
        for (int i = 0; i < _iconSets.count; ++i) {
            IconSet *set = _iconSets[i];
            [self.myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:set.icons.count inSection:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.myTableView endUpdates];
        
    } else {
        
        [self.myTableView beginUpdates];
        for (int i = 0; i < _iconSets.count; ++i) {
            IconSet *set = _iconSets[i];
            [self.myTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:set.icons.count inSection:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.myTableView endUpdates];
        
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    IconSet *set = self.iconSets[indexPath.section];
    
    if (indexPath.row >= set.icons.count) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IconSet *set = self.iconSets[indexPath.section];
    if ([self isEditing] && indexPath.row < set.icons.count) {
        return nil;
    }
    return indexPath;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    IconSet *set = self.iconSets[indexPath.section];
//    if (indexPath.row >= set.icons.count && [self isEditing]) {
//        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
//    }
//    
//}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    IconSet *set = self.iconSets[indexPath.section];
    if (indexPath.row >= set.icons.count && [self isEditing]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    IconSet *sourceSet = self.iconSets[sourceIndexPath.section];
    IconSet *destSet = self.iconSets[destinationIndexPath.section];
    Icon *iconToMove = sourceSet.icons[sourceIndexPath.row];
    
    if (sourceSet == destSet) {
        
        [destSet.icons exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];
        
    } else {
        
        [destSet.icons insertObject:iconToMove atIndex:destinationIndexPath.row];
        [sourceSet.icons removeObjectAtIndex:sourceIndexPath.row];
        
    }
    
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    IconSet *set = self.iconSets[proposedDestinationIndexPath.section];
    if (proposedDestinationIndexPath.row >= set.icons.count) {
        return [NSIndexPath indexPathForRow:set.icons.count-1 inSection:proposedDestinationIndexPath.section];
    } else  {
        return proposedDestinationIndexPath;
    }
}

- (IBAction)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress {
    
    CGPoint location = [longPress locationInView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:location];
    
    UIGestureRecognizerState state = longPress.state;
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            
            if (indexPath) {
                
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
                
                snapshot = [self customSnapshotFromView:cell];
                
                __block CGPoint center = cell.center;
                snapshot.center = cell.center;
                snapshot.alpha = 0;
                [self.myTableView addSubview:snapshot];
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.textLabel.alpha = 0;
                    cell.detailTextLabel.alpha = 0;
                    cell.imageView.alpha = 0;
                    
                }];
                
                
            }
            
            
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            IconSet *destSet = [self.iconSets objectAtIndex:indexPath.section];
            if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.row < destSet.icons.count) {
                
                IconSet *sourceSet = self.iconSets[sourceIndexPath.section];
                IconSet *destSet = self.iconSets[indexPath.section];
                Icon *iconToMove = sourceSet.icons[sourceIndexPath.row];
                
                if (sourceSet == destSet) {
                    
                    [destSet.icons exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    
                } else {
                    
                    [destSet.icons insertObject:iconToMove atIndex:indexPath.row];
                    [sourceSet.icons removeObjectAtIndex:sourceIndexPath.row];
                    
                }
                
                [self.myTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                sourceIndexPath = indexPath;
                
            }
            
        }
            break;
        default: {
            
            UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformMakeScale(1.0, 1.0);
                snapshot.alpha = 0.0;
                
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.alpha = 1;
                cell.detailTextLabel.alpha = 1;
                cell.imageView.alpha = 1;
                
            } completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            sourceIndexPath = nil;
        }
            break;
    }
    
    
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IconSet *set = self.iconSets[indexPath.section];
    if (indexPath.row >= set.icons.count && [self isEditing]) {
        return 40;
    } else {
        return 80;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
}

@end
