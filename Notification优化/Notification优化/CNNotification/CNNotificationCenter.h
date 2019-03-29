//
//  CNNotificationCenter.h
//  Notification优化
//
//  Created by liangweidong on 2019/3/28.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNBlockObject.h"

#define kDefaultNotificationName @"PSSDefaultNotification"

@class CNEventSet;

@interface CNNotificationCenter : NSObject

//单例
+(instancetype)defaultCenter;

//添加事件
-(void)addEvent:(CNNotiEventBlock)eventBlock observer:(NSObject *)observer;
- (void)addEvent:(CNNotiEventBlock)eventBlock eventName:(NSString *)eventName observer:(NSObject *)observer;

//触发 发送通知      info:传值
-(void)postNotificationByName:(NSString *)name info:(id)info;
-(void)postDefaultNotification:(id)info;

//移除对应通知事件
-(void)removeNotificationName:(NSString *)name;

//移除所有通知下的observer对应的事件（不给此observer发送事件了）
-(void)removeNotificationObserver:(NSObject *)observer;
-(void)removeNotificationObserverByEventSet:(CNEventSet *)event;

//移除对应通知下，对应observer的事件
-(void)removeNotificationName:(NSString *)name observer:(NSObject *)observer;

//移除所有事件
-(void)removeAllNotification;

@end

