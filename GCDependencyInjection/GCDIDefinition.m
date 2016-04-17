//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIDefinition.h"

@implementation GCDIDefinition

@synthesize klass = _klass,
            pSelector = _pSelector,
            factory = _factory,
            configurator = _configurator,
            arguments = _arguments,
            properties = _properties,
            methodInvocations = _methodInvocations,
            tags = _tags,
            pathToLibrary = _pathToLibrary,
            shared = _shared,
            public = _public,
            lazy = _lazy,
            synthetic = _synthetic,
            depreciated = _deprecated,
            depreciationMessage = _depreciationMessage;

# pragma mark - Init methods

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _arguments = @[].mutableCopy;
  _properties = @{}.mutableCopy;
  _methodInvocations = @[].mutableCopy;
  _tags = @{}.mutableCopy;

  _shared = TRUE;
  _public = TRUE;
  _synthetic = FALSE;
  _lazy = FALSE;

  return self;
}

- (id)initForClass:(NSString *)class withSelector:(SEL)pSelector {
  if ([self init] == nil) {
    return nil;
  }

  _klass = class.copy;
  _pSelector = pSelector;

  return self;
}

- (id)initForClass:(NSString *)class withSelector:(SEL)pSelector andArguments:(NSArray *)arguments {
  if ([self initForClass:class withSelector:pSelector] == nil) {
    return nil;
  }

  _arguments = arguments.mutableCopy;

  return self;
}

- (void)setArguments:(NSArray *)arguments {
  _arguments = arguments.mutableCopy;
}

- (void)setProperties:(NSDictionary *)properties {
  _properties = properties.mutableCopy;
}

- (void)setMethodInvocations:(NSArray *)methodInvocations {
  _methodInvocations = methodInvocations.mutableCopy;
}

- (void)setTags:(NSDictionary *)tags {
  _tags = tags.mutableCopy;
}

# pragma mark - Argument methods

- (void)addArgument:(id)argument {
  _arguments[_arguments.count] = argument;
}

- (void)replaceArgument:(id)argument atIndex:(NSUInteger)index {
  _arguments[index] = argument;
}

# pragma mark - Method invocations

- (void)addMethodInvocation:(NSInvocation *)methodInvocation {
  _methodInvocations[_methodInvocations.count] = methodInvocation;
}

- (void)addMethodCall:(SEL)pSelector withArguments:(NSArray *)arguments {
  NSMethodSignature *methodSignature = [NSMethodSignature methodSignatureForSelector:pSelector];
  NSInvocation *methodInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  NSInteger i = 2;
  for (id argument in arguments) {
    [methodInvocation setArgument:&argument atIndex:i];
    i++;
  }

  _methodInvocations[_methodInvocations.count] = methodInvocation;
}

- (void)removeMethodCall:(SEL)pSelector {
  for (NSInvocation *methodInvocation in _methodInvocations) {
    if ([NSStringFromSelector(methodInvocation.selector) isEqualToString:NSStringFromSelector(pSelector)]) {
      [_methodInvocations removeObject:methodInvocation];
    }
  }
}

- (BOOL)hasMethodCall:(SEL)pSelector {
  for (NSInvocation *methodInvocation in _methodInvocations) {
    if ([NSStringFromSelector(methodInvocation.selector) isEqualToString:NSStringFromSelector(pSelector)]) {
      return TRUE;
    }
  }
  return FALSE;
}

# pragma mark - Tagging methods

- (NSString *)getTag:(NSString *)tag {
  return _tags[tag];
}

- (void)clearTag:(NSString *)tag {
  [_tags removeObjectForKey:tag];
}

- (void)clearTags {
  _tags = @{}.mutableCopy;
}

# pragma mark - Depreciation methods

- (void)setDepreciated:(BOOL)status forReason:(NSString *)reason {
  _deprecated = status;
  _depreciationMessage = reason.copy;
}

@end
