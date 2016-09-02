//
//  IconSet.h
//  MyPrettyIcons
//
//  Created by chang on 16/8/30.
//  Copyright © 2016年 chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconSet : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *icons;

+ (NSMutableArray *)iconSets;
- (instancetype)initWithName:(NSString *)name icons:(NSMutableArray *)icons;


@end
