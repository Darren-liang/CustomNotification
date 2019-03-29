//
//  CNEventSet.h
//  Notification优化
//
//  Created by liangweidong on 2019/3/28.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CNBlockObject;

@interface CNEventSet : NSObject

@property(nonatomic, strong)NSMutableArray<CNBlockObject *> *blockObjectArray;

@end

