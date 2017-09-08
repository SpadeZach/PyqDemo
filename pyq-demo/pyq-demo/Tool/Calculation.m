//
//  Calculation.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/5.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "Calculation.h"

@implementation Calculation
#pragma mark - 计算宽度
+(CGFloat)widthOfSelfSuit:(NSString *)text font:(UIFont *)font height:(CGFloat)height{
    CGSize size = CGSizeMake(MAXFLOAT, height);
    NSDictionary *style = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect result = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:style context:nil];
    return result.size.width;
}

#pragma mark - 计算高度
+ (CGFloat)heightOfLabel:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
    
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary *style = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect result = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:style context:nil];
    return result.size.height;
}
@end
