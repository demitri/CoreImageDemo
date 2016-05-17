//
//  CIImage+NSImageUtilities.h
//  CoreImageCocoaHeadsDemo
//
//  Created by Demitri Muna on 2/12/13.
//
//  Modified from: http://gigliwood.com/weblog/Cocoa/Core_Image__Practic.html
//
// Uses ARC; see the link above for the non-ARC code.

#import <Cocoa/Cocoa.h>

@interface CIImage (NSImageUtilities)

- (NSImage *)nsImageFromRect:(CGRect)r;
- (NSImage *)nsImage;

@end
