//
//  NSObject+CNNotification.h
//  Notification优化
//
//  Created by liangweidong on 2019/3/28.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CNEventSet;

@interface NSObject (CNNotification)

@property(nonatomic, strong)CNEventSet *eventSet;

@end

