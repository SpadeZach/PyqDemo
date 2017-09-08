//
//  Calculation.h
//  pyq-demo
//
//  Created by 赵博 on 2017/9/5.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculation : NSObject

/**
 文本宽度

 @param text 文本内容
 @param font 文本字号
 @param height 文本高度
 @return 文本宽度
 */
+(CGFloat)widthOfSelfSuit:(NSString *)text font:(UIFont *)font height:(CGFloat)height;
/**
 文本高度
 
 @param text 文本内容
 @param font 文本字号
 @param width 文本宽度
 @return 文本高度
 */
+ (CGFloat)heightOfLabel:(NSString *)text font:(UIFont *)font width:(CGFloat)width;
@end
