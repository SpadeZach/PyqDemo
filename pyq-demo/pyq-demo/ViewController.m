//
//  ViewController.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/4.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "ViewController.h"
#import "ExteriorCell.h"
#import "PyqModel.h"
#import "TempViewViewController.h"
#import "AllPicturesCell.h"
#import "PyqPreviewController.h"
#import "PyqImageTextCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ExteriorCellDelegate,AllPicturesCellDelegate,PyqImageTextCellDelegate>
//外层table
@property (weak, nonatomic) IBOutlet UITableView *externalTable;

@property (nonatomic, strong) NSMutableArray *getArr;
@property (nonatomic, strong) ExteriorCell *extercell;
@property (nonatomic, strong) AllPicturesCell *allPicCell;
@property (nonatomic, strong) PyqImageTextCell *imageTextCell;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@end
 NSString *const identifi= @"exterTableCell";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"朋友圈";
    
    [self getData];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TempViewViewController *temp = [[TempViewViewController alloc] init];
    [self.navigationController pushViewController:temp animated:YES];
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

#pragma mark - ExteriorCellDelegate
- (void)ExteriorCellReloadView{
    
    [self.externalTable beginUpdates];
    [self.externalTable endUpdates];
}
#pragma mark - commentCellDelegate
- (void)commentCellReloadView{
    [self.externalTable reloadData];
}
- (void)presentPreview:(NSArray *)imgArr curret:(NSInteger)indexRow{
    PyqPreviewController *pyqView = [[PyqPreviewController alloc] init];
    pyqView.imgArr = imgArr;
    pyqView.curret = indexRow;
    [self presentViewController:pyqView animated:YES completion:nil];
    
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
