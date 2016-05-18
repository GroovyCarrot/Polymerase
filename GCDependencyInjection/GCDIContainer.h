//
// GCDependencyInjection
//
// Created by Jake Wise on 28/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIContainerProtocol.h"
#import "GCDIAliasableContainerProtocol.h"
#import "GCDIResettableContainerProtocol.h"

@protocol GCDIParameterBagProtocol,
          GCDIAlternativeSuggesterProtocol;

@interface GCDIContainer : NSObject <GCDIContainerProtocol, GCDIAliasableContainerProtocol, GCDIResettableContainerProtocol> {
 @protected
  NSMutableDictionary *_services;
  NSMutableDictionary *_loading;
  NSMutableDictionary *_aliases;
  NSMutableDictionary *_methodMap;

  id <GCDIParameterBagProtocol> _parameterBag;
  id <GCDIAlternativeSuggesterProtocol> _alternativeSuggester;
}

@property(nonatomic, strong, readonly, getter=getParameterBag) id <GCDIParameterBagProtocol> parameterBag;
@property(nonatomic, strong) id <GCDIAlternativeSuggesterProtocol> alternativeSuggester;

- (id)init;
- (id)initWithParameterBag:(id <GCDIParameterBagProtocol>)parameterBag;
- (NSArray *)getServiceIds;
@end
