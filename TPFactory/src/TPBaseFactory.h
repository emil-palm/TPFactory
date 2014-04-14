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
    TPFactoryDebugValidatePriority                                  = 1 << 2, // This should only be used in debug mode since it will slow down your load time.
    TPProtocolFactoryIncludeSystemFrameworks                        = 1 << 3,
#ifdef DEBUG
    TPProtocolFactoryDefaultOptions                                 = TPProtocolFactoryIncludeSystemFrameworks|
                                                                        TPFactoryPrioritySortDesc|
                                                                        TPFactoryDebugValidatePriority,
#else
    TPProtocolFactoryDefaultOptions                                 = TPProtocolFactoryIncludeSystemFrameworks|TPFactoryPrioritySortDesc,
#endif
    
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

/**
 *  Method for accessing class in factory using a certain object to find the optimal class
 *
 *  @param obj object used for evaulation
 *
 *  @return highest priozitzed and matching class that can handle the object
 */
- (Class) classForObject: (id<NSObject>) obj;

/**
 *  Method for accessing a class in the factory using a certain set of objects to find the optimal class
 *
 *  @param obj first object, nil terimnated will send array to all classes
 *
 *  @return class
 */
- (Class) classForObjects: (id<NSObject>) obj, ... __attribute__((sentinel));

/**
 *  Metod to enumerate all classes and execute the block for each class on given type
 *
 *  @param block block to be executed with each class as argument
 */
- (void) enumarateObjectsUsingBlock:(TPFactoryClassBlock)block;
@end