//
//  TPProtocolFactoryTestHelpers.m
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import "TPProtocolFactoryTestHelpers.h"
#import <objc/runtime.h>

NSString const *testingString = @"TestingObject";

@implementation TPTestProtocolFactory
- (NSDictionary *)classes {
    Ivar classesIvar = class_getInstanceVariable([self class], "_classes");
    return object_getIvar(self, classesIvar);
}
@end


@implementation TPProtocolFactoryClass1
+ (BOOL)canHandleObject:(id<NSObject>)object {
    return YES;
}

+ (NSInteger)priority {
    return 1;
}
+ (NSInteger)factoryType {
    return TPFactoryTestTypeOne;
}

@end


@implementation TPProtocolFactoryClass2
+ (BOOL)canHandleObject:(id<NSObject>)object {
    return YES;
}

+ (NSInteger)priority {
    return 2;
}
+ (NSInteger)factoryType {
    return TPFactoryTestTypeOne;
}

@end


@implementation TPProtocolFactoryClass3
+ (NSInteger)priority {
    return 3;
}
+ (BOOL)canHandleObject:(id<NSObject>)object {
    return [object isEqual:testingString];
}

+ (NSInteger)factoryType {
    return TPFactoryTestTypeOne;
}
@end


@implementation TPProtocolFactoryClass4
+ (NSInteger)priority {
    return 0;
}
+ (BOOL)canHandleObject:(id<NSObject>)object {
    return YES;
}

+ (NSInteger)factoryType {
    return TPFactoryTestTypeTwo;
}
@end


