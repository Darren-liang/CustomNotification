//
//  CNEventSet.m
//  Notification优化
//
//  Created by liangweidong on 2019/3/28.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import "CNEventSet.h"
#import "CNBlockObject.h"
#import "CNNotificationCenter.h"

@implementation CNEventSet

-(NSMutableArray<CNBlockObject *> *)blockObjectArray
{
    if (!_blockObjectArray)
    {
        _blockObjectArray = [NSMutableArray array];
    }
    return _blockObjectArray;
}
-(void)dealloc
{
    NSLog(@"EventSet 被销毁了");
    [[CNNotificationCenter defaultCenter] removeNotificationObserverByEventSet:self];
}
@end
