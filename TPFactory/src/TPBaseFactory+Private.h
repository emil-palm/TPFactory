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
    Protocol *protocol;
    TPFactoryOptions _options;
}

extern NSString * const kClassesKey;

/**
 *  Method that will initlize internal properties could be called multiple times.
 *
 *  @return A object able to contain multiple classes, eg. set, dictionary and so on.
 */
- (id) _classes;

/**
 *  This method is called when TPFactoryDebugValidatePriority option is set and classes changes
 *  Base implementation will loop over [self _classes] and check priority on all classes and assert if their is two of the same priority
 *  as this might give you race conditions
 */
- (void) validateClassPriority;
@end