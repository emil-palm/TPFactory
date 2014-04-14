//
//  TPProtocolFactory.h
//  TPFactory
//
//  Created by Emil Palm on 03/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPBaseFactory.h"

@protocol TPFactoryProtocol<TPBaseFactoryProtocol>
/*
 @return A integer / enum that is 'unique' for a type of subclass you want
 eg, a specific viewcontroller such as for viewing a single object, and another integer for
 viewing a set of objects
 */
+ (NSInteger) factoryType;
@end


@interface TPProtocolFactory : TPBaseFactory
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
- (void) enumarateObjectsOfType:(NSInteger)type usingBlock:(TPFactoryClassBlock)block;
@end
