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
/**
 *  Method that will provide the factories with the priority for this class.
 *
 *  @return class priority in relationship to the factory.
 */
+ (NSInteger) priority;

/**
 *  Method that is used to determain if we can handle the provided object
 *
 *  @param object can be of any type depending on what you send in so always assume the worst
 *
 *  @return YES or NO depending if you can handle the object or not
 */
+ (BOOL) canHandleObject: (id<NSObject>) object;
@end


@interface TPBaseFactory : NSObject
/**
 *  Designated initilizer for all factories
 *
 *  @param options that should be applied to this factory instance
 *
 *  @return self
 */
- (id) initWithOptions: (TPFactoryOptions) options;

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