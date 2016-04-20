//
// Created by Jake Wise on 28/03/2016.
//

#import "GCDIContainer.h"
#import "GCDIParameterBagProtocol.h"
#import "GCDIParameterBag.h"
#import "GCDIAlias.h"
#import "GCDIAlternativeSuggesterProtocol.h"
#import "GCDIAlternativeSuggester.h"
#import "GCDIExceptions.h"

NSString * const kGCDIServiceContainerId = @"service_container";

@implementation GCDIContainer

@synthesize parameterBag = _parameterBag,
            alternativeSuggester = _alternativeSuggester;

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _services = @{}.mutableCopy;
  _loading = @{}.mutableCopy;
  _aliases = @{}.mutableCopy;
  _alternativeSuggester = [[GCDIAlternativeSuggester alloc] init];
  _parameterBag = [[GCDIParameterBag alloc] init];

  return self;
}

- (id)initWithParameterBag:(id <GCDIParameterBagProtocol>)parameterBag {
  self = [self init];
  if (!self) {
    return nil;
  }

  _parameterBag = parameterBag;

  return self;
}

# pragma mark - Service methods

- (id)getService:(NSString *)serviceId {
  return [self getServiceNamed:serviceId
          withInvalidBehaviour:kExceptionOnInvalidReference];
}

- (id)getServiceNamed:(NSString *)serviceId
 withInvalidBehaviour:(GCDIInvalidBehaviourType)invalidBehaviourType {
  id service;

  for (NSInteger i = 2;;) {
    if ([serviceId isEqualToString:kGCDIServiceContainerId]) {
      return self;
    }

    if ([self hasAlias:serviceId]) {
      return [self getServiceNamed:[self getAlias:serviceId].aliasId
              withInvalidBehaviour:invalidBehaviourType];
    }

    if (_services[serviceId]) {
      return _services[serviceId];
    }

    if (_loading[serviceId]) {
      [NSException raise:GCDICircularReferenceException
                  format:@"Circular reference detected for service \"%@\", previously loaded: %@", serviceId, _loading.allKeys];
    }

    SEL method = [self getSelectorForServiceNamed:serviceId];
    if (_methodMap[serviceId]) {
      method = NSSelectorFromString(_methodMap[serviceId]);
    }
    else if (--i && ![serviceId isEqualToString:[serviceId lowercaseString]]) {
      serviceId = [serviceId lowercaseString];
      continue;
    }
    else if ([self respondsToSelector:method]) {
      // Selector is valid to fetch the service with.
    }
    else {
      if (invalidBehaviourType == kExceptionOnInvalidReference) {
        if (!serviceId) {
          [NSException raise:GCDIServiceNotFoundException
                      format:@"Service \"%@\" not found", serviceId];
        }

        NSArray *alternatives = [_alternativeSuggester alternativesForItem:serviceId
                                                         inPossibleOptions:[self getServiceIds]];

        [NSException raise:GCDIServiceNotFoundException
                    format:@"Service \"%@\" not found, did you mean any of the following? %@", serviceId, alternatives];
      }

      return nil;
    }

    _loading[serviceId] = @TRUE;

    @try {
      service = [self performSelector:method];
    }
    @catch (NSException *e) {
      [_services removeObjectForKey:serviceId];

      if (invalidBehaviourType != kExceptionOnInvalidReference) {
        return nil;
      }

      @throw e;
    }
    @finally {
      [_loading removeObjectForKey:serviceId];
    }

    return service;
  }
}

- (SEL)getSelectorForServiceNamed:(NSString *)serviceId {
  serviceId = [serviceId capitalizedString];
  serviceId = [serviceId stringByReplacingOccurrencesOfString:@"_" withString:@""];
  serviceId = [serviceId stringByReplacingOccurrencesOfString:@"." withString:@"_"];
  return NSSelectorFromString([NSString stringWithFormat:@"get%@Service", serviceId]);
}

- (NSArray *)getServiceIds {
  NSMutableArray *serviceIds = _services.allKeys.mutableCopy;
  serviceIds[serviceIds.count] = kGCDIServiceContainerId;
  return serviceIds;
}

- (void)setService:(NSString *)serviceId instance:(id)service {
  serviceId = [serviceId lowercaseString];

  if ([serviceId isEqualToString:kGCDIServiceContainerId]) {
    [NSException raise:NSInvalidArgumentException
                format:@"You cannot set service \"service_container\"."];
  }

  if (_aliases[serviceId]) {
    [_aliases removeObjectForKey:serviceId];
  }

  if (service != nil) {
    _services[serviceId] = service;
  }
}

- (BOOL)hasService:(NSString *)serviceId {
  return _aliases[serviceId] || _services[serviceId];
}

- (BOOL)isServiceInitialised:(NSString*)serviceId {
  return (bool) _services[[serviceId lowercaseString]];
}

- (void)reset {
  [_services removeAllObjects];
}

# pragma mark - Parameter methods

- (id)getParameter:(NSString*)name {
  return [_parameterBag getParameter:name];
}

- (BOOL)hasParameter:(NSString*)name {
  return [_parameterBag hasParameter:name];
}

- (void)setParameter:(NSString*)name value:(id)value {
  [_parameterBag setParameter:name value:value];
}

# pragma mark - Alias methods

- (void)addAliases:(NSDictionary *)aliases {
  for (NSString *alias in aliases) {
    [self setAlias:alias to:aliases[alias]];
  }
}

- (void)setAliases:(NSDictionary *)aliases {
  _aliases = @{}.mutableCopy;
  [self addAliases:aliases];
}

- (void)setAlias:(NSString *)alias to:(id)serviceId {
  if ([serviceId isKindOfClass:[NSString class]]) {
    serviceId = [GCDIAlias aliasForId:serviceId];
  }
  else if (![serviceId isKindOfClass:[GCDIAlias class]]) {
    [NSException raise:NSInvalidArgumentException
                format:@"Service id must be of type NSString or GCDIAlias."];
  }

  _aliases[[alias lowercaseString]] = serviceId;
}

- (void)removeAlias:(NSString *)alias {
  [_aliases removeObjectForKey:[alias lowercaseString]];
}

- (BOOL)hasAlias:(NSString *)alias {
  return (BOOL) _aliases[[alias lowercaseString]];
}

- (NSDictionary *)getAliases {
  return _aliases.copy;
}

- (GCDIAlias *)getAlias:(NSString *)alias {
  alias = [alias lowercaseString];
  if (!_aliases[alias]) {
    [NSException raise:NSInvalidArgumentException
                format:@"The service alias \"%@\" does not exist.", alias];
  }

  return _aliases[alias];
}

@end
