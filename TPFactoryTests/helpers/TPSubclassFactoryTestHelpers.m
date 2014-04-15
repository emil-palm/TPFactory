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

TPSUBCLASSFACTORY_SINGLETON(TPTestSubclassFactory, [TPSubclassTestRoot class], TPProtocolFactoryDefaultOptions)

- (NSArray *)classes {
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

- (void)setObject:(id<NSObject>)object {
    
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

- (void)setObject:(id<NSObject>)object {
    
}

@end

@implementation TPSubclassTestClass4

+ (NSInteger)priority {
    return 3;
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

@end