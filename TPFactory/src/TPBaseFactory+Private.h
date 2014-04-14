//
//  TPFactory+Private.h
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>

@interface TPBaseFactory () {
    @protected
    NSDictionary *_classes;
    Protocol *protocol;
}
- (NSDictionary *) _classes;
@end