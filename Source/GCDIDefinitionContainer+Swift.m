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
  return NSClassFromString([[self class] getSwiftClass:className
                                             forBundle:bundleName]);
}

+ (NSString *)getSwiftClass:(NSString *)className forBundle:(NSString *)application {
  return [NSString stringWithFormat:@"_TtC%tu%@%tu%@", application.length, application, className.length, className];
}

- (SEL)swiftSelectorFromString:(NSString *)selName {
  NSRegularExpression *regex;
  NSArray *matches;

  // Handle init selectors.
  regex = [NSRegularExpression regularExpressionWithPattern:@"init\\(([a-zA-Z])([a-zA-Z:]+)\\)"
                                                    options:0
                                                      error:nil];
  matches = [regex matchesInString:selName options:0 range:NSMakeRange(0, selName.length)];
  for (NSTextCheckingResult *result in matches) {
    NSString *firstLetter = [selName substringWithRange:[result rangeAtIndex:1]];
    NSString *theRest = [selName substringWithRange:[result rangeAtIndex:2]];
    selName = [NSString stringWithFormat:@"initWith%@%@", firstLetter.uppercaseString, theRest];
  }

  // Handle regular func selectors.
  regex = [NSRegularExpression regularExpressionWithPattern:@"\\(_:([a-zA-Z:]+)?\\)"
                                                    options:0
                                                      error:nil];
  selName = [regex stringByReplacingMatchesInString:selName
                                            options:0
                                              range:NSMakeRange(0, selName.length)
                                       withTemplate:@":$1"];

  selName = [selName stringByReplacingOccurrencesOfString:@"()" withString:@""];

  return NSSelectorFromString(selName);
}

@end