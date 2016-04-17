//
// Created by Jake Wise on 28/03/2016.
//

#import "GCDIContainer.h"
#import "GCDIParameterBagProtocol.h"
#import "GCDIParameterBag.h"
#import "GCDIServiceCircularReferenceException.h"
#import "GCDIServiceNotFoundException.h"
#import "GCDIAlias.h"
#import "GCDIAlternativeSuggesterProtocol.h"
#import "GCDIAlternativeSuggester.h"

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

- (id)getServiceNamed:(NSString *)serviceId {
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

    if (_aliases[serviceId]) {
      return [self getServiceNamed:_aliases[serviceId]
              withInvalidBehaviour:invalidBehaviourType];
    }

    if (_services[serviceId]) {
      return _services[serviceId];
    }

    if (_loading[serviceId]) {
      @throw [GCDIServiceCircularReferenceException exceptionForServiceNamed:serviceId
                                                                    previous:_loading.allKeys];
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
          @throw [GCDIServiceNotFoundException exceptionForServiceNamed:serviceId];
        }

        NSArray *alternatives = [_alternativeSuggester alternativesForItem:serviceId
                                                         inPossibleOptions:[self getServiceIds]];

        @throw [GCDIServiceNotFoundException exceptionForServiceNamed:serviceId
                                                     withAlternatives:alternatives];
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
  serviceId = [serviceId stringByReplacingOccurrencesOfString:@"_" withString:@""];
  serviceId = [serviceId stringByReplacingOccurrencesOfString:@"." withString:@"_"];
  return NSSelectorFromString([NSString stringWithFormat:@"get%@Service", serviceId]);
}

- (NSArray *)getServiceIds {
  NSMutableArray *serviceIds = _services.allKeys.mutableCopy;
  serviceIds[serviceIds.count] = kGCDIServiceContainerId;
  return serviceIds;
}

- (void)setServiceNamed:(NSString *)serviceId instance:(id)service {
  serviceId = [serviceId lowercaseString];

  if ([serviceId isEqualToString:kGCDIServiceContainerId]) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:@"You cannot set service \"service_container\"."
                                 userInfo:nil];
  }

  if (_aliases[serviceId]) {
    [_aliases removeObjectForKey:serviceId];
  }

  if (service != nil) {
    _services[serviceId] = service;
  }
}

- (BOOL)hasServiceNamed:(NSString *)serviceId {
  return _aliases[serviceId] || _services[serviceId];
}

- (BOOL)isServiceInitialisedNamed:(NSString*)serviceId {
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
    [self setAliasNamed:alias toAlias:aliases[alias]];
  }
}

- (void)setAliases:(NSDictionary *)aliases {
  _aliases = @{}.mutableCopy;
  [self addAliases:aliases];
}

- (void)setAliasNamed:(NSString *)alias toAlias:(id)serviceId {
  if ([serviceId isKindOfClass:[NSString class]]) {
    serviceId = [GCDIAlias aliasForId:serviceId];
  }
  else if (![serviceId isKindOfClass:[GCDIAlias class]]) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:@"Service id must be of type NSString or GCDIAlias."
                                 userInfo:nil];
  }

  _aliases[[alias lowercaseString]] = serviceId;
}

- (void)removeAliasNamed:(NSString *)alias {
  [_aliases removeObjectForKey:[alias lowercaseString]];
}

- (BOOL)hasAliasNamed:(NSString *)alias {
  return (BOOL) _aliases[[alias lowercaseString]];
}

- (NSDictionary *)getAliases {
  return _aliases.copy;
}

- (GCDIAlias *)getAliasNamed:(NSString *)alias {
  alias = [alias lowercaseString];
  if (!_aliases[alias]) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:[NSString stringWithFormat:
                                     @"The service alias \"%@\" does not exist.",
                                     alias]
                                 userInfo:nil];
  }

  return _aliases[alias];
}

@end
