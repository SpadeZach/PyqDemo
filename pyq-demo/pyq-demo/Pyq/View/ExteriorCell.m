//
//  ExteriorCell.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/4.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "ExteriorCell.h"
#import "PyqModel.h"
#import "CommentCell.h"
#import "GetPyqTime.h"
#import "Calculation.h"
#import "SetHexColor.h"
#import "UIView+CustomSize.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface ExteriorCell ()<UITableViewDelegate,UITableViewDataSource>
{
    
    //用户头像
    __weak IBOutlet UIImageView *headImg;
    //用户名
    __weak IBOutlet UILabel *nameLabel;
    //发布时间
    __weak IBOutlet UILabel *timeLabel;
    //内容
    __weak IBOutlet UILabel *contectLabel;
    //内容高
    __weak IBOutlet NSLayoutConstraint *contectH;
    
    
   
    //全文按钮的高度-隐藏时为0
    __weak IBOutlet NSLayoutConstraint *fullH;
    __weak IBOutlet UIButton *fullBtn;
    //没有评论的话为0 有评论的话为10
    __weak IBOutlet NSLayoutConstraint *tableH;
    //内容实际宽度(计算出所得宽度)
    CGFloat contectLabelH;
    //评论table(1.头部 用来写赞的人2.表示评论内容)
    __weak IBOutlet UITableView *commentTable;
    //计算table高
    CGFloat countTableH;
    //底部高度
    NSArray *zan;
    __weak IBOutlet UIView *praseView;
    //赞按钮的高度-隐藏时为0不隐藏20
    __weak IBOutlet NSLayoutConstraint *praseH;
    //赞按钮的上面间距
    __weak IBOutlet NSLayoutConstraint *praseY;
    //赞按钮的距下的距离（10/没赞0）
    __weak IBOutlet NSLayoutConstraint *parseBotoomH;
    //赞底图高度（没赞10/赞0）
    __weak IBOutlet NSLayoutConstraint *parseViewBottom;
    
    //评论人
    NSString *critics;

    __weak IBOutlet UILabel *criticsLabel;
    __weak IBOutlet UIButton *parseBtn;
}
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@end


@implementation ExteriorCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier= @"identif";
    ExteriorCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ExteriorCell" owner:nil options:nil]firstObject];
        
    }
   
    return cell;
}



