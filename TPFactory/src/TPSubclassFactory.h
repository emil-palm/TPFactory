//
//  TPSubclassFactory.h
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPBaseFactory.h"

/**
 *  Macro to setup a singleton for a subclass factory
 *  Just add the following to your header
 *      + (instanceof) shared;
 *
 *  And call this macro inside your @implementation of factoryClass
 *
 *  @param factoryClass the factory class
 *  @param parentClass  The class that all subclasses should inherit off
 *  @param options      Options for this instance
 *
 *  @return shared instance
 */
#define TPSUBCLASSFACTORY_SINGLETON(factoryClass, parentClass, options) \
+ (factoryClass *) shared { \
    static factoryClass *sharedInstance = nil;\
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        sharedInstance = [[factoryClass alloc] initWithClass:parentClass andOptions:options];\
    });\
    return sharedInstance;\
}

/**
 *  Macro to setup a singleton for a subclass factory using default options
 *  Just add the following to your header
 *      + (instanceof) shared;
 *
 *  And call this macro inside your @implementation of factoryClass
 *
 *  @param factoryClass the factory class
 *  @param parentClass  The class that all subclasses should inherit off
 *
 *  @return shared instance
 */
#define TPSUBCLASSFACTORY_SINGELTON_DEFAULT(factoryClass, parentClass) \
    TPPROTOCOLFACTORY_SINGLETON(factoryClass, parentClass, TPProtocolFactoryDefaultOptions)


@interface TPSubclassFactory : TPBaseFactory
/**
 *  Method to initilize with default options
 *
 *  @param parentClass The class that all subclasses should inherit off
 *
 *  @return self
 */
- (id)initWithClass:(Class)parentClass;

/**
 *  Method to initialize the subclass factory type
 *
 *  @param parentClass The class that all subclasses should inherit off
 *  @param options     Options for this instance
 *
 *  @return self
 */
- (id)initWithClass:(Class)parentClass andOptions: (TPFactoryOptions) options;
@end
