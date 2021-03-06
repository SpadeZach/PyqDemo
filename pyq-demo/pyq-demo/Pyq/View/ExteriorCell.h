//
//  ExteriorCell.h
//  pyq-demo
//
//  Created by 赵博 on 2017/9/4.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExteriorCellDelegate <NSObject>

- (void)ExteriorCellReloadView;
- (void)commentCellReloadView;
//评论
- (void)commentCellComment:(NSMutableArray *)commentList toCritic:(NSString *)critic;
- (void)headImgClick;
- (void)adjustView:(NSInteger)height;
@end
@class  PyqModel;
@interface ExteriorCell : UITableViewCell

@property(nonatomic, assign)id<ExteriorCellDelegate>delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)PyqModel *pyqModel;


@end
