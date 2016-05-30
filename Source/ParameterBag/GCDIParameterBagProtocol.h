//
// GCDependencyInjection
//
// Created by Jake Wise on 28/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>

@protocol GCDIParameterBagProtocol<NSObject>
- (void)clearParameters;
- (void)addParameters:(NSDictionary *)parameters;
- (NSDictionary *)allParameters;
- (id)getParameter:(NSString *)name;
- (void)removeParameter:(NSString *)name;
- (void)setParameter:(NSString *)name value:(id)value;
- (BOOL)hasParameter:(NSString *)name;
- (void)resolveAllParameters;
- (id)resolveParameterPlaceholders:(id)value;
- (id)escapeParameterPlaceholders:(id)_value;
- (id)unescapeParameterPlaceholders:(id)value;
@end
