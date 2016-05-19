//
// GCDependencyInjection
//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIContainerProtocol.h"

@class GCDIDefinition;

@protocol GCDIDefinitionContainerProtocol <GCDIContainerProtocol>
- (void)setService:(NSString *)serviceId definition:(id)definition;
- (void)addDefinitions:(NSDictionary *)definitions;
- (void)setDefinitions:(NSDictionary *)definitions;
- (NSDictionary *)getDefinitions;
- (BOOL)hasDefinitionForService:(NSString *)serviceId;
- (GCDIDefinition *)getDefinitionForService:(NSString *)serviceId;
- (NSDictionary *)findServiceIdsForTag:(NSString *)name;
@end
