//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIContainerProtocol.h"

@class GCDIDefinition;

@protocol GCDIDefinitionContainerProtocol <GCDIContainerProtocol>
- (void)setDefinition:(GCDIDefinition *)definition forServiceNamed:(NSString *)serviceId;
- (void)addDefinitions:(NSDictionary *)definitions;
- (void)setDefinitions:(NSDictionary *)definitions;
- (NSDictionary *)getDefinitions;
- (BOOL)hasDefinitionForServiceNamed:(NSString *)serviceId;
- (GCDIDefinition *)getDefinitionForServiceNamed:(NSString *)serviceId;
@end
