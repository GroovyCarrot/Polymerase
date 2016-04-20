//
// GCDependencyInjection
//
// Created by Jake Wise on 28/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIParameterBag.h"
#import "GCDIExceptions.h"
#import "GCDIAlternativeSuggesterProtocol.h"
#import "GCDIAlternativeSuggester.h"

@implementation GCDIParameterBag {
 @private
  NSMutableDictionary *_parameters;
  id <GCDIAlternativeSuggesterProtocol> _alternativeSuggester;
}

@synthesize resolved = _resolved;

- (id)init {
  return [self initWithParameters:@{}
          andAlternativeSuggester:[[GCDIAlternativeSuggester alloc] init]];
}

- (id)initWithParameters:(NSDictionary *)parameters {
  return [self initWithParameters:parameters
          andAlternativeSuggester:[[GCDIAlternativeSuggester alloc] init]];
}

- (id)initWithParameters:(NSDictionary *)parameters
 andAlternativeSuggester:(id <GCDIAlternativeSuggesterProtocol>)alternativeSuggester {
  self = [super init];
  if (!self) {
    return nil;
  }

  _parameters = @{}.mutableCopy;
  _resolved = FALSE;
  _alternativeSuggester = alternativeSuggester;

  [self addParameters:parameters];

  return self;
}

# pragma mark - Setting and getting parameters

- (void)clearParameters {
  [self checkIfBagIsInResolvedState];

  [_parameters removeAllObjects];
}

- (void)addParameters:(NSDictionary *)parameters {
  [self checkIfBagIsInResolvedState];

  for (NSString *key in parameters.allKeys) {
    _parameters[[key lowercaseString]] = parameters[key];
  }
}

- (NSDictionary *)allParameters {
  return _parameters.copy;
}

- (id)getParameter:(NSString *)name {
  name = [name lowercaseString];
  if (name == nil) {
    [NSException raise:GCDIParameterNotFoundException
                format:@"Parameter \"%@\" not found", name];
  }

  if (_parameters[name] == nil) {
    NSArray *alternatives = [_alternativeSuggester alternativesForItem:name
                                                     inPossibleOptions:_parameters.allKeys];

    [NSException raise:GCDIParameterNotFoundException
                format:@"Parameter \"%@\" not found. Did you mean one of the following? %@", name, alternatives];
  }

  return _parameters[name];
}

- (void)removeParameter:(NSString *)name {
  [self checkIfBagIsInResolvedState];

  [_parameters removeObjectForKey:[name lowercaseString]];
}

- (void)setParameter:(NSString *)name value:(id)value {
  [self checkIfBagIsInResolvedState];

  _parameters[[name lowercaseString]] = value;
}

- (BOOL)hasParameter:(NSString *)name {
  return (BOOL) _parameters[[name lowercaseString]];
}

- (void)checkIfBagIsInResolvedState {
  if (_resolved) {
    [NSException raise:GCDIRuntimeException
                format:@"Cannot modify GCDIParameterBag after -resolveAllParameters has been invoked."];
  }
}

# pragma mark - Resolving parameter placeholders

- (void)resolveAllParameters {
  if (_resolved) {
    return;
  }

  NSMutableDictionary *parameters = @{}.mutableCopy;
  for (NSString *name in _parameters.allKeys) {
    @try {
      id value = _parameters[name];
      id resolvedValue = [self resolveParameterPlaceholders:value];
      parameters[name] = [self unescapeParameterPlaceholders:resolvedValue];
    }
    @catch (NSException *e) {
      NSMutableDictionary *info = e.userInfo.mutableCopy;
      info[@"SourceKey"] = name;
      @throw [NSException exceptionWithName:[e name]
                                     reason:[e reason]
                                   userInfo:info.copy];
    }
  }

  _parameters = parameters;
  _resolved = TRUE;
}

- (id)resolveParameterPlaceholders:(id)value {
  NSMutableDictionary *resolvedParameters = @{}.mutableCopy;
  return [self resolveParameterPlaceholderForValue:value resolving:resolvedParameters];
}

- (id)resolveParameterPlaceholderForValue:(id)_value
                                resolving:(NSMutableDictionary *)resolvedParameters {
  if ([_value isKindOfClass:[NSString class]]) {
    return [self resolveParameterPlaceholdersInString:_value
                                            resolving:resolvedParameters];
  }
  else if ([_value isKindOfClass:[NSDictionary class]]) {
    NSDictionary *value = _value;

    NSMutableDictionary *args = @{}.mutableCopy;
    for (NSString *key in value.allKeys) {
      NSString *resolvedKey = [self resolveParameterPlaceholderForValue:key
                                                              resolving:resolvedParameters];

      args[resolvedKey] = [self resolveParameterPlaceholderForValue:value[key]
                                                          resolving:resolvedParameters];
    }
    return args.copy;
  }
  else if ([_value isKindOfClass:[NSArray class]]) {
    NSArray *value = _value;

    NSMutableArray *args = @[].mutableCopy;
    for (NSUInteger i = 0; i < value.count; i++) {
      args[i] = [self resolveParameterPlaceholderForValue:value[i]
                                                resolving:resolvedParameters];
    }
    return args.copy;
  }

  return _value;
}

