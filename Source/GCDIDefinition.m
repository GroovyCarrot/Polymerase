//
// GCDependencyInjection
//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIDefinition.h"
#import "GCDIMethodCall.h"

@implementation GCDIDefinition {
 @protected
  // Internally, we will use mutable objects for more efficient memory
  // management.
  NSMutableArray<id> *_arguments;
  NSMutableDictionary<NSString *, id> *_setters;
  NSMutableArray<GCDIMethodCall *> *_methodCalls;
  // @todo switch string based tags for dictionary tags, to allow a tag to have
  // attributes.
  NSMutableDictionary<NSString *, NSString *> *_tags;
}

@synthesize isPublic = _public;

# pragma mark - Init methods

- (id)init {
  self = [super init];
  if (!self) {
    return nil;
  }

  _arguments = @[].mutableCopy;
  _setters = @{}.mutableCopy;
  _methodCalls = @[].mutableCopy;
  _tags = @{}.mutableCopy;

  _shared = TRUE;
  _public = TRUE;
  _synthetic = FALSE;
  _lazy = FALSE;

  return self;
}

- (GCDIDefinition *)initForClassNamed:(NSString *)klass withSelector:(NSString *)pSelector andArguments:(NSArray *)arguments {
  if (![self init]) {
    return nil;
  }

  _klass = klass.copy;
  _initializer = pSelector.copy;
  _arguments = arguments.mutableCopy;

  return self;
}

# pragma mark - Setters

- (void)setClass:(Class)klass {
  _klass = NSStringFromClass(klass).copy;
}

- (void)setInitializerSelector:(SEL)pSelector {
  _initializer = NSStringFromSelector(pSelector).copy;
}

- (void)setArguments:(NSArray<id> *)arguments {
  _arguments = arguments.mutableCopy;
}

- (void)setSetters:(NSDictionary<NSString *, id> *)setters {
  _setters = setters.mutableCopy;
}

- (void)setMethodCalls:(NSArray<GCDIMethodCall *> *)methodCalls {
  _methodCalls = methodCalls.mutableCopy;
}

- (void)setTags:(NSDictionary<NSString *, NSString *> *)tags {
  _tags = tags.mutableCopy;
}

# pragma mark - Argument methods

- (void)addArgument:(id)argument {
  _arguments[_arguments.count] = argument;
}

- (void)replaceArgumentAtIndex:(NSUInteger)index with:(id)argument {
  _arguments[index] = argument;
}

# pragma mark - Method invocations

- (void)addMethodCall:(GCDIMethodCall *)methodCall {
  _methodCalls[_methodCalls.count] = methodCall;
}

- (void)removeMethodCall:(GCDIMethodCall *)methodCall {
  for (GCDIMethodCall *method in _methodCalls) {
    if ([methodCall isEqualToMethodCall:method]) {
      [_methodCalls removeObject:method];
    }
  }
}

- (BOOL)hasMethodCall:(GCDIMethodCall *)methodCall {
  for (GCDIMethodCall *method in _methodCalls) {
    if ([methodCall isEqualToMethodCall:method]) {
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
  [_tags removeAllObjects];
}

# pragma mark - Depreciation methods

- (void)setDepreciated:(BOOL)status forReason:(NSString *)reason {
  _depreciated = status;
  _depreciationMessage = reason.copy;
}

@end
