//
// GCDependencyInjection
//
// Created by Jake Wise on 18/09/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (GCDependencyInjection)
+ (NSValue *)valueWithCString:(const char *)value;
+ (NSValue *)valueWithInt:(int)value;
+ (NSValue *)valueWithUnsignedInt:(unsigned int)value;
+ (NSValue *)valueWithInteger:(NSInteger)value;
+ (NSValue *)valueWithUnsignedInteger:(NSUInteger)value;
+ (NSValue *)valueWithLong:(long)value;
+ (NSValue *)valueWithUnsignedLong:(unsigned long)value;
+ (NSValue *)valueWithLongLong:(long long)value;
+ (NSValue *)valueWithUnsignedLongLong:(unsigned long long)value;
+ (NSValue *)valueWithFloat:(float)value;
+ (NSValue *)valueWithDouble:(double)value;
+ (NSValue *)valueWithBOOL:(BOOL)value;
+ (NSValue *)valueWithBool:(bool)value;
@end
