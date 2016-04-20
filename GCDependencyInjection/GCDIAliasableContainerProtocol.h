//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIContainerProtocol.h"

@class GCDIAlias;

@protocol GCDIAliasableContainerProtocol <GCDIContainerProtocol>
- (void)addAliases:(NSDictionary *)aliases;
- (void)setAliases:(NSDictionary *)aliases;
- (void)setAlias:(NSString *)alias to:(id)serviceId;
- (void)removeAlias:(NSString *)alias;
- (BOOL)hasAlias:(NSString *)alias;
- (GCDIAlias *)getAlias:(NSString *)alias;
@end
