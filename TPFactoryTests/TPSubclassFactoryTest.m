//
//  TPSubclassFactoryTest.m
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPSubclassFactory.h"
#import "TPSubclassFactoryTestHelpers.h"

@interface TPSubclassFactoryTest : XCTestCase {
    TPTestSubclassFactory *_factory;
}
@end

@implementation TPSubclassFactoryTest

- (void)setUp
{
    [super setUp];
    _factory = [[TPTestSubclassFactory alloc] initWithClass:[TPSubclassTestRoot class]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testNumberOfClassesInFactory {
    XCTAssertTrue([[_factory classes] count] > 0);
}

- (void) testClassForObject {
    Class cls = [_factory classForObject:testingString];
    XCTAssertTrue(cls == [TPSubclassTestClass2 class]);
}

@end
