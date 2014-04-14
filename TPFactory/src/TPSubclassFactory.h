//
//  TPSubclassFactory.h
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPBaseFactory.h"
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
