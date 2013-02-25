//
//  SlidingTableCell.h
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDBadgedCell.h"

@interface WMSlidingTableViewCell : TDBadgedCell
{
    BOOL supressDeleteButton;
}

@property (nonatomic) BOOL supressDeleteButton;

@end
