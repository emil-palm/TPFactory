//
//  TPProtocolFactory.h
//  TPFactory
//
//  Created by Emil Palm on 03/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPFactoryProtocols.h"

typedef NS_OPTIONS(NSInteger, TPProtocolFactoryOptions) {
    TPProtocolFactoryIncludeSystemFrameworks                = 1 << 0,
    TPProtocolFactorySortByHighestFirst                     = 1 << 1,
    TPProtocolFactorySortByLowestFirst                      = 1 << 2,
    TPProtocolFactoryDefaultOptions                         = TPProtocolFactoryIncludeSystemFrameworks|TPProtocolFactorySortByHighestFirst
};

@protocol TPFactoryProtocol<TPBasicFactoryProtocol>
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


@interface TPProtocolFactory : NSObject

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
- (id) initWithProtocol: (Protocol *) proto andOptions: (TPProtocolFactoryOptions) options;

/**
 *  Method for accessing class in factory
 *
 *  @param type class type
 *
 *  @return higest prioritzed class for type.
 */
- (Class) classForType: (NSInteger) type;

/**
 *  Method for accessing class in factory using a certain object to find the optimal class
 *
 *  @param type class type
 *  @param obj object used for evaulation
 *
 *  @return highest priozitzed and matching class that can handle the object
 */
- (Class) classForType: (NSInteger) type withObject: (id<NSObject>) obj;

/**
 *  Method for accessing a class in the factory using a certain set of objects to find the optimal class
 *
 *  @param type class type
 *  @param obj first object, nil terimnated will send array to all classes
 *
 *  @return class
 */
- (Class) classForType: (NSInteger) type withObjects: (id<NSObject>) obj, ... __attribute__((sentinel));

/**
 *  Metod to enumerate all classes and execute the block for each class on given type
 *
 *  @param type  class type
 *  @param block block to be executed with each class as argument
 */

- (void) enumarateObjectsOfType:(NSInteger)type usingBlock:(TPClassBlock)block;

@end
