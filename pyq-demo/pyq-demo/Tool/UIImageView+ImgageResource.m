//
//  UIImageView+ImgageResource.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/4.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "UIImageView+ImgageResource.h"
#import <UIKit/UIKit.h>
@implementation UIImageView (ImgageResource)
- (void)getImage:(NSString *)imgName{
//
    NSString *imgN = [NSString stringWithFormat:@"Image.bundle/userImg/%@",imgName];
    UIImage *image = [UIImage imageNamed:imgN];
    [self setImage:image];
}
@end
