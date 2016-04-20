//
// GCDependencyInjection
//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>

typedef enum {
  kExceptionOnInvalidReference = 1,
  kNilOnInvalidReference
} GCDIInvalidBehaviourType;

@protocol GCDIContainerProtocol
- (id)getService:(NSString *)serviceId;
- (id)getServiceNamed:(NSString *)serviceId withInvalidBehaviour:(GCDIInvalidBehaviourType)invalidBehaviourType;
- (void)setService:(NSString *)serviceId instance:(id)service;
- (BOOL)hasService:(NSString *)serviceId;
- (BOOL)isServiceInitialised:(NSString*)serviceId;
- (id)getParameter:(NSString*)name;
- (BOOL)hasParameter:(NSString*)name;
- (void)setParameter:(NSString*)name value:(id)value;
@end
