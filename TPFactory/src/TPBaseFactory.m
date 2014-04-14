//
//  TPBaseFactory
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//
#import "TPBaseFactory.h"
#import "TPBaseFactory+Private.h"

static NSString * const kClassesKey = @"_classes";

@implementation TPBaseFactory

- (NSSet *) _classes {
    NSAssert([self class] != [TPBaseFactory class], @"Dont call this method directly on TPBaseFactory use a subclass");
    return nil;
}

- (id)init {
    return [self initWithOptions:TPProtocolFactoryDefaultOptions];
}

- (id)initWithOptions:(TPFactoryOptions)options {
    NSAssert([self class] != [TPBaseFactory class], @"Dont call this method directly on TPBaseFactory use a subclass");
    self = [super init];
    if (self) {
        _options = options;
        if ( _options & TPFactoryDebugValidatePriority ) {
            [self addObserver:self
                   forKeyPath:kClassesKey
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
        }
        
    }
    return self;
}

- (Class)classForObject:(id<NSObject>)obj {
    NSAssert([self class] != [TPBaseFactory class], @"Dont call this method directly on TPBaseFactory use a subclass");
    for (Class<TPBaseFactoryProtocol> cls in [self _classes]) {
        if ( [cls canHandleObject: obj] ) {
            return cls;
        }
    }
    
    return nil;
}

- (Class)classForObjects: (id<NSObject>) obj, ... __attribute__((sentinel)) {
    NSAssert([self class] != [TPBaseFactory class], @"Dont call this method directly on TPBaseFactory use a subclass");
    va_list args;
    va_start(args, obj);
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:10];
    for(; obj != nil; obj = va_arg(args, id<NSObject>)) {
        [arguments addObject:obj];
    }
    va_end(args);
    return [self classForObject:arguments];
}

- (void)enumarateObjectsUsingBlock:(TPFactoryClassBlock)block {
    NSAssert([self class] != [TPBaseFactory class], @"Dont call this method directly on TPBaseFactory use a subclass");
    for (Class cls in [self _classes]) {
        block(cls);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( (_options & TPFactoryDebugValidatePriority) && [keyPath isEqualToString:kClassesKey] ) {
        [self validateClassPriority];
    }
}

- (void)dealloc {
    if ( _options & TPFactoryDebugValidatePriority ) {
        [self removeObserver:self forKeyPath:kClassesKey context:NULL];
    }
}

- (void) validateClassPriority {
    NSDictionary *classPriorities = [NSMutableDictionary dictionaryWithCapacity:100];
    [self enumarateObjectsUsingBlock:^(Class cls) {
        Class<TPBaseFactoryProtocol> correctClass = cls;
        
        NSString *priorityKey = [[NSNumber numberWithInteger:[correctClass priority]] stringValue];
        Class<TPBaseFactoryProtocol> previousClass = nil;
        if ((previousClass = [classPriorities objectForKey:priorityKey]) ) {
            NSAssert(NO, @"WARNING! Class priority duplication between: %@ and %@", NSStringFromClass(previousClass), correctClass);
        }
    }];
}



@end