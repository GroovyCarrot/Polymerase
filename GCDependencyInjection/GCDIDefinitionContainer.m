//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 Jake Wise. All rights reserved.
//

#import "GCDIDefinitionContainer.h"
#import "GCDIDefinition.h"
#import "GCDIParameterBagProtocol.h"
#import "GCDIReference.h"
#import "GCDIExceptions.h"

@implementation GCDIDefinitionContainer {
 @protected
  NSMutableDictionary *_obsoleteDefinitions;
}

# pragma mark - Service methods

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _definitions = @{}.mutableCopy;
  _obsoleteDefinitions = @{}.mutableCopy;

  return self;
}

- (id)getServiceNamed:(NSString *)serviceId
 withInvalidBehaviour:(GCDIInvalidBehaviourType)invalidBehaviourType {
  serviceId = [serviceId lowercaseString];

  id service = [super getServiceNamed:serviceId
                 withInvalidBehaviour:kNilOnInvalidReference];
  if (service) {
    return service;
  }

  // Attempt to load the service.
  GCDIDefinition *definition;

  @try {
    definition = [self getDefinitionForService:serviceId];
  }
  @catch (NSException *e) {
    if (invalidBehaviourType != kExceptionOnInvalidReference) {
      return nil;
    }
    @throw e;
  }

  _loading[serviceId] = @TRUE;

  @try {
    service = [self createServiceNamed:serviceId fromDefinition:definition];
  }
  @catch (NSException *e) {
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

- (id)createServiceNamed:(NSString *)serviceId
          fromDefinition:(GCDIDefinition *)definition {
  if ([definition isSynthetic]) {
    [NSException raise:GCDIRequestedSyntheticService
                format:@"Cannot construct synthetic service \"%@\"", serviceId];
  }

  if ([definition isDepreciated]) {
    NSLog(@"[GCDIContainer %p] %@", self, [definition getDepreciationMessage]);
  }

  id service;

  // Get the service either from the factory, or by initialising a new instance
  // of the service class.
  NSInvocation *invocation;
  if (definition.factory) {
    id factory = [self resolveServices:definition.factory];
    invocation = [self buildInvocationForClass:[factory class]
                                  withSelector:definition.pSelector
                                  andArguments:definition.arguments];

    // Invoke the required method on the factory object.
    [invocation setTarget:factory];

    void *tempService;
    [invocation getReturnValue:&tempService];
    service = (__bridge id)tempService;
  }
  else {
    // Invoke the required initialisation on the service.
    Class klass = NSClassFromString([_parameterBag resolveParameterPlaceholders:definition.klass]);
    if (klass == nil) {
      [NSException raise:GCDIServiceNotFoundException
                  format:@"Service with Class \"%@\" not found. %@", klass, definition];
    }

    invocation = [self buildInvocationForClass:klass
                                  withSelector:definition.pSelector
                                  andArguments:definition.arguments];

    service = [klass alloc];
    [invocation setTarget:service];
  }

  // Invoke the method to get the service object.
  [invocation invoke];

  for (NSInvocation *setupInvocation in definition.methodInvocations) {
    [setupInvocation invokeWithTarget:service];
  }

  // Configure properties on the service using setters and values.
  for (NSString *setter in definition.properties) {
    NSMethodSignature *setterSignature = [[service class] methodSignatureForSelector:NSSelectorFromString(setter)];
    if (setterSignature == nil) {
      [NSException raise:NSInvalidArgumentException
                  format:@"Could not apply setter \"%@\" to service \"%@\"", setter, serviceId];
    }

    id argument = definition.properties[setter];
    invocation = [NSInvocation invocationWithMethodSignature:setterSignature];
    [invocation setArgument:&argument atIndex:2];
    [invocation invokeWithTarget:service];
  }

  // Invoke the configurator and pass the service as the argument.
  // @todo support configurator arguments.
  if (definition.configurator) {
    invocation = [self buildInvocationForClass:[definition.configurator class]
                                  withSelector:definition.configuratorSelector
                                  andArguments:@[service]];
    [invocation setArgument:&service atIndex:2];
    [invocation invoke];
  }

  return service;
}

- (NSInvocation *)buildInvocationForClass:(Class)klass withSelector:(SEL)pSelector andArguments:(NSArray *)arguments {
  NSMethodSignature *methodSignature = [klass instanceMethodSignatureForSelector:pSelector];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  [invocation setSelector:pSelector];
  [self addArguments:arguments toInvocation:invocation];
  return invocation;
}

- (void)addArguments:(NSArray *)arguments toInvocation:(NSInvocation *)invocation {
  arguments = [_parameterBag resolveParameterPlaceholders:arguments];
  arguments = [_parameterBag unescapeParameterPlaceholders:arguments];
  arguments = [self resolveServices:arguments];

  NSInteger i = 2;
  for (id argument in arguments) {
    [invocation setArgument:&argument atIndex:i];
  }
}

- (id)resolveServices:(id)_resolveServices {
  if ([_resolveServices isKindOfClass:[NSArray class]]) {
    NSArray *resolveServices = _resolveServices;
    NSMutableArray *resolvedServices = @[].mutableCopy;

    for (NSUInteger i = 0; i < resolveServices.count; i++) {
      resolvedServices[i] = [self resolveServices:resolveServices[i]];
    }

    return resolvedServices.copy;
  }
  else if ([_resolveServices isKindOfClass:[GCDIReference class]]) {
    GCDIReference *reference = _resolveServices;
    return [self getServiceNamed:reference.serviceId
            withInvalidBehaviour:reference.invalidBehaviourType];
  }
  else if ([_resolveServices isKindOfClass:[GCDIDefinition class]]) {
    GCDIDefinition *definition = _resolveServices;
    return [self createServiceNamed:nil fromDefinition:definition];
  }

  return _resolveServices;
}

- (void)setService:(NSString *)serviceId instance:(id)service {
  if (_definitions[serviceId]) {
    _obsoleteDefinitions[serviceId] = _definitions[serviceId];
  }

  [super setService:serviceId instance:service];
}

# pragma mark - Definition methods

- (void)addDefinitions:(NSDictionary *)definitions {
  for (NSString *serviceId in definitions) {
    [self setDefinition:definitions[serviceId] forService:serviceId];
  }
}

- (void)setDefinitions:(NSDictionary *)definitions {
  _definitions = @{}.mutableCopy;
  [self addDefinitions:definitions];
}

- (NSDictionary *)getDefinitions {
  return _definitions.copy;
}

- (void)setDefinition:(GCDIDefinition *)definition forService:(NSString *)serviceId {
  if (![definition isKindOfClass:[GCDIDefinition class]]) {
    [NSException raise:NSInvalidArgumentException
                format:@"Definition must be an instance of GCDIDefinition."];
  }

  serviceId = [serviceId lowercaseString];
  [_aliases removeObjectForKey:serviceId];
  _definitions[serviceId] = definition;
}

- (id)getDefinitionForService:(NSString *)serviceId {
  serviceId = [serviceId lowercaseString];
  if (!_definitions[serviceId]) {
    [NSException raise:GCDIServiceNotFoundException
                format:@"Service \"%@\" not found", serviceId];
  }

  return _definitions[serviceId];
}

- (BOOL)hasDefinitionForService:(NSString *)serviceId {
  return (BOOL) _definitions[serviceId];
}

@end