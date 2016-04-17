//
// Created by Jake Wise on 28/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIParameterBag.h"
#import "GCDIParameterNotFoundException.h"
#import "GCDIParameterCircularReferenceException.h"
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

- (void)clearParameters {
  [_parameters removeAllObjects];
}

- (void)addParameters:(NSDictionary *)parameters {
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
    @throw [GCDIParameterNotFoundException exceptionForParameterNamed:name];
  }

  if (_parameters[name] == nil) {
    NSArray *alternatives = [_alternativeSuggester alternativesForItem:name
                                                     inPossibleOptions:_parameters.allKeys];

    @throw [GCDIParameterNotFoundException exceptionForParameterNamed:name
                                                          andSourceId:nil
                                           withAlternativeSuggestions:alternatives];
  }

  return _parameters[name];
}

- (void)removeParameter:(NSString *)name {
  [_parameters removeObjectForKey:[name lowercaseString]];
}

- (void)setParameter:(NSString *)name value:(id)value {
  _parameters[[name lowercaseString]] = value;
}

- (BOOL)hasParameter:(NSString *)name {
  return (BOOL) _parameters[[name lowercaseString]];
}

- (void)resolveParameterPlaceholders {
  if (_resolved) {
    return;
  }

  NSMutableDictionary *parameters = @{}.mutableCopy;
  for (NSString *name in _parameters.allKeys) {
    @try {
      id value = parameters[name];
      id resolvedValue = [self resolveParameterPlaceholderForValue:value];
      parameters[name] = [self unescapeParameterPlaceholdersForValue:resolvedValue];
    }
    @catch (GCDIParameterNotFoundException *e) {
      [e setSourceKey:name];
      @throw e;
    }
  }

  _parameters = parameters;
  _resolved = TRUE;
}

- (id)resolveParameterPlaceholderForValue:(id)value {
  NSMutableDictionary *resolvedParameters = @{}.mutableCopy;
  return [self resolveParameterPlaceholderForValue:value resolving:resolvedParameters];
}

- (id)resolveParameterPlaceholderForValue:(id)_value
                                resolving:(NSMutableDictionary *)resolvedParameters {
  if ([_value isKindOfClass:[NSString class]]) {
    return [self resolveParameterPlaceholderForValueTypeString:_value
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
  }
  else if ([_value isKindOfClass:[NSArray class]]) {
    NSArray *value = _value;

    NSMutableArray *args = @[].mutableCopy;
    for (NSUInteger i = 0; i < value.count; i++) {
      args[i] = [self resolveParameterPlaceholderForValue:value[i]
                                                resolving:resolvedParameters];
    }
  }

  return _value;
}

- (id)resolveParameterPlaceholderForValueTypeString:(NSString *)value
                                          resolving:(NSMutableDictionary *)resolvedParameters {
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/^\%([^\%\\s]+)\%$/"
                                                                         options:0
                                                                           error:nil];
  NSArray *matches = [regex matchesInString:value
                                    options:0
                                      range:NSMakeRange(0, value.length)];

  if (matches.count) {
    NSString *key = [matches[1] lowercaseString];
    if (resolvedParameters[key]) {
      @throw [GCDIParameterCircularReferenceException exceptionWithReferences:resolvedParameters];
    }

    resolvedParameters[key] = @TRUE;
    id keyValue = [self getParameter:key];

    if (!_resolved) {
      keyValue = [self resolveParameterPlaceholderForValue:keyValue
                                                 resolving:resolvedParameters];
    }

    return keyValue;
  }

  regex = [NSRegularExpression regularExpressionWithPattern:@"/\%\%|\%([^%\\s]+)\%/"
                                                    options:0
                                                      error:nil];

  matches = [regex matchesInString:value
                           options:0
                             range:NSMakeRange(0, value.length)];

  for (NSString *key in matches) {
    if (key.length == 0) {
      return @"%%";
    }

    if (resolvedParameters[key]) {
      @throw [GCDIParameterCircularReferenceException exceptionWithReferences:resolvedParameters];
    }

    NSString *resolved = [self getParameter:key];
    resolvedParameters[key] = @TRUE;

    if (!_resolved) {
      resolved = [self resolveParameterPlaceholderForValueTypeString:resolved resolving:resolvedParameters];
    }

    return resolved;
  }

  return value;
}

- (id)escapeParameterPlaceholdersForValue:(id)_value {
  if ([_value isKindOfClass:[NSString class]]) {
    return [_value stringByReplacingOccurrencesOfString:@"%" withString:@"%%"];
  }
  else if ([_value isKindOfClass:[NSDictionary class]]) {
    NSDictionary *value = _value;

    NSMutableDictionary *escapedValues = @{}.mutableCopy;
    for (NSString *key in value.allKeys) {
      escapedValues[key] = [self escapeParameterPlaceholdersForValue:value[key]];
    }
    return escapedValues;
  }
  else if ([_value isKindOfClass:[NSArray class]]) {
    NSArray *value = _value;

    NSMutableArray *escapedValues = @[].mutableCopy;
    for (NSUInteger i = 0; i < value.count; i++) {
      escapedValues[i] = [self escapeParameterPlaceholdersForValue:value[i]];
    }
    return escapedValues;
  }

  return _value;
}

- (id)unescapeParameterPlaceholdersForValue:(id)_value {
  if ([_value isKindOfClass:[NSString class]]) {
    return [_value stringByReplacingOccurrencesOfString:@"%%" withString:@"%"];
  }
  else if ([_value isKindOfClass:[NSDictionary class]]) {
    NSDictionary *value = _value;

    NSMutableDictionary *unescapedValues = @{}.mutableCopy;
    for (NSString *key in value.allKeys) {
      unescapedValues[key] = [self unescapeParameterPlaceholdersForValue:value[key]];
    }
    return unescapedValues;
  }
  else if ([_value isKindOfClass:[NSArray class]]) {
    NSArray *value = _value;

    NSMutableArray *unescapedValues = @[].mutableCopy;
    for (NSUInteger i = 0; i < value.count; i++) {
      unescapedValues[i] = [self unescapeParameterPlaceholdersForValue:value[i]];
    }
    return unescapedValues;
  }

  return _value;
}

@end
