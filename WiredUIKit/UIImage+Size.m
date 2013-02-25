//
//  UImage+Size.m
//  wired
//
//  Created by Rafaël Warnault on 01/05/12.
//  Copyright (c) 2012 Read-Write.fr. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)

- (UIImage*)scaleToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;
}


@end
