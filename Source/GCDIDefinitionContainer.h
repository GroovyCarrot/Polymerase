//
// GCDependencyInjection
//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>
#import "GCDIContainer.h"
#import "GCDIDefinitionContainerProtocol.h"

@interface GCDIDefinitionContainer : GCDIContainer<GCDIDefinitionContainerProtocol> {
 @protected
  NSMutableDictionary *_definitions;
  NSMutableDictionary *_aliasDefinitions;
}
@property (nonatomic, copy, readonly) NSString *identifier;
- (void)registerService:(NSString *)serviceId forClass:(Class)klass andSelector:(SEL)pSelector;
- (void)setContainerInjectsIntoStoryboards:(BOOL)injects;
- (id)objectForKeyedSubscript:(id)key;
@end
