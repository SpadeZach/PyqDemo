//
//  PyqModel.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/4.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "PyqModel.h"

@implementation PyqModel
- (instancetype)initWithDictionary:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;

}
@end
