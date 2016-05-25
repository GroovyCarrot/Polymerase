//
// GCDependencyInjection
//
// Created by Jake Wise on 23/05/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>
#import "GCDIDefinitionContainer.h"

@interface GCDIDefinitionContainer (Swift)
- (Class)swiftClassFromString:(NSString *)className;
- (SEL)swiftSelectorFromString:(NSString *)selName;
@end