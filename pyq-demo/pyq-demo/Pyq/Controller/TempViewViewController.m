//
//  TempViewViewController.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/4.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "TempViewViewController.h"

@interface TempViewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tempView;

@end

@implementation TempViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tempView setImage:[UIImage imageNamed:@"user_0.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
