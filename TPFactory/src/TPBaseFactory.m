//
//  TPBaseFactory
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//
#import "TPBaseFactory.h"
#import "TPBaseFactory+Private.h"

NSString * const kClassesKey = @"_classes";
static NSSet *_frameworkPrefixes = nil;

@implementation TPBaseFactory

+ (BOOL) isFrameworkClass: (Class) cls {
    if ( !_frameworkPrefixes ) {
        _frameworkPrefixes = [NSSet setWithObjects:@"AB",
                              @"UI",
                              @"CA",
                              @"AC",
                              @"AD",
                              @"AL",
                              @"AU",
                              @"AV",
                              @"CB",
                              @"CF",
                              @"CG",
                              @"CI",
                              @"CL",
                              @"CM",
                              @"CV",
                              @"EA",
                              @"EK",
                              @"GC",
                              @"GLK",
                              @"JS",
                              @"MA",
                              @"MC",
                              @"MF",
                              @"MIDI",
                              @"MK",
                              @"MP",
                              @"NK",
                              @"NS",
                              @"PK",
                              @"QL",
                              @"SC",
                              @"Sec",
                              @"SK",
                              @"SL",
                              @"SS",
                              @"TW",
                              @"UT",
                              @"OS_",
                              nil];
    }
    NSString *className = NSStringFromClass(cls);
    __block BOOL foundFramework = NO;
    [_frameworkPrefixes enumerateObjectsUsingBlock:^(NSString *obj, BOOL *stop) {
        foundFramework = [className hasPrefix:obj];
        *stop = foundFramework;
    }];
    
    return foundFramework;
}

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

- (id)createInstanceForObject:(id<NSObject>)obj {
    NSAssert([self class] != [TPBaseFactory class], @"Dont call this method directly on TPBaseFactory use a subclass");
    Class cls = [self classForObject:obj];
    if ( cls ) {
        id<TPBaseFactoryProtocol> instance = [[cls alloc] init];
        [instance setObject:obj];
        return instance;
    } else {
        return nil;
    }
}

- (id)createInstanceForObjects:(id<NSObject>) obj, ... __attribute__((sentinel)) {
    
    NSAssert([self class] != [TPBaseFactory class], @"Dont call this method directly on TPBaseFactory use a subclass");
    va_list args;
    va_start(args, obj);
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:10];
    for(; obj != nil; obj = va_arg(args, id<NSObject>)) {
        [arguments addObject:obj];
    }
    va_end(args);
    
    return [self createInstanceForObject:arguments];
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
    NSMutableDictionary *classPriorities = [NSMutableDictionary dictionaryWithCapacity:100];
    [self enumarateObjectsUsingBlock:^(Class cls) {
        Class<TPBaseFactoryProtocol> correctClass = cls;
        
        NSString *priorityKey = [[NSNumber numberWithInteger:[correctClass priority]] stringValue];
        Class<TPBaseFactoryProtocol> previousClass = nil;
        if ((previousClass = [classPriorities objectForKey:priorityKey]) ) {
            NSAssert(NO, @"WARNING! Class priority duplication between: %@ and %@", NSStringFromClass(previousClass), correctClass);
        }
        [classPriorities setObject:cls forKey:priorityKey];
    }];
}



@end