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

#import "TPProtocolFactoryTestHelpers.h"

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
    XCTAssertEqual(cls, [TPProtocolFactoryClass2 class], @"We should get class2");
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
