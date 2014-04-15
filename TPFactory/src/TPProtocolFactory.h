//
//  TPProtocolFactory.h
//  TPFactory
//
//  Created by Emil Palm on 03/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPBaseFactory.h"

/**
 *  Macro to setup a singleton for a protocol factory
 *  Just add the following to your header
 *      + (instanceof) shared;
 *
 *  And call this macro inside your @implementation of factoryClass
 *
 *  @param factoryClass the factory class
 *  @param protocol     The protocol to be used as identifier for those classes that should be present in the factory
 *  @param options      Options for this instance
 *
 *  @return shared instance
 */
#define TPPROTOCOLFACTORY_SINGLETON(factoryClass, protocol, options) \
+ (factoryClass *) shared { \
    static factoryClass *sharedInstance = nil;\
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        sharedInstance = [[factoryClass alloc] initWithProtocol:protocol andOptions:options];\
    });\
    return sharedInstance;\
}

/**
 *  Macro to setup a singleton for a protocol factory using default options
 *  Just add the following to your header
 *      + (instanceof) shared;
 *
 *  And call this macro inside your @implementation of factoryClass
 *
 *  @param factoryClass the factory class
 *  @param protocol     The protocol to be used as identifier for those classes that should be present in the factory
 *
 *  @return shared instance
 */
#define TPPROTOCOLFACTORY_SINGELTON_DEFAULT(factoryClass, protocol) \
    TPPROTOCOLFACTORY_SINGLETON(factoryClass, protocol, TPProtocolFactoryDefaultOptions)



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
 *  Method for accessing a class of a specific type in the factory
 *
 *  @param type class type
 *
 *  @return higest prioritzed class for type.
 */
- (Class) classForType: (NSInteger) type;

/**
 *  Method for accessing a class of a specific type in factory using a certain object to find the optimal class
 *
 *  @param type class type
 *  @param obj object used for evaulation
 *
 *  @return highest priozitzed and matching class that can handle the object
 */
- (Class) classForType: (NSInteger) type withObject: (id<NSObject>) obj;

/**
 *  Method for accessing a class of a specific type in the factory using a certain set of objects to find the optimal class
 *
 *  @param type class type
 *  @param obj first object, nil terimnated will send array to all classes
 *
 *  @return class
 */
- (Class) classForType: (NSInteger) type withObjects: (id<NSObject>) obj, ... __attribute__((sentinel));

/**
 *  Method for creating a new instance of class in factory using a object to find the optimal class
 *
 *  @param type class type
 *  @param obj object used for evaulation
 *
 *  @return new instance of highest priozitzed and matching class that can handle the object
 */
- (id) createInstanceForType: (NSInteger) type withObject: (id<NSObject>) obj;

/**
 *  Method for creating a new instance of class in factory using a certain set of objects to find the optimal class
 *
 *  @param type class type
 *  @param obj first object, nil terimnated will send array to all classes
 *
 *  @return new instance of highest priozitzed and matching class that can handle the object
 */
- (id) createInstanceForType: (NSInteger) type withObjects: (id<NSObject>) obj, ... __attribute__((sentinel));


/**
 *  Metod to enumerate all classes and execute the block for each class on given type
 *
 *  @param type  class type
 *  @param block block to be executed with each class as argument
 */
- (void) enumarateObjectsOfType:(NSInteger)type usingBlock:(TPFactoryClassBlock)block;
@end
