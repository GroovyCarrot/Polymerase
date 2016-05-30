//
// GCDependencyInjection
//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>

@class GCDIInterpreter;
@protocol GCDIDefinitionContainerProtocol;

@interface GCDIContainerNSDictionaryLoader : NSObject
@property (nonatomic, copy) NSDictionary *dictionary;
@property (nonatomic, copy, getter=getInterpreter) GCDIInterpreter *interpreter;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)loadIntoContainer:(id<GCDIDefinitionContainerProtocol>)container;
@end
