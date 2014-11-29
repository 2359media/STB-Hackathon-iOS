//
//  UIFont+AppFonts.h
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (AppFonts)

+ (UIFont *)appBookFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appBoldFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appLightFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appLightSmallCapsFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appDemiFontOfSize:(CGFloat)fontSize;

@end
