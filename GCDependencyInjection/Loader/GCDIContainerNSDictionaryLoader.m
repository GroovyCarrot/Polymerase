//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIContainerNSDictionaryLoader.h"
#import "GCDIDefinitionContainerProtocol.h"
#import "GCDIAliasableContainerProtocol.h"
#import "GCDIDefinition.h"
#import "GCDIReference.h"

@implementation GCDIContainerNSDictionaryLoader {
  NSDictionary *_dictionary;
  NSDictionary *_serviceDefinitions;
}

@synthesize dictionary = _dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [super init];
  if (self == nil) {
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
    [container setParameter:key value:[self resolveServices:parameters[key]]];
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
      [(NSObject<GCDIAliasableContainerProtocol> *) container setAliasNamed:[definition substringFromIndex:1]
                                                                    toAlias:serviceId];
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

  if (definitionDictionary[@"Selector"]) {
    [serviceDefinition setSelector:NSSelectorFromString(definitionDictionary[@"Selector"])];
  }

  if (definitionDictionary[@"Arguments"]) {
    [serviceDefinition setArguments:[self resolveServices:definitionDictionary[@"Arguments"]]];
  }

  if (definitionDictionary[@"Properties"]) {
    [serviceDefinition setProperties:definitionDictionary[@"Properties"]];
  }

  if (definitionDictionary[@"MethodInvocations"]) {
    for (id methodInvocation in definitionDictionary[@"MethodInvocations"]) {
      if ([methodInvocation isKindOfClass:[NSInvocation class]]) {
        [serviceDefinition addMethodInvocation:methodInvocation];
      }
      else if ([methodInvocation isKindOfClass:[NSDictionary class]]) {
        if (methodInvocation[@"Selector"] && methodInvocation[@"Arguments"]) {
          [serviceDefinition addMethodCall:NSSelectorFromString(methodInvocation[@"Selector"])
                             withArguments:[self resolveServices:methodInvocation[@"Arguments"]]];
        }
        else {
          [NSException raise:NSInvalidArgumentException
                      format:@"Expected \"Selector\" and \"Arguments\" keys for MethodInvocations definition: %@", methodInvocation];
        }
      }
    }
  }

  [container setDefinition:serviceDefinition forServiceNamed:serviceId];
}

- (id)resolveServices:(id)_services {
  if ([_services isKindOfClass:[NSArray class]]) {
    NSArray *services = _services;

    NSMutableArray *resolvedServices = @[].mutableCopy;
    for (id service in services) {
      resolvedServices[resolvedServices.count] = [self resolveServices:service];
    }
    return resolvedServices;
  }
  else if ([_services isKindOfClass:[NSString class]] && [_services rangeOfString:@"@"].location == 0) {
    NSString *service = _services;
    GCDIInvalidBehaviourType invalidBehaviourType = NULL;

    if ([service rangeOfString:@"@@"].location == 0) {
      service = [service substringFromIndex:1];
    }
    else if ([service rangeOfString:@"@?"].location == 0) {
      service = [service substringFromIndex:2];
      invalidBehaviourType = kNilOnInvalidReference;
    }
    else {
      service = [service substringFromIndex:1];
      invalidBehaviourType = kExceptionOnInvalidReference;
    }

    if (invalidBehaviourType != NULL) {
      return [GCDIReference referenceForServiceNamed:service
                                invalidBehaviourType:invalidBehaviourType];
    }

    return service;
  }

  return _services;
}

@end
