//
//  CNBlockObject.m
//  Notification优化
//
//  Created by liangweidong on 2019/3/28.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import "CNBlockObject.h"

@implementation CNBlockObject

-(void)dealloc
{
    NSLog(@"observer - 销毁了");
}

@end
