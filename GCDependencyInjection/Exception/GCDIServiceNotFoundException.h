//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDIServiceNotFoundException : NSException
@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic, copy) NSArray *alternatives;
+ (GCDIServiceNotFoundException *)exceptionForServiceNamed:(NSString *)serviceId;
+ (GCDIServiceNotFoundException *)exceptionForServiceNamed:(NSString *)serviceId withAlternatives:(NSArray *)alternatives;
- (GCDIServiceNotFoundException *)initForServiceNamed:(NSString *)serviceId;
- (GCDIServiceNotFoundException *)initForServiceNamed:(NSString *)serviceId withAlternatives:(NSArray *)alternatives;
@end
