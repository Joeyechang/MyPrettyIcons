//
//  Icon.m
//  MyPrettyIcons
//
//  Created by chang on 16/8/30.
//  Copyright © 2016年 chang. All rights reserved.
//

#import "Icon.h"

@implementation Icon

-(instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle imageName:(NSString *)imageName{

    if ((self=[super init])) {
        _title = title;
        _subtitle = subtitle;
        _image = [UIImage imageNamed:imageName];
        _rating = RatingTypeUnrated;
    }

    return self;
}

+(NSString *)ratingToString:(RatingType)rating{
    switch (rating) {
        case RatingTypeUnrated:
            return @"Unrated";
            break;
        case RatingTypeUgly:
            return @"Ugly";
            break;
        case RatingTypeOK:
            return @"OK";
            break;
        case RatingTypeNice:
            return @"Nice";
            break;
        case RatingTypeAwesome:
            return @"Awesome";
            break;
        default:
            return @"Unknown";
            break;
    }
}

@end
