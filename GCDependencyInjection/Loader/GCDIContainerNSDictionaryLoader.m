//
// GCDependencyInjection
//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIContainerNSDictionaryLoader.h"
#import "GCDIDefinitionContainerProtocol.h"
#import "GCDIAliasableContainerProtocol.h"
#import "GCDIDefinition.h"
#import "GCDIMethodCall.h"
#import "GCDINSStringReferenceConverter.h"

@implementation GCDIContainerNSDictionaryLoader {
  NSDictionary *_dictionary;
  NSDictionary *_serviceDefinitions;
}

@synthesize dictionary = _dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [super init];
  if (!self) {
    return nil;
  }

  _dictionary = dictionary.copy;

  return self;
}

- (void)loadIntoContainer:(NSObject<GCDIDefinitionContainerProtocol> *)container {
  if (![[(NSObject *) container class] conformsToProtocol:@protocol(GCDIDefinitionContainerProtocol)]) {
    [NSException raise:NSInvalidArgumentException
                format:@"Container must conform to protocol GCDIContainerProtocol."];
  }

  [self parseParametersIntoContainer:container];
  [self parseServiceDefinitionsIntoContainer:container];
}

- (void)parseParametersIntoContainer:(NSObject<GCDIContainerProtocol> *)container {
  if (!_dictionary[@"Parameters"]) {
    return;
  }
  else if (![_dictionary[@"Parameters"] isKindOfClass:[NSDictionary class]]) {
    [NSException raise:NSInvalidArgumentException
                format:@"The \"Parameters\" key should contain a dictionary."];
  }

  NSDictionary *parameters = _dictionary[@"Parameters"];
  for (NSString *key in parameters.allKeys) {
    [container setParameter:key value:[self.referenceConverter resolveReferencesToServices:parameters[key]]];
  }
}

- (void)parseServiceDefinitionsIntoContainer:(NSObject<GCDIDefinitionContainerProtocol> *)container {
  if (!_dictionary[@"Services"]) {
    return;
  }
  else if (![_dictionary[@"Services"] isKindOfClass:[NSDictionary class]]) {
    [NSException raise:NSInvalidArgumentException
                format:@"The \"Services\" key should contain a dictionary."];
  }

  NSDictionary *services = _dictionary[@"Services"];
  for (NSString *serviceId in services.allKeys) {
    [self parseDefinition:services[serviceId]
             forServiceId:serviceId
            intoContainer:container];
  }
}

- (void)parseDefinition:(id)definition
                       forServiceId:(NSString *)serviceId
                      intoContainer:(NSObject<GCDIDefinitionContainerProtocol> *)container {

  if ([definition isKindOfClass:[NSString class]]) {
    if (![[definition substringToIndex:1] isEqualToString:@"@"]) {
      [NSException raise:NSInvalidArgumentException
                  format:@"A service definition identifier string must start with \"@\". Instead received: \"%@\".", serviceId];
    }

    // Attempt to load alias into container if it supports them.
    if ([[container class] conformsToProtocol:@protocol(GCDIAliasableContainerProtocol)]) {
      [(NSObject <GCDIAliasableContainerProtocol> *) container setAlias:[definition substringFromIndex:1]
                                                                     to:serviceId];
    }

    return;
  }
  else if (![definition isKindOfClass:[NSDictionary class]]) {
    [NSException raise:NSInvalidArgumentException
                format:@"A service definition must be a string identifier (\"@service_id\") or a dictionary definition."];
  }

  NSDictionary *definitionDictionary = definition;
  GCDIDefinition *serviceDefinition = [[GCDIDefinition alloc] init];

  if (definitionDictionary[@"Class"]) {
    [serviceDefinition setKlass:definitionDictionary[@"Class"]];
  }

  if (definitionDictionary[@"Factory"]) {
    [serviceDefinition setFactory:[self.referenceConverter resolveReferencesToServices:definitionDictionary[@"Factory"]]];
  }

  if (definitionDictionary[@"Selector"]) {
    [serviceDefinition setSelector:definitionDictionary[@"Selector"]];
  }
  else if(definitionDictionary[@"Factory"]) {
    [NSException raise:NSParseErrorException
                format:@"A selector must be specified with using a factory service (parsing \"%@\").", serviceId];
  }

  if (definitionDictionary[@"Arguments"]) {
    [serviceDefinition setArguments:[self.referenceConverter resolveReferencesToServices:definitionDictionary[@"Arguments"]]];
  }

  if (definitionDictionary[@"Setters"]) {
    [serviceDefinition setSetters:[self.referenceConverter resolveReferencesToServices:definitionDictionary[@"Setters"]]];
  }

  if (definitionDictionary[@"MethodCalls"]) {
    for (id methodCall in definitionDictionary[@"MethodCalls"]) {
      if ([methodCall isKindOfClass:[GCDIMethodCall class]]) {
        [serviceDefinition addMethodCall:methodCall];
      }
      else if ([methodCall isKindOfClass:[NSDictionary class]]) {
        if (methodCall[@"Selector"] && methodCall[@"Arguments"]) {
          GCDIMethodCall *method = [GCDIMethodCall methodCallForSelector:NSSelectorFromString(methodCall[@"Selector"])
                                                            andArguments:[self.referenceConverter resolveReferencesToServices:methodCall[@"Arguments"]]];
          [serviceDefinition addMethodCall:method];
        }
        else {
          [NSException raise:NSInvalidArgumentException
                      format:@"Expected \"Selector\" and \"Arguments\" keys for MethodCalls definition: %@", methodCall];
        }
      }
    }
  }

  if (definitionDictionary[@"Tags"]) {
    [serviceDefinition setTags:definitionDictionary[@"Tags"]];
  }

  [container setDefinition:serviceDefinition forService:serviceId];
}

- (GCDINSStringReferenceConverter *)getReferenceConverter {
  if (!_referenceConverter) {
    _referenceConverter = [[GCDINSStringReferenceConverter alloc] init];
  }
  return _referenceConverter;
}

@end
