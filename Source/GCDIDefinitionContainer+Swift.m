//
// GCDependencyInjection
//
// Created by Jake Wise on 23/05/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIDefinitionContainer+Swift.h"

@implementation GCDIDefinitionContainer (Swift)

- (Class)swiftClassFromString:(NSString *)className {
  NSString *bundleName;

  if ([className rangeOfString:@"."].location != NSNotFound) {
    // Class is already a swift class.
    NSArray *components = [className componentsSeparatedByString:@"."];
    bundleName = components[0];
    className = components[1];
  }
  else {
    bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
  }

  // Assume the swift class is part of the application.
  return NSClassFromString([GCDIDefinitionContainer getSwiftClass:className
                                                        forBundle:bundleName]);
}

+ (NSString *)getSwiftClass:(NSString *)className forBundle:(NSString *)application {
  return [NSString stringWithFormat:@"_TtC%tu%@%tu%@", application.length, application, className.length, className];
}

@end