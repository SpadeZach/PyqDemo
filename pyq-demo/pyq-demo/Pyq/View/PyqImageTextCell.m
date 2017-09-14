//
//  PyqImageTextCell.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/8.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "PyqImageTextCell.h"
#import "PyqModel.h"
#import "CommentCell.h"
#import "GetPyqTime.h"
#import "Calculation.h"
#import "SetHexColor.h"
#import "UIView+CustomSize.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define ImgW (kWidth - 105) / 3
@interface PyqImageTextCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UIImageView *headImg;
    __weak IBOutlet UILabel *userLabel;
    __weak IBOutlet UILabel *timeLabel;
    //内容高
    __weak IBOutlet NSLayoutConstraint *contectH;
    
    __weak IBOutlet UILabel *contectLabel;
    //全文按钮的高度-隐藏时为0
    __weak IBOutlet NSLayoutConstraint *fullH;
    __weak IBOutlet UIButton *fullBtn;
    //没有评论的话为0 有评论的话为10
    __weak IBOutlet NSLayoutConstraint *tableH;
    //内容实际宽度(计算出所得宽度)
    CGFloat contectLabelH;
    //评论table(1.头部 用来写赞的人2.表示评论内容)
    __weak IBOutlet UITableView *commentTable;
    __weak IBOutlet NSLayoutConstraint *imgYH;
    //计算table高
    CGFloat countTableH;
    //图片的底图
    __weak IBOutlet UICollectionView *imgCollectionView;
    //图片底图高
    __weak IBOutlet NSLayoutConstraint *collectionH;
    //赞底图
    __weak IBOutlet UIView *praseView;
    //赞按钮的高度-隐藏时为0不隐藏20
    __weak IBOutlet NSLayoutConstraint *praseH;
    //赞按钮的距下的距离（10/没赞0）
    __weak IBOutlet NSLayoutConstraint *parseBotoomH;
    //赞底图高度（没赞10/赞0）
    __weak IBOutlet NSLayoutConstraint *parseViewBottom;

    
}
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@end

@implementation PyqImageTextCell
NSString *const pyqImageTextCellIdentifiy = @"PyqImgCellIndentify";
- (void)awakeFromNib{
    [super awakeFromNib];
    [imgCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:pyqImageTextCellIdentifiy];
    imgCollectionView.delegate = self;
    imgCollectionView.dataSource = self;
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier= @"PyqImageTextCellIdentifi";
    PyqImageTextCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PyqImageTextCell" owner:nil options:nil]firstObject];
        
    }
    
    return cell;
}
#pragma mark - setter
- (void)setPyqModel:(PyqModel *)pyqModel{
    _pyqModel = pyqModel;
    [headImg setImage:[UIImage imageNamed:_pyqModel.userImg]];
    userLabel.text = _pyqModel.userName;
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
        imgYH.constant = 10;
    }else{
        imgYH.constant = 0;
        contectH.constant = contectLabelH;
        [fullBtn setHidden:YES];
    }
    if (fullBtn.isHidden) {
        fullH.constant = 0;
    }else{
        fullH.constant = 20;
    }
    
     /******************  图片  ******************/
    NSInteger imgCout = _pyqModel.imgArr.count;
    collectionH.constant = ceilf(imgCout / 3.0) * (ImgW+10);
    

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
#pragma mark - 评论点击
- (IBAction)commentClick:(id)sender {
    CGFloat cellY = [[sender superview] superview].custom_y;
    //35 是TextField所在高
    CGFloat cellH = [[sender superview] superview].custom_height;
    [self.delegate adjustView:cellY + cellH - 35];
    [self.delegate commentCellComment:_pyqModel.comment toCritic:@""];
}
#pragma mark - collectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _pyqModel.imgArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pyqImageTextCellIdentifiy forIndexPath:indexPath];
    
    UIImageView * imgPic=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,ImgW, ImgW)];
    imgPic.image = [UIImage imageNamed:_pyqModel.imgArr[indexPath.row]];
    //    [imgPic setContentMode:UIViewContentModeScaleToFill];
    
    [cell.contentView addSubview:imgPic];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ImgW, ImgW);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    
    [self.delegate presentPreview:_pyqModel.imgArr curret:indexPath.row];
    
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
    CGFloat cellY = [[tableView superview] superview].custom_y;
    //35 是TextField所在高
    CGFloat cellH = [[tableView superview] superview].custom_height;
    [self.delegate adjustView:cellY + cellH - 35];
    /******************  评论  ******************/
    [self.delegate commentCellComment:_pyqModel.comment toCritic:dic[@"from"]];
    
    
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
