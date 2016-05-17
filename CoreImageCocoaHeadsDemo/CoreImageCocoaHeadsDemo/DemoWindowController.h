//
//  DemoWindowController.h
//  CoreImageCocoaHeadsDemo
//
//  Created by Demitri Muna on 2/12/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DemoWindowController : NSWindowController

@property (strong) CIImage *originalPhoto;

@property (strong) IBOutlet NSImageView *beforeImageView;
@property (strong) IBOutlet NSImageView *afterImageView;

@property (strong) CIImage *colormapImage;
@property (nonatomic, strong) IBOutlet NSScrollView *scrollView;

- (IBAction)coreImagifyAction:(id)sender;
- (IBAction)twoFiltersAction:(id)sender;

@end
