//
// GCDependencyInjection
//
// Created by Jake Wise on 18/09/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSValue (GCDependencyInjection)

+ (NSValue *)valueWithCString:(const char *)value {
  return [NSValue valueWithBytes:&value objCType:@encode(const char *)];
}

+ (NSValue *)valueWithInt:(int)value {
  return [NSValue valueWithBytes:&value objCType:@encode(int)];
}

+ (NSValue *)valueWithUnsignedInt:(unsigned int)value {
  return [NSValue valueWithBytes:&value objCType:@encode(unsigned int)];
}

+ (NSValue *)valueWithInteger:(NSInteger)value {
  return [NSValue valueWithBytes:&value objCType:@encode(NSInteger)];
}

+ (NSValue *)valueWithUnsignedInteger:(NSUInteger)value {
  return [NSValue valueWithBytes:&value objCType:@encode(NSUInteger)];
}

+ (NSValue *)valueWithLong:(long)value {
  return [NSValue valueWithBytes:&value objCType:@encode(long)];
}

+ (NSValue *)valueWithUnsignedLong:(unsigned long)value {
  return [NSValue valueWithBytes:&value objCType:@encode(unsigned long)];
}

+ (NSValue *)valueWithLongLong:(long long)value {
  return [NSValue valueWithBytes:&value objCType:@encode(long long)];
}

+ (NSValue *)valueWithUnsignedLongLong:(unsigned long long)value {
  return [NSValue valueWithBytes:&value objCType:@encode(unsigned long long)];
}

+ (NSValue *)valueWithFloat:(float)value {
  return [NSValue valueWithBytes:&value objCType:@encode(float)];
}

+ (NSValue *)valueWithDouble:(double)value {
  return [NSValue valueWithBytes:&value objCType:@encode(double)];
}

+ (NSValue *)valueWithBOOL:(BOOL)value {
  return [NSValue valueWithBytes:&value objCType:@encode(BOOL)];
}

+ (NSValue *)valueWithBool:(bool)value {
  return [NSValue valueWithBytes:&value objCType:@encode(bool)];
}

@end
