//
//  CommentCell.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/5.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "CommentCell.h"
#import "GetPyqTime.h"
#import "Calculation.h"
#import "SetHexColor.h"
#import "UIView+CustomSize.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface CommentCell ()
{
    
    __weak IBOutlet UILabel *commentLabel;
    __weak IBOutlet UIImageView *commentImg;
}

@end

@implementation CommentCell

+(instancetype)commentCellWithTableView:(UITableView *)tableView{
    static NSString *identifier= @"commentCellidentif";
    CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"CommentCell" owner:nil options:nil]firstObject];
    }
    
    cell.backgroundColor = [SetHexColor colorWithHexString:@"#ECECEC"];
    return cell;
}
- (void)setPyqDic:(NSDictionary *)pyqDic{
    _pyqDic = pyqDic;
    
    NSString *fromStr = _pyqDic[@"from"];
    NSString *toStr = _pyqDic[@"to"];
    NSString *commentStr = _pyqDic[@"contect"];
    NSString *fullStr;
    // NSForegroundColorAttributeName
    NSMutableAttributedString *endStr;
    if (![toStr isEqualToString:@""]) {
        fullStr = [NSString stringWithFormat:@"%@%@%@:%@",fromStr,@"回复",toStr,commentStr];
         endStr = [[NSMutableAttributedString alloc]initWithString:fullStr];
        NSRange range1 = [fullStr rangeOfString:fromStr];
        NSRange range2 = [fullStr rangeOfString:toStr];
        [endStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
        [endStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        
    }else{
        fullStr = [NSString stringWithFormat:@"%@:%@",fromStr,commentStr];
        endStr = [[NSMutableAttributedString alloc]initWithString:fullStr];
        NSRange range1 = [fullStr rangeOfString:fromStr];
        [endStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    }
    
   
    commentLabel.attributedText = endStr;
    
    //高亮文字点击事件 其实就是在文字范围 加改透明按钮 label交互开启
}
- (void)setHiddImg:(BOOL)hiddImg{
    _hiddImg = hiddImg;
    commentImg.hidden = _hiddImg;
}
@end
