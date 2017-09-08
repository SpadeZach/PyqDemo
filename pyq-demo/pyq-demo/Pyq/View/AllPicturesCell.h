//
//  AllPicturesCell.h
//  pyq-demo
//
//  Created by 赵博 on 2017/9/7.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AllPicturesCellDelegate <NSObject>

- (void)ExteriorCellReloadView;
- (void)commentCellReloadView;
- (void)presentPreview:(NSArray *)imgArr curret:(NSInteger)indexRow;

@end
@class PyqModel;
@interface AllPicturesCell : UITableViewCell
@property(nonatomic, assign)id<AllPicturesCellDelegate>delegate;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)PyqModel *pyqModel;
@end
