//
// GCDependencyInjection
//
// Created by Jake Wise on 29/05/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIInterpreter.h"
#import "GCDIInterpreterPluginProtocol.h"
#import "GCDIDefinitionContainer.h"

static NSMutableDictionary *$_plugins;

@implementation GCDIInterpreter

+ (void)registerInterpreter:(id<GCDIInterpreterPluginProtocol>)resolver forClass:(Class)klass {
  if (!$_plugins) {
    $_plugins = @{}.mutableCopy;
  }

  $_plugins[NSStringFromClass(klass)] = resolver;
}

- (id)interpretValue:(id)_value {
  if ([_value isKindOfClass:[NSArray class]]) {
    NSArray *values = _value;

    NSMutableArray *interpretedValues = @[].mutableCopy;
    for (id value in values) {
      interpretedValues[interpretedValues.count] = [self interpretValue:value];
    }
    return interpretedValues.copy;
  }

  if ([_value isKindOfClass:[NSDictionary class]]) {
    NSDictionary *values = _value;

    NSMutableDictionary *interpretedValues = @{}.mutableCopy;
    for (NSString *key in values.allKeys) {
      interpretedValues[key] = [self interpretValue:values[key]];
    }
    return interpretedValues.copy;
  }

  if ([_value isKindOfClass:[NSString class]]) {
    for (id<GCDIInterpreterPluginProtocol> resolver in $_plugins.allValues) {
      id value = [resolver interpretStringValue:_value];
      if (value != _value) {
        return value;
      }
    }
  }

  return _value;
}

- (id)resolveValue:(id)_value forContainer:(GCDIDefinitionContainer *)container {
  if ([_value isKindOfClass:[NSArray class]]) {
    NSArray *values = _value;

    NSMutableArray *resolvedServices = @[].mutableCopy;
    for (id service in values) {
      resolvedServices[resolvedServices.count] = [self resolveValue:service forContainer:container];
    }
    return resolvedServices.copy;
  }

  if ([_value isKindOfClass:[NSDictionary class]]) {
    NSDictionary *values = _value;

    NSMutableDictionary *resolvedServices = @{}.mutableCopy;
    for (NSString *key in values.allKeys) {
      resolvedServices[key] = [self resolveValue:values[key] forContainer:container];
    }
    return resolvedServices.copy;
  }

  if ([self hasResolverForClass:[_value class]]) {
    return [[self resolverForClass:[_value class]] resolveValue:_value forContainer:container];
  }

  return _value;
}

- (BOOL)hasResolverForClass:(Class)klass {
  return $_plugins[NSStringFromClass(klass)] != nil;
}

- (id<GCDIInterpreterPluginProtocol>)resolverForClass:(Class)klass {
  return $_plugins[NSStringFromClass(klass)];
}

@end
