//
//  TPSubclassFactoryTestHelpers.h
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPFactory.h"


@interface TPTestSubclassFactory : TPSubclassFactory
+ (instancetype) shared;
- (NSArray *) classes;
@end

extern NSString *testingString;

@interface TPSubclassTestRoot : NSObject
@end

@interface TPSubclassTestClass1 : TPSubclassTestRoot<TPBaseFactoryProtocol>
@end

@interface TPSubclassTestClass2 : TPSubclassTestRoot<TPBaseFactoryProtocol>
@property(nonatomic,strong) id<NSObject> object;
@end

@interface TPSubclassTestClass3 : TPSubclassTestRoot<TPBaseFactoryProtocol>
@end

@interface TPSubclassTestClass4 : TPSubclassTestRoot<TPBaseFactoryProtocol>
@property(nonatomic,strong) id<NSObject> object;
@end

@interface TPSubclassTestClass5 : TPSubclassTestClass3<TPBaseFactoryProtocol>
@end

@interface UISubclassTestingClass1 : TPSubclassTestRoot<TPBaseFactoryProtocol>
@end