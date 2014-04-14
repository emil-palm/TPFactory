//
//  TPProtocolFactory.m
//  TPFactory
//
//  Created by Emil Palm on 06/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

#import "TPFactory.h"
static NSString const *testingString = @"TestingObject";

typedef enum {
    TPFactoryTestTypeOne,
    TPFactoryTestTypeTwo,
} TPFactoryTestTypes;

@protocol TPTestProtocolFactoryProtocol <TPFactoryProtocol>
@end

@interface TPTestProtocolFactory : TPProtocolFactory
- (NSDictionary *) classes;
@end

@implementation TPTestProtocolFactory
- (NSDictionary *)classes {
    Ivar classesIvar = class_getInstanceVariable([self class], "_classes");
    return object_getIvar(self, classesIvar);
}
@end

@interface TPProtocolFactoryClass1 : NSObject<TPTestProtocolFactoryProtocol>
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

@interface TPProtocolFactoryClass2 : NSObject<TPTestProtocolFactoryProtocol>
@end

@implementation TPProtocolFactoryClass2
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

@interface TPProtocolFactoryClass3 : NSObject<TPTestProtocolFactoryProtocol>
@end

@implementation TPProtocolFactoryClass3
+ (NSInteger)priority {
    return 2;
}
+ (BOOL)canHandleObject:(id<NSObject>)object {
    return [object isEqual:testingString];
}

+ (NSInteger)factoryType {
    return TPFactoryTestTypeOne;
}
@end

@interface TPProtocolFactoryClass4 : NSObject<TPTestProtocolFactoryProtocol>
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


@interface TPProtocolFactoryTest : XCTestCase {
    TPTestProtocolFactory *_factory;
}
@end

@implementation TPProtocolFactoryTest

- (void)setUp {
    _factory = [[TPTestProtocolFactory alloc] initWithProtocol:@protocol(TPTestProtocolFactoryProtocol)];
}

- (void) testFoundClasses {
    XCTAssertTrue([[[_factory classes] allKeys] count] > 0,  @"We should atleast find one class in the factory");
}

- (void) testRetrieveExplictClassWithoutObject {
    Class cls = [_factory classForType:TPFactoryTestTypeOne];
    XCTAssertEqual(cls, [TPProtocolFactoryClass1 class], @"We should get class2");
}

- (void) testRetrieveExplicitClassWithObject {
    Class cls = [_factory classForType:TPFactoryTestTypeOne
                            withObject:testingString];
    XCTAssertEqual(cls, [TPProtocolFactoryClass3 class], @"We should get class3");
}

- (void) testPriority {
    NSArray *items = [[_factory classes] objectForKey:@"0"];
    XCTAssertTrue((NSInteger)[[items objectAtIndex:0] priority] >= (NSInteger)[[items objectAtIndex:1] priority], @"We should have GoE priority");
    XCTAssertTrue((NSInteger)[[items objectAtIndex:1] priority] >= (NSInteger)[[items objectAtIndex:2] priority], @"We should have GoE priority");
}

- (void) testDifferentFactoryType {
    Class cls = [_factory classForType:TPFactoryTestTypeTwo];
    NSArray *clses = [[_factory classes] objectForKey:@"1"];
    XCTAssertTrue([clses count] == 1);
    XCTAssertTrue((cls == [TPProtocolFactoryClass4 class]));
}



@end
