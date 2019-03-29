//
//  CNNotificationCenter.m
//  Notification优化
//
//  Created by liangweidong on 2019/3/28.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import "CNNotificationCenter.h"
#import "CNEventSet.h"
#import "NSObject+CNNotification.h"

#define lwd_dispatch_queue_main_async_safe(block)\
if ([[NSThread currentThread] isMainThread]){\
    block();\
}else{\
    dispatch_sync(dispatch_get_main_queue(), block);\
}

@interface CNNotificationCenter ()

@property(nonatomic, strong)NSMutableDictionary <NSString *, NSMapTable<NSString *, CNEventSet *> *> *eventDict;

@end

static CNNotificationCenter *center = nil;

@implementation CNNotificationCenter
/** 真正单例 */
+(instancetype)defaultCenter
{
    return [[self alloc] init];
}
-(instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [super init];
    });
    return center;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [super allocWithZone:zone];
    });
    return center;
}
/** 真正单例 */

-(void)addEvent:(CNNotiEventBlock)eventBlock observer:(NSObject *)observer
{
    [self addEvent:eventBlock eventName:kDefaultNotificationName observer:observer];
}
-(void)addEvent:(CNNotiEventBlock)eventBlock eventName:(NSString *)eventName observer:(NSObject *)observer
{
    if (!eventBlock)
    {
        return;
    }
    
    if (!observer)
    {
        return;
    }
    
    if (!eventName.length)
    {
        eventName = kDefaultNotificationName;
    }
    
    lwd_dispatch_queue_main_async_safe((^{
        NSMapTable *notiDict = self.eventDict[eventName];
        if (!notiDict)
        {
            notiDict = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsWeakMemory];
            [self.eventDict setValue:notiDict forKey:eventName];
        }
        
        NSString *observerKey = [NSString stringWithFormat:@"%p", observer.eventSet];
        CNEventSet *eventSet = [notiDict objectForKey:observerKey];
        if (!eventSet)
        {
            eventSet = observer.eventSet;
            [notiDict setObject:eventSet forKey:observerKey];
        }
        
        CNBlockObject *blockObj = [[CNBlockObject alloc] init];
        blockObj.eventHandler = eventBlock;
        
        [eventSet.blockObjectArray addObject:blockObj];
    }));
}

-(void)postDefaultNotification:(id)info
{
    [self postNotificationByName:kDefaultNotificationName info:info];
}

-(void)postNotificationByName:(NSString *)name info:(id)info
{
    lwd_dispatch_queue_main_async_safe(^{
        NSMapTable *notiDict = [self.eventDict valueForKey:name];
        if (!notiDict)
        {
            return;
        }
        
        for (NSString *obsKey in notiDict)
        {
            CNEventSet *eventSet = [notiDict objectForKey:obsKey];
            for (CNBlockObject *blockObj in eventSet.blockObjectArray)
            {
                blockObj.eventHandler(info);
            }
        }
    });
}

//移除对应通知事件
-(void)removeNotificationName:(NSString *)name
{
    lwd_dispatch_queue_main_async_safe(^{
        NSMapTable *notiDict = [self.eventDict valueForKey:name];
        if (!notiDict)
        {
            return;
        }
        for (NSString *obserName in notiDict)
        {
            CNEventSet *eventSet = [notiDict objectForKey:obserName];
            [eventSet.blockObjectArray removeAllObjects];
        }
        [self.eventDict removeObjectForKey:name];
    });
}

//移除所有通知下的mobserver对应的事件（不给此observer发送事件了）
-(void)removeNotificationObserver:(NSObject *)observer
{
    lwd_dispatch_queue_main_async_safe((^{
        for (NSString *notiName in self.eventDict)
        {
            NSMapTable *notiDic = [self.eventDict valueForKey:notiName];
            if (!notiDic)
            {
                continue;
            }
            
            NSString *observerKey = [NSString stringWithFormat:@"%p", observer.eventSet];
            CNEventSet *eventSet = [notiDic objectForKey:observerKey];
            if (!eventSet)
            {
                continue;
            }
            
            [eventSet.blockObjectArray removeAllObjects];
            [notiDic removeObjectForKey:observerKey];
        }
    }));
}

-(void)removeNotificationObserverByEventSet:(CNEventSet *)event
{
    lwd_dispatch_queue_main_async_safe((^{
        for (NSString *notiName in self.eventDict)
        {
            NSMapTable *notiDic = [self.eventDict valueForKey:notiName];
            if (!notiDic)
            {
                continue;
            }
            
            NSString *observerKey = [NSString stringWithFormat:@"%p", event];
            CNEventSet *eventSet = [notiDic objectForKey:observerKey];
            [notiDic removeObjectForKey:observerKey];
            if (!eventSet)
            {
                continue;
            }
            [eventSet.blockObjectArray removeAllObjects];
        }
    }));
}

//移除对应通知下，对应observer的事件
-(void)removeNotificationName:(NSString *)name observer:(NSObject *)observer
{
    if (!name)
    {
        name = kDefaultNotificationName;
    }
    
    if (!observer)
    {
        return;
    }
    
    NSMapTable *notiDic = self.eventDict[name];
    if (!notiDic)
    {
        return;
    }
    
    lwd_dispatch_queue_main_async_safe((^{
        NSString *obserkey = [NSString stringWithFormat:@"%p", observer.eventSet];
        CNEventSet *eventSet = [notiDic objectForKey:obserkey];
        [eventSet.blockObjectArray removeAllObjects];
        [notiDic removeObjectForKey:obserkey];
    }));
}

//移除所有事件
-(void)removeAllNotification
{
    lwd_dispatch_queue_main_async_safe((^{
        for (NSString *notiName in self.eventDict)
        {
            NSMapTable *notiDict = [self.eventDict objectForKey:notiName];
            for (NSString *obserKey in notiDict)
            {
                CNEventSet *eventSet = [notiDict objectForKey:obserKey];
                [eventSet.blockObjectArray removeAllObjects];
            }
        }
        [self.eventDict removeAllObjects];
    }));
}
#pragma mark - getter
-(NSMutableDictionary<NSString *,NSMapTable<NSString *,CNEventSet *> *> *)eventDict
{
    if (_eventDict == nil)
    {
        _eventDict = [NSMutableDictionary dictionary];
    }
    return _eventDict;
}
@end