- (id)resolveParameterPlaceholdersInString:(NSString *)value
                                 resolving:(NSMutableDictionary *)resolvedParameters {
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^%([^%\\s]+)%$"
                                                                         options:0
                                                                           error:nil];
  NSArray *matches = [regex matchesInString:value
                                    options:0
                                      range:NSMakeRange(0, value.length)];

  if (matches.count) {
    NSString *key = [[value substringWithRange:[matches[0] rangeAtIndex:1]] lowercaseString];
    if (resolvedParameters[key]) {
      [NSException raise:GCDICircularReferenceException
                  format:@"Circular reference detected. Previously resolved parameters: %@", resolvedParameters];
    }

    resolvedParameters[key] = @TRUE;
    id keyValue = [self getParameter:key];

    if (!_resolved) {
      keyValue = [self resolveParameterPlaceholderForValue:keyValue
                                                 resolving:resolvedParameters];
    }

    return keyValue;
  }

  regex = [NSRegularExpression regularExpressionWithPattern:@"%%|%([^%\\s]+)%"
                                                    options:0
                                                      error:nil];

  NSArray *allReplacements = [regex matchesInString:value options:0 range:NSMakeRange(0, value.length)];
  if (!allReplacements.count) {
    return value;
  }

  for (NSTextCheckingResult *match in allReplacements) {
    NSRange matchRange = [match rangeAtIndex:0];
    NSRange keyRange = [match rangeAtIndex:1];

    if (keyRange.location == NSNotFound) {
      continue;
    }

    NSString *matchedText = [value substringWithRange:keyRange];
    if ([matchedText isEqualToString:@"%%"]) {
      continue;
    }

    NSString *key = [matchedText lowercaseString];

    if (resolvedParameters[key]) {
      [NSException raise:GCDICircularReferenceException
                  format:@"Circular reference detected with resolved parameters: %@.", resolvedParameters];
    }

    id resolved = [self getParameter:key];

    if (![resolved isKindOfClass:[NSString class]] && ![resolved isKindOfClass:[NSNumber class]]) {
      [NSException raise:GCDIRuntimeException
                  format:@"A string value must be composed of strings and/or numbers. Parameter \"%@\" instance: %@", key, resolved];
    }

    if ([resolved isKindOfClass:[NSNumber class]]) {
      resolved = [resolved stringValue];
    }

    if (!_resolved) {
      resolved = [self resolveParameterPlaceholdersInString:resolved
                                                  resolving:nil];
    }

    value = [value stringByReplacingCharactersInRange:matchRange
                                           withString:resolved];
  }

  return value;
}

- (id)escapeParameterPlaceholders:(id)_value {
  if ([_value isKindOfClass:[NSString class]]) {
    return [_value stringByReplacingOccurrencesOfString:@"%" withString:@"%%"];
  }
  else if ([_value isKindOfClass:[NSDictionary class]]) {
    NSDictionary *value = _value;

    NSMutableDictionary *escapedValues = @{}.mutableCopy;
    for (NSString *key in value.allKeys) {
      escapedValues[key] = [self escapeParameterPlaceholders:value[key]];
    }
    return escapedValues;
  }
  else if ([_value isKindOfClass:[NSArray class]]) {
    NSArray *value = _value;

    NSMutableArray *escapedValues = @[].mutableCopy;
    for (NSUInteger i = 0; i < value.count; i++) {
      escapedValues[i] = [self escapeParameterPlaceholders:value[i]];
    }
    return escapedValues;
  }

  return _value;
}

- (id)unescapeParameterPlaceholders:(id)_value {
  if ([_value isKindOfClass:[NSString class]]) {
    return [_value stringByReplacingOccurrencesOfString:@"%%" withString:@"%"];
  }
  else if ([_value isKindOfClass:[NSDictionary class]]) {
    NSDictionary *value = _value;

    NSMutableDictionary *unescapedValues = @{}.mutableCopy;
    for (NSString *key in value.allKeys) {
      unescapedValues[key] = [self unescapeParameterPlaceholders:value[key]];
    }
    return unescapedValues;
  }
  else if ([_value isKindOfClass:[NSArray class]]) {
    NSArray *value = _value;

    NSMutableArray *unescapedValues = @[].mutableCopy;
    for (NSUInteger i = 0; i < value.count; i++) {
      unescapedValues[i] = [self unescapeParameterPlaceholders:value[i]];
    }
    return unescapedValues;
  }

  return _value;
}

@end
