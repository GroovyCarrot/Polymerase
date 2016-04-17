//
// Created by Jake Wise on 28/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GCDIParameterBagProtocol <NSObject>
- (void)clearParameters;
- (void)addParameters:(NSDictionary *)parameters;
- (NSDictionary *)allParameters;
- (id)getParameter:(NSString *)name;
- (void)removeParameter:(NSString *)name;
- (void)setParameter:(NSString *)name value:(id)value;
- (BOOL)hasParameter:(NSString *)name;
- (void)resolveParameterPlaceholders;
- (id)resolveParameterPlaceholderForValue:(id)value;
- (id)escapeParameterPlaceholdersForValue:(id)_value;
- (id)unescapeParameterPlaceholdersForValue:(id)value;
@end
