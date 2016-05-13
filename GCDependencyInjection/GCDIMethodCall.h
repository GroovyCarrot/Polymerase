//
// GCDependencyInjection
//
// Created by Jake Wise on 13/05/2016.
// Copyright (c) 2016 Jake Wise. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>

@interface GCDIMethodCall : NSObject
@property (nonatomic, getter=getSelector, setter=setSelector:) SEL pSelector;
@property (nonatomic, copy) NSArray *arguments;
+ (GCDIMethodCall *)methodCallForSelector:(SEL)pSelector andArguments:(NSArray *)arguments;
- (GCDIMethodCall *)initWithSelector:(SEL)pSelector andArguments:(NSArray *)arguments;
- (BOOL)isEqualToMethodCall:(GCDIMethodCall *)methodCall;
@end
