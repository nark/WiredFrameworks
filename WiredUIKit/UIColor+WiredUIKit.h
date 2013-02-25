//
//  UIColor+WiredUIKit.h
//  iWi
//
//  Created by Rafaël Warnault on 30/11/11.
//  Copyright (c) 2011 Read-Write. All rights reserved.
//


@interface UIColor (WiredUIKit)

+ (id)colorForWiredColor:(NSInteger)color;

+ (UIColor *)iWiredAppearanceColor;

+ (UIColor *)tableViewPlainCellBackgroundGradient;
+ (UIColor *)tableViewGroupedCellBackgroundGradient;

@end
