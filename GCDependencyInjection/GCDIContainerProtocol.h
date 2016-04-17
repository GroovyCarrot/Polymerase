//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  kExceptionOnInvalidReference = 1,
  kNilOnInvalidReference
} GCDIInvalidBehaviourType;

@protocol GCDIContainerProtocol
- (id)getServiceNamed:(NSString *)serviceId;
- (id)getServiceNamed:(NSString *)serviceId withInvalidBehaviour:(GCDIInvalidBehaviourType)invalidBehaviourType;
- (void)setServiceNamed:(NSString *)serviceId instance:(id)service;
- (BOOL)hasServiceNamed:(NSString *)serviceId;
- (BOOL)isServiceInitialisedNamed:(NSString*)serviceId;
- (id)getParameter:(NSString*)name;
- (BOOL)hasParameter:(NSString*)name;
- (void)setParameter:(NSString*)name value:(id)value;
@end
