//
//  WMModalViewController.h
//  iWi
//
//  Created by Rafaël Warnault on 28/11/11.
//  Copyright (c) 2011 Read-Write. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WMModalViewController;


@protocol WMModalViewControllerDelegate <NSObject>

- (void)modalViewControllerDidCancel:(WMModalViewController *)controller;
- (void)modalViewController:(WMModalViewController *)controller didSave:(id)object;

@end


@interface WMModalViewController : UIViewController

@property (readwrite, retain) id<WMModalViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
