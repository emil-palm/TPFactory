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
TPPROTOCOLFACTORY_SINGELTON_DEFAULT(TPTestProtocolFactory, @protocol(TPTestProtocolFactoryProtocol))

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

- (void)setObject:(id<NSObject>)object {
    
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

- (void)setObject:(id<NSObject>)object {
    
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

- (void)setObject:(id<NSObject>)object {
    
}

@end

@implementation TPProtocolFactoryClass5
+ (NSInteger)priority {
    return 4;
}
+ (BOOL)canHandleObject:(id<NSObject>)object {
    if ( [object isKindOfClass:[NSArray class]] ) {
        NSArray *objects = (NSArray *)object;
        if ( [objects count] > 0 ) {
            return [[objects objectAtIndex:0] isEqual:testingString];
        }
    }
    
    return NO;
}

+ (NSInteger)factoryType {
    return TPFactoryTestTypeOne;
}
@end