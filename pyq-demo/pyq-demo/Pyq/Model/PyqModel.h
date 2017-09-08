//
//  PyqModel.h
//  pyq-demo
//
//  Created by 赵博 on 2017/9/4.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PyqModel : NSObject

/**
 * 发布时间
 */
@property (nonatomic,strong)NSString *publishTime;
/**
 * 用户头像
 */
@property (nonatomic,strong)NSString *userImg;
/**
 * 用户名
 */
@property (nonatomic,strong)NSString *userName;
/**
 * 朋友圈内容
 */
@property (nonatomic,strong)NSString *contect;
/**
 * 图片数组
 */
@property (nonatomic,strong)NSArray *imgArr;
/**
 * 链接
 */
@property (nonatomic,strong)NSString *linkUrl;
/**
 * 链接图片
 */
@property (nonatomic,strong)NSString *linkImg;

/**
 * 是否展开1.展开 0.不展开
 */
@property (nonatomic,assign)BOOL isOpen;

/**
 * 评论列表
 */
@property (nonatomic,strong)NSMutableArray *comment;
/**
 * 赞列表
 */
@property (nonatomic,strong)NSMutableArray *praiseList;
- (instancetype)initWithDictionary:(NSDictionary*)dic;
@end
