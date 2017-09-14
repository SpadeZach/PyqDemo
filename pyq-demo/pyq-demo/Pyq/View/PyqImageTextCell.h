//
//  PyqImageTextCell.h
//  pyq-demo
//
//  Created by 赵博 on 2017/9/8.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PyqImageTextCellDelegate <NSObject>

- (void)ExteriorCellReloadView;
- (void)commentCellReloadView;
//图片预览
- (void)presentPreview:(NSArray *)imgArr curret:(NSInteger)indexRow;
//评论
- (void)commentCellComment:(NSMutableArray *)commentList toCritic:(NSString *)critic;
//调整键盘高度
- (void)adjustView:(NSInteger)height;
@end
@class  PyqModel;
@interface PyqImageTextCell : UITableViewCell
@property(nonatomic, assign)id<PyqImageTextCellDelegate>delegate;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)PyqModel *pyqModel;
@end
