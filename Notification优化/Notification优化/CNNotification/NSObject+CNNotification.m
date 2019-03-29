//
//  NSObject+CNNotification.m
//  Notification优化
//
//  Created by liangweidong on 2019/3/28.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import "NSObject+CNNotification.h"
#import "CNEventSet.h"
#import <objc/runtime.h>

static char CNEventSetKey;

@implementation NSObject (CNNotification)

-(void)setEventSet:(CNEventSet *)eventSet
{
    objc_setAssociatedObject(self, &CNEventSetKey, eventSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CNEventSet *)eventSet
{
    CNEventSet *eventSet = objc_getAssociatedObject(self, &CNEventSetKey);
    if (!eventSet)
    {
        eventSet = [CNEventSet new];
        [self setEventSet:eventSet];
    }
    return eventSet;
}

@end
