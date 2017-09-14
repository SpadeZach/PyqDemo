//
//  ViewController.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/4.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "PyqController.h"
#import "ExteriorCell.h"
#import "PyqModel.h"
#import "TempViewViewController.h"
#import "AllPicturesCell.h"
#import "PyqPreviewController.h"
#import "PyqImageTextCell.h"
#import "GetPyqTime.h"
#import "Calculation.h"
#import "SetHexColor.h"
#import "UIView+CustomSize.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface PyqController ()<UITableViewDelegate,UITableViewDataSource,ExteriorCellDelegate,AllPicturesCellDelegate,PyqImageTextCellDelegate,UITextFieldDelegate>
//外层table
@property (weak, nonatomic) IBOutlet UITableView *externalTable;

@property (nonatomic, strong) NSMutableArray *getArr;
@property (nonatomic, strong) ExteriorCell *extercell;
@property (nonatomic, strong) AllPicturesCell *allPicCell;
@property (nonatomic, strong) PyqImageTextCell *imageTextCell;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, strong)UIView *keyboardView;
@property (nonatomic, strong)UITextField *textFl;
//被评论朋友圈类型
@property (nonatomic, assign) NSInteger commentType;
//评论列表
@property (nonatomic, assign) NSMutableArray *commentList;
//回复评论的xxx
@property (nonatomic, strong) NSString *criticStr;

@property (nonatomic, assign) CGFloat tableOffset;
@end
 NSString *const identifi= @"exterTableCell";
@implementation PyqController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"朋友圈";
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    self.externalTable.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    self.externalTable.rowHeight = UITableViewAutomaticDimension;
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification object:nil];
    [self setUpKeyboardView];
    [self getData];

}
#pragma mark - 设置评论键盘底图
- (void)setUpKeyboardView{
    
    self.keyboardView  = [UIView new];
    self.keyboardView.frame = CGRectMake(0, kHeight, kWidth, 200);
    self.keyboardView.backgroundColor = [SetHexColor colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:self.keyboardView];
    
    UIView *textBottomView = [UIView new];
    textBottomView.frame = CGRectMake(10, 10, kWidth - 55, 35);
    textBottomView.backgroundColor = [UIColor whiteColor];
    
    textBottomView.layer.masksToBounds = YES;
    textBottomView.layer.cornerRadius = 3;
    textBottomView.layer.borderWidth = 1;
    textBottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.keyboardView addSubview:textBottomView];
    self.textFl = [UITextField new];
    self.textFl.frame = CGRectMake(10, 0, kWidth - 55, 35);
    self.textFl.delegate = self;
    self.textFl.returnKeyType = UIReturnKeySend;
    self.textFl.placeholder = @"评论:";
    self.textFl.backgroundColor = [UIColor whiteColor];
    self.textFl.font = [UIFont systemFontOfSize:14];
    self.textFl.borderStyle = UITextBorderStyleNone;
    
    self.textFl.tintColor = [UIColor blackColor];
    [textBottomView addSubview:self.textFl];
    [self.textFl addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 仿网络请求
- (void)getData{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"pyqData" ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *err;
    NSArray *tempArr = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
    }
    self.getArr = [NSMutableArray new];
    for (NSDictionary *dic in tempArr) {
        
        PyqModel *pyqmodel = [[PyqModel alloc] initWithDictionary:dic];
        //默认不展开
        pyqmodel.isOpen = NO;
        [self.getArr addObject:pyqmodel];
        
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.getArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell应该有4种，1.纯文字 2.纯图片 3.文字+图片 4.连接
    
    PyqModel *pyqModel = self.getArr[indexPath.row];

    if (![pyqModel.contect isEqualToString:@""] && pyqModel.imgArr.count == 0) {
        //纯文字
        self.extercell = [ExteriorCell cellWithTableView:tableView];
        self.extercell.pyqModel = pyqModel;
        self.extercell.delegate = self;
        self.extercell.selectionStyle = UITableViewCellSelectionStyleNone;

        return self.extercell;
    }else if ([pyqModel.contect isEqualToString:@""] && pyqModel.imgArr.count != 0){
        //纯图片
        
        self.allPicCell = [AllPicturesCell cellWithTableView:tableView];
        self.allPicCell.pyqModel = pyqModel;
        self.allPicCell.delegate = self;
        self.allPicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.allPicCell;
    }else {
        //文字+图片
//        if (![pyqModel.contect isEqualToString:@""] && pyqModel.imgArr.count != 0)
        self.imageTextCell = [PyqImageTextCell cellWithTableView:tableView];
        self.imageTextCell.pyqModel = pyqModel;
        self.imageTextCell.delegate = self;
        self.imageTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.imageTextCell;
    }
//    else if (![pyqModel.linkUrl isEqualToString:@""]){
        //链接
//    }else{
//        //视频与广告（预留位）
//    }
//    
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
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.tableOffset = scrollView.contentOffset.y;
    [self.textFl resignFirstResponder];
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    self.tableOffset = scrollView.contentOffset.y;
//}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    self.tableOffset = 0;
}
#pragma mark - ExteriorCellDelegate
- (void)ExteriorCellReloadView{
    
    [self.externalTable beginUpdates];
    [self.externalTable endUpdates];
}
#pragma mark - commentCellDelegate
- (void)commentCellReloadView{
    [self.externalTable reloadData];
}

#pragma mark - 图片预览Delegate
- (void)presentPreview:(NSArray *)imgArr curret:(NSInteger)indexRow{
    PyqPreviewController *pyqView = [[PyqPreviewController alloc] init];
    pyqView.imgArr = imgArr;
    pyqView.curret = indexRow;
    [self presentViewController:pyqView animated:YES completion:nil];
    
}
#pragma mark - 头像点击
- (void)headImgClick{
    
    TempViewViewController *temp = [[TempViewViewController alloc] init];
    [self.navigationController pushViewController:temp animated:YES];
}

#pragma mark - 所有朋友圈评论Delegate
- (void)commentCellComment:(NSMutableArray *)commentList toCritic:(NSString *)critic{
  

    [self.textFl becomeFirstResponder];
    self.commentList = commentList;
    self.criticStr = critic;
    if (![self.criticStr isEqualToString:@""]) {
        self.textFl.placeholder = [NSString stringWithFormat:@"@%@:",self.criticStr];
    }
    
}

-(void)textFieldDidChange :(UITextField *)textField{
    NSLog(@"%@",textField.text);
}
- (void)adjustView:(NSInteger)height{
    self.tableOffset = height;
}
#pragma mark - 键盘Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        NSLog(@"评论不能为空");
    }else{
        //去首尾空格
        textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self.commentList insertObject:@{@"from":@"当前用户名",@"to":self.criticStr,@"contect": textField.text} atIndex:self.commentList.count];
        textField.text = @"";
        
        [self.textFl resignFirstResponder];
        [self.externalTable reloadData];
    }
    
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    self.keyboardView.frame = CGRectMake(0, kHeight - self.keyboardHeight - 50, kWidth, self.keyboardHeight);

    CGFloat cellH = self.tableOffset - self.keyboardHeight;
    
    self.externalTable.contentOffset = CGPointMake(0,cellH);
}
- (void)keyboardWillHide:(NSNotification *)aNotification{
    self.keyboardView.frame = CGRectMake(0, kHeight, kWidth, self.keyboardHeight);
    self.externalTable.contentOffset = CGPointMake(0,self.tableOffset);
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