#pragma mark - setter
- (void)setPyqModel:(PyqModel *)pyqModel{
    _pyqModel = pyqModel;
   [headImg setImage:[UIImage imageNamed:_pyqModel.userImg]];
    headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [headImg addGestureRecognizer:tap];
    
    
    nameLabel.text = _pyqModel.userName;
    //时间字符串

    timeLabel.text = [GetPyqTime dateTimeDifferenceWithStartTime:_pyqModel.publishTime];
    /******************  内容  ******************/
    contectLabel.text = _pyqModel.contect;
    //内容实际高度
    contectLabelH = [Calculation heightOfLabel:contectLabel.text font:contectLabel.font width:kWidth - 75];
    if (contectLabelH >= 150) {
        [fullBtn setHidden:NO];
        if (_pyqModel.isOpen) {
            contectH.constant = contectLabelH;
            [fullBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            contectH.constant = 150;
            [fullBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
    }else{
        contectH.constant = contectLabelH;
        [fullBtn setHidden:YES];
    }

    if (fullBtn.isHidden) {
        fullH.constant = 0;
    }else{
        fullH.constant = 20;
    }
    /******************  赞  ******************/
    if (_pyqModel.praiseList.count == 0) {
        praseView.hidden = YES;
        parseBotoomH.constant = 0;
        praseH.constant = 0;
        parseViewBottom.constant = 10;
    }else{
        praseView.hidden = NO;
        praseH.constant = 20;
        parseBotoomH.constant = 10;
        parseViewBottom.constant = 0;
        
        NSString *tempStr;
        for (NSString *userName in _pyqModel.praiseList) {
            if (tempStr == nil) {
                tempStr = userName;
            }else{
                tempStr = [NSString stringWithFormat:@"%@,%@",tempStr,userName];
            }
           
        }
  
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
        
        for (NSString *userName in _pyqModel.praiseList) {
            
            NSRange rang = [tempStr rangeOfString:userName];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[SetHexColor colorWithHexString:@"#356a91"] range:rang];
        }
        criticsLabel.attributedText = attrStr;
        
        for (NSString *nameString in _pyqModel.praiseList) {
            if ([nameString isEqualToString:@"haha"]) {
                [parseBtn setImage:[UIImage imageNamed:@"praise_select"] forState:UIControlStateNormal];
                parseBtn.selected = YES;
            }else{
                 parseBtn.selected = NO;
            }
            
        }
        
    }
    
    

    /******************  评论  ******************/
    countTableH = 0;
    if (_pyqModel.comment.count == 0) {
        tableH.constant = 0;
    }else{
        for (int i = 0; i < _pyqModel.comment.count; i++) {
            
            NSString *fromStr = _pyqModel.comment[i][@"from"];
            NSString *toStr = _pyqModel.comment[i][@"to"];
            NSString *commentStr = _pyqModel.comment[i][@"contect"];
            NSString *fullStr;
            if (![toStr isEqualToString:@""]) {
                fullStr = [NSString stringWithFormat:@"%@%@%@:%@",fromStr,@"回复",toStr,commentStr];
            }else{
                fullStr = [NSString stringWithFormat:@"%@:%@",fromStr,commentStr];
            }
            
            //5是 cell与cell上的控件内边距
             CGFloat commentH = [Calculation heightOfLabel:fullStr font:[UIFont systemFontOfSize:12] width:kWidth - 115] + 5;
            countTableH =  countTableH +commentH;
        }
        tableH.constant = countTableH;
    }
    commentTable.delegate = self;
    commentTable.dataSource = self;
    commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentTable.scrollEnabled = NO;
    commentTable.showsHorizontalScrollIndicator = NO;
    commentTable.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - 打开或关闭超长朋友圈
- (IBAction)openOrClose:(UIButton *)sender {
    _pyqModel.isOpen = !_pyqModel.isOpen;
    
    if (_pyqModel.isOpen) {
        contectH.constant = contectLabelH;
        [fullBtn setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        contectH.constant = 150;
        [fullBtn setTitle:@"全文" forState:UIControlStateNormal];
    }
    

    [self.delegate ExteriorCellReloadView];
}
#pragma mark - 点赞
- (IBAction)praiseClick:(UIButton *)sender {
    parseBtn.selected = !parseBtn.selected;
    if (parseBtn.selected) {
        NSLog(@"选中");
        [_pyqModel.praiseList addObject:@"haha"];
        [parseBtn setImage:[UIImage imageNamed:@"praise_select"] forState:UIControlStateNormal];
        
    }else{
        NSLog(@"取消");
        [_pyqModel.praiseList removeObject:@"haha"];
        [parseBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        
    }
 
    [self.delegate commentCellReloadView];
}
- (void)tapClick{
    NSLog(@"轻拍");
}
#pragma mark - 评论
- (IBAction)commnetClick:(id)sender {
   
    
    CGFloat cellY = [[sender superview] superview].custom_y;
    NSLog(@"----%f,Y:%f",kHeight,cellY);
    //35 是TextField所在高
    CGFloat cellH = [[sender superview] superview].custom_height;
    [self.delegate adjustView:cellY + cellH - 35];
    [self.delegate commentCellComment:_pyqModel.comment toCritic:@""];

}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _pyqModel.comment.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [CommentCell commentCellWithTableView:tableView];
    if (indexPath.row != 0) {
        cell.hiddImg = YES;
    }else{
        cell.hiddImg = NO;
    }
    cell.pyqDic = _pyqModel.comment[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic =  _pyqModel.comment[indexPath.row];
    NSLog(@"%@",dic[@"from"]);
    critics = dic[@"from"];
    CGFloat cellY = [[tableView superview] superview].custom_y;
    //35 是TextField所在高
    CGFloat cellH = [[tableView superview] superview].custom_height;
    [self.delegate adjustView:cellY + cellH - 35];

    /******************  获取评论人  ******************/
    [self.delegate commentCellComment:_pyqModel.comment toCritic:critics];
    /******************  删除  ******************/
//    [_pyqModel.comment removeObjectAtIndex:indexPath.row];
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.delegate commentCellReloadView];
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height)
    {
        return height.floatValue;
    }
    else
    {
        return 31;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath
{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
}



@end
