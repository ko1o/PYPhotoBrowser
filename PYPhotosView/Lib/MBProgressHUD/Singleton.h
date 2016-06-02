//
//  Singleton.h
//  46-单例模式（完善）
//
//  Created by 谢培艺 on 15/9/28.
//  Copyright © 2015年 谢培艺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define SingletonH(name) + (instancetype)shared##name;
#if __has_feature(objc_arc) // arc

#define SingletonM(name) \
+ (instancetype) shared##name\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
\
});\
return _instance;\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
\
});\
return _instance;\
}\
\
- (instancetype)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}
#else

// MRC
#define SingletonM(name) \
+ (instancetype) shared##name\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
    _instance = [[self alloc] init];\
\
});\
return _instance;\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
    _instance = [super allocWithZone:zone];\
\
});\
return _instance;\
}\
\
- (instancetype)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
- (oneway void)release{  };\
- (id)retain { return self; };\
- (id)autorelease { return self; };\
- (NSUInteger)retainCount { return 1;};

#endif


