//
//  PyqPreviewController.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/8.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "PyqPreviewController.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface PyqPreviewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    CGFloat offset;
   
}

@end

@implementation PyqPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    offset = 0.0;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setCurret:(NSInteger)curret{
    _curret = curret;
     [_scrollView setContentOffset:CGPointMake(curret *kWidth, 0) animated:YES];
}
- (void)setImgArr:(NSArray *)imgArr{
    _imgArr = imgArr;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
    _scrollView.backgroundColor = [UIColor blackColor];
    
    _scrollView.contentSize = CGSizeMake(kWidth *_imgArr.count, kHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.minimumZoomScale = 1;
    _scrollView.showsHorizontalScrollIndicator = NO;
    //设置最大缩放比例（默认1.0）
    _scrollView.maximumZoomScale = 2;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    //向ScrollView上铺设两张图片
    for (int i = 0; i<_imgArr.count; i++){
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];

        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1;
        
        UIScrollView *smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight)];
        smallScrollView.backgroundColor = [UIColor clearColor];
        smallScrollView.contentSize = CGSizeMake(kWidth, kHeight);
        smallScrollView.showsHorizontalScrollIndicator = NO;
        smallScrollView.showsVerticalScrollIndicator = NO;
        smallScrollView.delegate = self;
        smallScrollView.minimumZoomScale = 1.0;
        smallScrollView.maximumZoomScale = 3.0;
        smallScrollView.tag = i+1;
        [smallScrollView setZoomScale:1.0];

        UIImageView *imageview = [[UIImageView alloc] init];

        imageview.image = [UIImage imageNamed:_imgArr[i]];
        imageview.frame = CGRectMake(0, 0, kWidth, kHeight);
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.userInteractionEnabled = YES;
        imageview.tag = i+1;
        [imageview addGestureRecognizer:doubleTap];
        [imageview addGestureRecognizer:singleRecognizer];

        [smallScrollView addSubview:imageview];
        
        [_scrollView addSubview:smallScrollView];

    }
   

}

#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _scrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    UIImageView *image = [[s subviews] objectAtIndex:0];
                    image.frame = CGRectMake(0, 0, kWidth, kHeight);
                }
            }
        }
    }
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
//}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"Did zoom!");
    UIView *v = [scrollView.subviews objectAtIndex:0];
    if ([v isKindOfClass:[UIImageView class]]){
        if (scrollView.zoomScale<1.0){
            //         v.center = CGPointMake(scrollView.frame.size.width/2.0, scrollView.frame.size.height/2.0);
        }
    }
}

#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    UIView *view = gesture.view.superview;
    if ([view isKindOfClass:[UIScrollView class]]){
        UIScrollView *s = (UIScrollView *)view;
        [s zoomToRect:zoomRect animated:YES];
    }
}
- (void)singleTap:(UIGestureRecognizer *)gesture{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Utility methods

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(CGRect)resizeImageSize:(CGRect)rect{
    //    NSLog(@"x:%f y:%f width:%f height:%f ", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGRect newRect;
    
    CGSize newSize;
    CGPoint newOri;
    
    CGSize oldSize = rect.size;
    if (oldSize.width>=320.0 || oldSize.height>=460.0){
        float scale = (oldSize.width/320.0>oldSize.height/460.0?oldSize.width/320.0:oldSize.height/460.0);
        newSize.width = oldSize.width/scale;
        newSize.height = oldSize.height/scale;
    }
    else {
        newSize = oldSize;
    }
    newOri.x = (320.0-newSize.width)/2.0;
    newOri.y = (460.0-newSize.height)/2.0;
    
    newRect.size = newSize;
    newRect.origin = newOri;
    
    return newRect;
}

- (void)viewWillDisappear:(BOOL)animated{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

@end
