//
//  TPSubclassFactoryTestHelpers.m
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import "TPSubclassFactoryTestHelpers.h"
#import <objc/runtime.h>

@implementation TPTestSubclassFactory
- (NSSet *)classes {
    Ivar classesIvar = class_getInstanceVariable([self class], "_classes");
    return object_getIvar(self, classesIvar);
}
@end

@implementation TPSubclassTestRoot
@end

@implementation TPSubclassTestClass1
+ (NSInteger)priority {
    return 0;
}

+ (BOOL)canHandleObject:(id<NSObject>)object {
    return YES;
}
@end

@implementation TPSubclassTestClass2
+ (NSInteger)priority {
    return 1;
}

+ (BOOL)canHandleObject:(id<NSObject>)object {
    return [object isEqual:testingString];
}

@end

@implementation TPSubclassTestClass3
+ (NSInteger)priority {
    return 2;
}

+ (BOOL)canHandleObject:(id<NSObject>)object {
    return NO;
}

@end

