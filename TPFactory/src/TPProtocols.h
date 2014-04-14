//
//  TPProtocols.h
//  TPFactory
//
//  Created by Emil Palm on 12/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

typedef void(^TPClassBlock)(__unsafe_unretained Class cls);

@protocol TPBasicFactoryProtocol <NSObject>
/*
 @return A integer / enum that is 'unique' for a type of subclass you want
 eg, a specific viewcontroller such as for viewing a single object, and another integer for
 viewing a set of objects
 */
+ (NSInteger) factoryType;
@end