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
#import "GCDIParameterBagProtocol.h"

@interface GCDIParameterBag : NSObject <GCDIParameterBagProtocol>
@property(nonatomic, readonly, getter=isResolved) BOOL resolved;
- (id)init;
- (id)initWithParameters:(NSDictionary *)parameters;
@end
