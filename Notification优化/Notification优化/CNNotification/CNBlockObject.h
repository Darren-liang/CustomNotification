//
//  CNBlockObject.h
//  Notification优化
//
//  Created by liangweidong on 2019/3/28.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CNNotiEventBlock)(id info);

@interface CNBlockObject : NSObject

@property(nonatomic, copy)CNNotiEventBlock eventHandler;

@end

