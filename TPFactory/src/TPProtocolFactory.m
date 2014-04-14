//
//  TPProtocolFactory.m
//  TPFactory
//
//  Created by Emil Palm on 03/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import "TPProtocolFactory.h"
#import "TPBaseFactory+Private.h"
@implementation TPProtocolFactory

- (NSString *) keyForType: (NSInteger) type {
    return [NSString stringWithFormat:@"%d", (int)type];
}

- (id)initWithProtocol: (Protocol *) proto {
    return [self initWithProtocol:proto andOptions:TPProtocolFactoryDefaultOptions];
}

- (id)initWithProtocol:(Protocol *)proto andOptions:(TPFactoryOptions)options {
    self = [self init];
    if (self) {
        protocol = proto;
        [self _classes];
    }
    return self;
}

- (NSDictionary *) _classes {
    // Lets be lazy
    if ( !_classes ) {
        // Check that number of classes is bigger then zero, if so.
        int numClasses = objc_getClassList(NULL, 0);
        if (numClasses > 0 ) {
            
            // Lets create dictionary and anticipiate that all classes in the loop can be handleded by the factory.
            // this is the seldom the case, if it would be the case we would be doing something very wrong.
            NSMutableDictionary *classesConforming = [NSMutableDictionary dictionaryWithCapacity:numClasses];
            
            // Lets allocate space for all possible classes
            Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
            
            // If we where able to allocate space we can continue
            if ( classes != NULL ) {
                // Lets copy over the list of classes into the newly allocated memory
                numClasses = objc_getClassList(classes, numClasses);
                
                // Let the magic begin, loop over all the classes on by one and see if they match our given protocol.
                for (int i = 0; i < numClasses; i++) {
                    if (class_conformsToProtocol(classes[i], protocol)) {
                        Class cls = classes[i];
                        // Lets create a lookup key for this class.
                        NSString *key = [self keyForType:[classes[i] factoryType]];
                        // If we already have a array to use we use that or we create a new also this will be able to hold all classes
                        NSMutableArray *clsArray;
                        if ( ![classesConforming objectForKey:key] ) {
                            clsArray = [NSMutableArray arrayWithCapacity:numClasses];
                            [classesConforming setObject:clsArray forKey:key];
                        } else {
                            clsArray = [classesConforming objectForKey:key];
                        }
                        // Lets add our class to the array so it can be used in the factory
                        [clsArray addObject:cls];
                    }
                }
                
                // Release our memory that we allocated before.
                free(classes);
                
                // So lets sort our arrays using the priority class method
                for (NSString *clsListKey in [classesConforming allKeys]) {
                    NSArray *clsArray = [(NSMutableArray *)[classesConforming objectForKey:clsListKey] sortedArrayUsingComparator:^NSComparisonResult(Class cls1, Class cls2) {
                        NSInteger prioCls1 = (NSInteger)objc_msgSend(cls1, @selector(priority));
                        NSInteger prioCls2 = (NSInteger)objc_msgSend(cls2, @selector(priority));
                        
                        if ( prioCls1 > prioCls2 )
                            return NSOrderedAscending;
                        else if (prioCls1 < prioCls2 )
                            return NSOrderedDescending;
                        else
                            return NSOrderedSame;
                    }];
                    [classesConforming setObject:clsArray forKey:clsListKey];
                }
                
                // Copy the classes into our instance variable for later use
                _classes = [classesConforming copy];
            }
        }
    }
    
    return _classes;

}

- (Class)classForType:(NSInteger)type withObject: (id<NSObject>) obj {
    NSArray *classesForType;
    // Grab the classes that we can use
    if ( (classesForType = [self classesForType: type]) ) {
        // Lets loop over them and check if they can handle the object passed to us
        for (Class cls in classesForType) {
            if ( [cls canHandleObject: obj] ) {
                return cls;
            }
        }
        return nil;
    } else {
        return nil;
    }
}

- (Class)classForType:(NSInteger)type {
    return [self classForType:type withObject:nil];
}

- (NSArray *) classesForType: (NSInteger) type {
    return [[self _classes] objectForKey:[self keyForType:type]];
}

- (Class)classForType:(NSInteger)type withObjects: (id<NSObject>) obj, ... __attribute__((sentinel)) {
    va_list args;
    va_start(args, obj);
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:10];
    for(; obj != nil; obj = va_arg(args, id<NSObject>)) {
        [arguments addObject:obj];
    }
    va_end(args);
    return [self classForType:type withObject:arguments];
}


- (void)enumarateObjectsOfType:(NSInteger)type usingBlock:(TPFactoryClassBlock)block {
    for (Class cls in [self classesForType:type]) {
        block(cls);
    }
}

@end
