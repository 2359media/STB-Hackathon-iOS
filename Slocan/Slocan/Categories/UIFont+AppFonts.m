//
//  UIFont+AppFonts.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "UIFont+AppFonts.h"

@implementation UIFont (AppFonts)

+ (UIFont *)appBookFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NeutraText-Book" size:fontSize];
}

+ (UIFont *)appBoldFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NeutraText-Bold" size:fontSize];
}

+ (UIFont *)appLightFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NeutraText-Light" size:fontSize];
}

+ (UIFont *)appLightSmallCapsFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NeutraText-LightSC" size:fontSize];
}

+ (UIFont *)appDemiFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NeutraText-Demi" size:fontSize];
}

@end
