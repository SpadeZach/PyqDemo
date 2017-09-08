//
//  CommentCell.h
//  pyq-demo
//
//  Created by 赵博 on 2017/9/5.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (nonatomic,strong)NSDictionary *pyqDic;
+(instancetype)commentCellWithTableView:(UITableView *)tableView;
@property (nonatomic,assign)BOOL hiddImg;
@end
