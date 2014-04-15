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
    NSArray *_classes;
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

- (NSArray *) _classes {
    if ( !_classes ) {
        NSUInteger numClasses = objc_getClassList(NULL, 0);
        if (numClasses > 0 )
        {
            NSMutableArray *classesConforming = [NSMutableArray arrayWithCapacity:numClasses];
            Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
            if ( classes != NULL) {
                numClasses = objc_getClassList(classes, (int)numClasses);
                for (int i = 0; i < numClasses; i++) {
                    BOOL foundParentClass = NO;
                    BOOL isFinished = NO;
                    Class currentLoopClass = classes[i];
                    while (!foundParentClass && !isFinished ) {
                        Class superClass = class_getSuperclass(currentLoopClass);
                        if ( superClass == parentClass ) {
                            foundParentClass = YES;
                        } else if ( superClass == [NSObject class] || superClass == nil ) {
                            isFinished = YES;
                        } else {
                            currentLoopClass = superClass;
                        }
                    }
                    
                    if ( foundParentClass ) {
                        Class cls = classes[i];
                        if ( class_conformsToProtocol(cls, protocol) ) {
                            [classesConforming addObject:cls];
                        }
                    }
                }
                
                [classesConforming sortUsingComparator:^NSComparisonResult(Class<TPBaseFactoryProtocol> cls1, Class<TPBaseFactoryProtocol> cls2) {
                    NSInteger prioCls1 = [cls1 priority];
                    NSInteger prioCls2 = [cls2 priority];
                    
                    if ( prioCls1 > prioCls2 )
                        return (_options & TPFactoryPrioritySortDesc ? NSOrderedAscending : NSOrderedDescending);
                    else if (prioCls1 < prioCls2 )
                        return (_options & TPFactoryPrioritySortDesc ? NSOrderedDescending : NSOrderedAscending);
                    else
                        return NSOrderedSame;
                }];
                
                [self willChangeValueForKey:kClassesKey];
                _classes = [classesConforming copy];
                [self didChangeValueForKey:kClassesKey];
            }
        }
    }
    return _classes;
}

@end
