//
// Created by Jake Wise on 28/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDIParameterBagProtocol.h"

@interface GCDIParameterBag : NSObject <GCDIParameterBagProtocol>
@property(nonatomic, readonly, getter=isResolved) BOOL resolved;
- (id)init;
- (id)initWithParameters:(NSDictionary *)parameters;
@end
