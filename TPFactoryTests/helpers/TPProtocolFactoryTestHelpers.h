//
//  TPProtocolFactoryTestHelpers.h
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TPFactory.h"
extern NSString *testingString;

typedef enum {
    TPFactoryTestTypeOne,
    TPFactoryTestTypeTwo,
} TPFactoryTestTypes;

@protocol TPTestProtocolFactoryProtocol <TPFactoryProtocol>
@end

@interface TPProtocolFactoryClass1 : NSObject<TPTestProtocolFactoryProtocol>
@end

@interface TPProtocolFactoryClass2 : NSObject<TPTestProtocolFactoryProtocol>
@end

@interface TPProtocolFactoryClass3 : NSObject<TPTestProtocolFactoryProtocol>
@end

@interface TPProtocolFactoryClass4 : NSObject<TPTestProtocolFactoryProtocol>
@end


@interface TPTestProtocolFactory : TPProtocolFactory
- (NSDictionary *) classes;
@end
