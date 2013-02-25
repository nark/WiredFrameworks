//
//  UIColor+WiredUIKit.m
//  iWi
//
//  Created by Rafaël Warnault on 30/11/11.
//  Copyright (c) 2011 Read-Write. All rights reserved.
//


/*
 <p7:enum name="wired.account.color.black" value="0" version="2.0" />
 <p7:enum name="wired.account.color.red" value="1" version="2.0" />
 <p7:enum name="wired.account.color.orange" value="2" version="2.0" />
 <p7:enum name="wired.account.color.green" value="3" version="2.0" />
 <p7:enum name="wired.account.color.blue" value="4" version="2.0" />
 <p7:enum name="wired.account.color.purple" value="5" version="2.0" />
 */

#import "UIColor+WiredUIKit.h"

@implementation UIColor (WiredUIKit)



#pragma mark -

+ (id)colorForWiredColor:(NSInteger)colorType {
    
    UIColor *color = [UIColor blackColor];
    
    switch (colorType) {
        case 0: color   = [UIColor blackColor];     break;
        case 1: color   = [UIColor redColor];       break;
        case 2: color   = [UIColor orangeColor];    break;
        case 3: color   = [UIColor greenColor];     break;
        case 4: color   = [UIColor blueColor];      break;
        case 5: color   = [UIColor purpleColor];    break;
        default: color  = [UIColor blackColor];     break;
    }
    
    return color;
}





#pragma mark -

+ (UIColor *)iWiredAppearanceColor {
	return [UIColor darkGrayColor];
}




#pragma mark -

+ (UIColor *)tableViewPlainCellBackgroundGradient {
    
    UIImage *image = [[UIImage imageNamed:@"PlainCellGradient.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:30];
    UIColor *color = [UIColor colorWithPatternImage:image];
    
    return color;    
}



+ (UIColor *)tableViewGroupedCellBackgroundGradient {
	return [UIColor colorWithPatternImage:[UIImage imageNamed:@"GroupedCellGradient.png"]];
}

@end

