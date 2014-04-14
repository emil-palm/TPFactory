//
//  TPBaseFactory.h
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TPFactoryClassBlock)(__unsafe_unretained Class cls);

typedef NS_OPTIONS(NSInteger, TPFactoryOptions) {
    TPFactoryPrioritySortDesc                                       = 1 << 0,
    TPFactoryPrioritySortAsc                                        = 1 << 1,
    TPProtocolFactoryIncludeSystemFrameworks                        = 1 << 2,
    TPProtocolFactoryDefaultOptions                                 = TPProtocolFactoryIncludeSystemFrameworks|TPFactoryPrioritySortDesc,
    TPSubclassFactoryDefaultOptions                                 = TPFactoryPrioritySortDesc
};

@protocol TPBaseFactoryProtocol <NSObject>
/*
 @return a integer for sorting of the diffrent types, higher is better
 */
+ (NSInteger) priority;
/*
 @parameter id This is used to determain if your viewcontroller can handle that type of object
 @return BOOL if you can handle object provided.
 */
+ (BOOL) canHandleObject: (id<NSObject>) object;
@end


@interface TPBaseFactory : NSObject
/**
 *  This method is used to prepare the factory with default options
 *
 *  @param proto The protocol to be used as identifier for those classes that should be present in the factory
 *
 *  @return self
 */
- (id) initWithProtocol: (Protocol *) proto;

/**
 *  This method is to used to prepare the factory for usage.
 *
 *  @param proto   The protocol to be used as identifier for those classes that should be present in the factory
 *  @param options options for the factory
 *
 *  @return self
 */
- (id) initWithProtocol: (Protocol *) proto andOptions: (TPFactoryOptions) options;
@end