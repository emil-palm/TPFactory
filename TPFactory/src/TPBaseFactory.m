//
//  TPBaseFactory
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//
#import "TPBaseFactory.h"
#import "TPBaseFactory+Private.h"

@implementation TPBaseFactory

- (NSDictionary *) _classes {
    return nil;
}

- (NSString *) keyForType: (NSInteger) type {
    return [NSString stringWithFormat:@"%d", (int)type];
}

- (id)initWithProtocol: (Protocol *) proto {
    return [self initWithProtocol:proto andOptions:TPProtocolFactoryDefaultOptions];
}

- (id)initWithProtocol:(Protocol *)proto andOptions:(TPFactoryOptions)options {
    self = [self init];
    if (self) {
        protocol = proto;
        [self _classes];
    }
    return self;
}

@end