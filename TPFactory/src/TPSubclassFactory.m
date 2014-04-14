//
//  TPSubclassFactory.m
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import "TPSubclassFactory.h"
#import "TPBaseFactory+Private.h"

@interface TPSubclassFactory () {
    NSSet *_classes;
    Class parentClass;
}
@end

@implementation TPSubclassFactory

- (id)initWithClass:(Class)parent {
    return [self initWithClass:parent andOptions:TPProtocolFactoryDefaultOptions];
}

- (id)initWithClass:(Class)parent andOptions: (TPFactoryOptions) options {
    
    self = [self initWithOptions:options];
    @synchronized(self) {
        if ( self ) {
            protocol = objc_getProtocol("TPBaseFactoryProtocol");
            parentClass = parent;
            [self _classes];
        }
    }
    return self;
}

- (NSSet *) _classes {
    if ( !_classes ) {
        NSUInteger numClasses = objc_getClassList(NULL, 0);
        if (numClasses > 0 )
        {
            NSMutableSet *classesConforming = [NSMutableSet setWithCapacity:numClasses];
            Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
            if ( classes != NULL) {
                numClasses = objc_getClassList(classes, (int)numClasses);
                for (int i = 0; i < numClasses; i++) {
                    if ( class_getSuperclass(classes[i]) == parentClass ) {
                        Class cls = classes[i];
                        if ( class_conformsToProtocol(cls, protocol) ) {
                            [classesConforming addObject:cls];
                        }
                    }
                }
                _classes = [classesConforming copy];
            }
        }
    }
    return _classes;
}

- (Class)classForObject:(id<NSObject>)obj {
    for (Class<TPBaseFactoryProtocol> cls in [self _classes]) {
        if ( class_respondsToSelector(cls, @selector(canHandleObject:)) ) {
            if ( [cls canHandleObject: obj] ) {
                return cls;
            }
        }
    }
    return nil;
}

@end
