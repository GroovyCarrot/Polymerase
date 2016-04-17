//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIContainerProtocol.h"

@class GCDIAlias;

@protocol GCDIAliasableContainerProtocol <GCDIContainerProtocol>
- (void)addAliases:(NSDictionary *)aliases;
- (void)setAliases:(NSDictionary *)aliases;
- (void)setAliasNamed:(NSString *)alias toAlias:(id)serviceId;
- (void)removeAliasNamed:(NSString *)alias;
- (BOOL)hasAliasNamed:(NSString *)alias;
- (GCDIAlias *)getAliasNamed:(NSString *)alias;
@end
