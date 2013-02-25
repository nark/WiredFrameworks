//
//  WMModalViewController.h
//  iWi
//
//  Created by Rafaël Warnault on 22/11/11.
//  Copyright (c) 2011 Read-Write. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WMModalTableViewController;



@protocol WMModalTableViewControllerDelegate <NSObject>

- (void)modalViewControllerDidCancel:(WMModalTableViewController *)controller;
- (void)modalViewController:(WMModalTableViewController *)controller didSave:(id)object;

@end



@interface WMModalTableViewController : UITableViewController

@property (readwrite, retain) id<WMModalTableViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end