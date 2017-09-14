//
//  ViewController.h
//  pyq-demo
//
//  Created by 赵博 on 2017/9/4.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CommentCellStyle){
    Puretext,               //全是文字的cell
    Imagetext,              //图片文字的cell
    Pictures,               //图片cell
    UrlLink                 //连接cell
};

@interface PyqController : UIViewController


@end

