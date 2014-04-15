TPFactory
=========

TPFactory is a factory pattern implementation taking advantage of the Objective-C runtime to eliminate the need for header imports and long if statements.

### **DO YOU USE TPFACTORY?**
Please let me know.



## Installation

### Podfile (Recomended)

Add the following line to your podfile and install.

Check out [CocoaPods](http://guides.cocoapods.org/) for more information

```ruby
pod "TPFactory", "~> 0.0.1"
```

Run ```pod install``` in your project directory.

### Framework

1. git clone https://github.com/mrevilme/TPFactory.git
2. open TPFactory.xcodeproj
3. build the aggregate target of TPFactory
4. Now there will be a build/ folder inside the TPFactory folder
5. Drag the TPFactory.framework into your project and start using TPFactory.

### Submodule (Not recommended if you dont know what your doing)

1. git submodule add https://github.com/mrevilme/TPFactory.git TPFactory
2. Drag the TPFactory.xcodeproj into your project
3. Add TPFactory as build dependency for your project.
4. Add TPFactory to linked frameworks for your project
5. Specify add "TPFactory/TPFactory/src/" to your "Header Search Path"

## Usage
First of all, TPFactory is made up of two different implementations of how to detect classes that should exist in the factory.

1. **TPSubclassFactory**

   Will add all subclasses that implements the TPBaseFactoryProtocol protocol of given class.

2. **TPProtocolFactory**

   Will add all classes in the runtime which implements the specified protocol.

They both use a protocol TPBaseFactoryProtocol or deriviate to identify classes that should be in the factory.
TPBaseFactoryProtocol is defined as following:
```objc
@protocol TPBaseFactoryProtocol <NSObject>
+ (NSInteger) priority;
+ (BOOL) canHandleObject: (id<NSObject>) object;
- (void) setObject: (id<NSObject>) object;
@end
```

### TPSubclassFactory
1. So say you have the following model classes

```objc
   @interface TPUser : TPModel
   @end

   @interface TPManager : TPUser
   @end

   @interface TPDeveloper : TPUser
   @end
```

2. And you want to be able to take dictionary that represents either a manager or a developer and just chuck that into the factory and get the best matching class back.
Lets redefine our models to following:

```objc
@interface TPUser : TPModel
@end

@interface TPManager : TPUser<TPBaseFactoryProtocol>
@end

@interface TPDeveloper : TPUser<TPBaseFactoryProtocol>
@end
```

and or implementations

** User **
```objc
@implementation TPUser
@end
```

** Developer **
```objc
@implementation TPDeveloper
+ (NSInteger) priority {
  return 0;
}

+ (BOOL) canHandleObject: (id<NSObject>) object {
  id value = nil;
  if ( (value = [object isKindOfClass:[NSDictionary class]] ) ) {
    return [[value objectForKey: @"role"] isEqualToString: @"developer"] );
  }
  return NO;
}

- (void) setObject: (id<NSObject>) object {
  [self parseDictionary: object];
}
@end
```
** Manager **
```objc
@implementation TPManager
+ (NSInteger) priority {
  return 1;
}

+ (BOOL) canHandleObject: (id<NSObject>) object {
  id value = nil;
  if ( (value = [object isKindOfClass:[NSDictionary class]] ) ) {
    return [[value objectForKey: @"role"] isEqualToString: @"manager"] );
  }
  return NO;
}

- (void) setObject: (id<NSObject>) object {
  [self parseDictionary: object];
}
@end
```

Now we have made our classes ready for the TPSubclassFactory type of factory. Lets create a instance of a subclass factory and use it.

```objc
// Create a instance of the factory with the TPUser class as the root class and default options
TPSubclassFactory *userFactory = [[TPSubclassFactory alloc] initWithClass: NSClassFromString(@"TPUser") andOptions: TPProtocolFactoryDefaultOptions];
// Create two dictionaries that we can test it out with
NSDictionary *fakeDeveloperDictionary = @{@"role":@"developer"};
NSDictionary *fakeManagerDictionary = @{@"role":@"manager"};

// Now create a instance with the developer dictionary
id<NSObject> developer = [userFactory createInstanceForObject:fakeDeveloperDictionary];
// Now create a instance with the manager dictionary
id<NSObject> manager = [userFactory createInstanceForObject:fakeManagerDictionary];

NSLog(@"Developer: %@", NSStringFromClass([developer class]));
NSLog(@"Manager: %@", NSStringFromClass([manager class]));
```

Would output:

```
User: TPDeveloper
Manager: TPManager
```

### TPProtocolFactory

As the name implies instead of using subclasses to find which ones to add this will look for a specific protocol to add it also has another feature set to it.

1. Lets begin with defining our protocol that we look for, this needs to be unique for each factory implementation you have. Eg you might have one for models, one for viewcontroller and so on.

```objc
@protocol TPUserFactoryProtocol <TPProtocolFactoryProtocol>
@end
```

1. Lets reuse our models form the previous example but with a small change, lets add a new type of object into the mix.

```objc
@interface TPManager : TPUser<TPUserFactoryProtocol>
@end

@interface TPDeveloper : TPUser<TPUserFactoryProtocol>
@end

@interface TPGroup : TPModel<TPUserFactoryProtocol>
@property(nonatomic,strong) NSArray *users;
@end
```

and here comes the implementations:

** Developer **
```objc
@implementation TPDeveloper
+ (NSInteger) priority {
  return 0;
}

+ (BOOL) canHandleObject: (id<NSObject>) object {
  id value = nil;
  if ( (value = [object isKindOfClass:[NSDictionary class]] ) ) {
    return [[value objectForKey: @"role"] isEqualToString: @"developer"] );
  }
  return NO;
}

- (void) setObject: (id<NSObject>) object {
  [self parseDictionary: object];
}

+ (NSInteger) factoryType {
  return 1;
}
@end
```
** Manager **
```objc
@implementation TPManager
+ (NSInteger) priority {
  return 1;
}

+ (BOOL) canHandleObject: (id<NSObject>) object {
  id value = nil;
  if ( (value = [object isKindOfClass:[NSDictionary class]] ) ) {
    return [[value objectForKey: @"role"] isEqualToString: @"manager"] );
  }
  return NO;
}

- (void) setObject: (id<NSObject>) object {
  [self parseDictionary: object];
}

+ (NSInteger) factoryType {
  return 1;
}

@end
```

** Group **
```objc
@implementation TPGroup
+ (NSInteger) priority {
  return 2;
}

+ (BOOL) canHandleObject: (id<NSObject>) object {
  id value = nil;
  if ( (value = [object isKindOfClass:[NSDictionary class]] ) ) {
    return [[value objectForKey: @"role"] isEqualToString: @"group"] );
  }
  return NO;
}

- (void) setObject: (id<NSObject>) object {
  // lets not do anything right now.
}

+ (NSInteger) factoryType {
  return 1;
}

@end
```

So we now have our objects setup again. lets to a simple example on how to to use the factory this time as a singleton.

```objc
@interface TPObjectFactory : TPProtocolFactory
+ (id) shared;
@end

@implementation TPObjectFactory
TPPROTOCOLFACTORY_SINGELTON_DEFAULT(TPObjectFactory, @protocol(TPUserFactoryProtocol));
@end
```
```objc
#import "TPObjectFactory.h"

// Create two dictionaries that we can test it out with
NSDictionary *fakeDeveloperDictionary = @{@"role":@"developer"};
NSDictionary *fakeManagerDictionary = @{@"role":@"manager"};
NSDictionary *fakeGroupDictionary = @{@"role":@"group", @"users":@[fakeDeveloperDictionary,fakeManagerDictionary]};

// Now create a instance with the developer dictionary
id<NSObject> developer = [[TPObjectFactory shared] createInstanceForObject:fakeDeveloperDictionary];
// Now create a instance with the manager dictionary
id<NSObject> manager = [[TPObjectFactory shared] createInstanceForObject:fakeManagerDictionary];
// Now create a instance with the group dictionary
id<NSObject> group = [[TPObjectFactory shared] createInstanceForObject:fakeManagerDictionary];

NSLog(@"Developer: %@", NSStringFromClass([developer class]));
NSLog(@"Manager: %@", NSStringFromClass([manager class]));
NSLog(@"Group: %@", NSStringFromClass([group class]));
```
Would output:

```
User: TPDeveloper
Manager: TPManager
Group: TPGroup
```

Lets now do some more stuff with this. Remember we didn't do anything with the group model. Thats about to change.

** Group **
```objc
#import "TPObjectFactory.h"

@implementation TPGroup
+ (NSInteger) priority {
  return 2;
}

+ (BOOL) canHandleObject: (id<NSObject>) object {
  id value = nil;
  if ( (value = [object isKindOfClass:[NSDictionary class]] ) ) {
    return [[value objectForKey: @"role"] isEqualToString: @"group"] );
  }
  return NO;
}

- (void) setObject: (id<NSObject>) object {
  if ( [object isKindOfClass:[NSDictionary class]] ) {
    id value = nil;
    if ( (value = [object objectForKey:@"users"]) && [value isKindOfClass:[NSArray class]]) {
      NSMutableArray *_users = [NSMutableArray arrayWithCapacity: [value count]];
      for(NSDictionary *user in value) {
        [_users addObject:[[TPObjectFactory shared] createInstanceForObject:user]];
      }
      [self setUsers:[_users copy]];
    }
  }
}

+ (NSInteger) factoryType {
  return 1;
}

@end
```

## Credits
- [Cesar Pinto Castillo](https://github.com/jagcesar) ([@jagcesar](http://twitter.com/jagcesar)) - His help in the beginning got this project to even exist.
- [Simon Westerlund](https://github.com/westerlund) - Simon pushed me to opensource and refactor this project from being a total mess.

### Maintainers

- [Emil Palm](http://github.com/mrevilme) ([@mrevilme](https://twitter.com/mrevilme))

## License

TPFactory is available under the MIT license. See the LICENSE file for more info.
