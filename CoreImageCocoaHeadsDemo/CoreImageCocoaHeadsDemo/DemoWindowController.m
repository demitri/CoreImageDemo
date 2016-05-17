//
//  DemoWindowController.m
//  CoreImageCocoaHeadsDemo
//
//  Created by Demitri Muna on 2/12/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DemoWindowController.h"
#import "CIImage+NSImageUtilities.h"

@interface DemoWindowController ()

@end

@implementation DemoWindowController

@synthesize originalPhoto;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
		
		// Load colormap
		// -------------
		NSString *colormapImageFile = [[NSBundle mainBundle] pathForResource:@"blackbody"
																	  ofType:@"tiff"];
		self.colormapImage = [CIImage imageWithContentsOfURL:[NSURL fileURLWithPath:colormapImageFile]];
    }
    
    return self;
}

- (void)windowDidLoad
{
	[super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib
{
	//self.originalPhoto = [NSImage imageNamed:@"kitty.jpg"]; // for NSImage

	NSURL *url = [[NSBundle mainBundle] URLForResource: @"kitty" withExtension:@"jpg"];
	self.originalPhoto = [CIImage imageWithContentsOfURL:url];
	
	// sanity check
	if (self.originalPhoto == nil) {
		NSLog(@"The photo specified was not found!");
	}
	
	_beforeImageView.image = self.originalPhoto.nsImage; //[NSImage imageNamed:@"kitty.jpg"];
	_beforeImageView.needsDisplay = YES;
}

- (IBAction)coreImagifyAction:(id)sender
{
	// Note that Core Image operates on CIImages, not NSImages.

	// Create and set the parameters on the filter.
	// Key values are found in the Core Image Filter reference:
	//	https://developer.apple.com/library/mac/#documentation/graphicsimaging/reference/CoreImageFilterReference/Reference/reference.html
	
	CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
	[filter setValue:self.originalPhoto forKey:@"inputImage"];
	[filter setValue:@1.75 forKey:@"inputSaturation"];
	[filter setValue:@0.4 forKey:@"inputBrightness"];
	[filter setValue:@2.4 forKey:@"inputContrast"];

	// To get the result, just get the output of the filter.
	CIImage *outputImage = [filter valueForKey:@"outputImage"];
	
	// Convert the CIImage back to an NSImage to place in NSImageView
	self.afterImageView.image = outputImage.nsImage;
	
}

- (IBAction)twoFiltersAction2:(id)sender
{
	// String two filters together.
	
	CIFilter *colorFilter = [CIFilter filterWithName:@"CIColorControls"];
	[colorFilter setValue:self.originalPhoto forKey:@"inputImage"];
	[colorFilter setValue:@1.75 forKey:@"inputSaturation"];
	[colorFilter setValue:@0.4 forKey:@"inputBrightness"];
	[colorFilter setValue:@2.4 forKey:@"inputContrast"];

	CIFilter *colorInvertFilter = [CIFilter filterWithName:@"CIColorInvert"];
	[colorInvertFilter setValue:[colorFilter valueForKey:@"outputImage"]
						 forKey:@"inputImage"];
	
	// To get the result, just get the output of the filter.
	CIImage *outputImage = [colorInvertFilter valueForKey:@"outputImage"];
	
	// Convert the CIImage back to an NSImage to place in NSImageView
	self.afterImageView.image = outputImage.nsImage;
}

- (IBAction)twoFiltersAction:(id)sender
{
	CIImage *image = self.originalPhoto;
	
	image = [self _pixellateImage:image];
	//image = [self _lanczosScaleImage:image withScaleFactor:5.0];
	image = [self _affineScaleFilter:image withScaleFactor:10.0];
	image = [self _colormapFilter:image];

	// Convert the CIImage back to an NSImage to place in NSImageView
	
	NSImage *nsImage = image.nsImage;
	NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, nsImage.size.width, nsImage.size.height)];
	imageView.image = nsImage;
	self.scrollView.documentView = imageView;
//	self.afterImageView.image = image.nsImage;
}

- (CIImage*)_pixellateImage:(CIImage*)image
{
	CIFilter *pixellateFilter = [CIFilter filterWithName:@"CIPixellate"];
	[pixellateFilter setDefaults];
	
	[pixellateFilter setValue:image forKey:kCIInputImageKey];
	[pixellateFilter setValue:@(1) forKey:kCIInputScaleKey];
	return [pixellateFilter valueForKey:kCIOutputImageKey];
}

- (CIImage*)_lanczosScaleImage:(CIImage*)image withScaleFactor:(float)scaleFactor
{
	CIFilter *scalingFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
	[scalingFilter setDefaults];

	[scalingFilter setValue:image forKey:kCIInputImageKey];
	[scalingFilter setValue:@(scaleFactor) forKey:kCIInputScaleKey];
	[scalingFilter setValue:@(1) forKey:kCIInputAspectRatioKey];
	return [scalingFilter valueForKey:kCIOutputImageKey];
}

- (CIImage*)_affineScaleFilter:(CIImage*)image withScaleFactor:(float)scaleFactor
{
	CIFilter *affineFilter = [CIFilter filterWithName:@"CIAffineTransform"];
	[affineFilter setDefaults];
	
	NSAffineTransform *transform = [NSAffineTransform transform]; // init to identity
	[transform scaleBy:scaleFactor];
	
	[affineFilter setValue:image forKey:kCIInputImageKey];
	[affineFilter setValue:transform forKey:kCIInputTransformKey];
	return [affineFilter valueForKey:kCIOutputImageKey];
}

- (CIImage*)_colormapFilter:(CIImage*)image
{
	CIFilter *colormapFilter = [CIFilter filterWithName:@"CIColorMap"];
	
	[colormapFilter setValue:image forKey:kCIInputImageKey];
	[colormapFilter setValue:self.colormapImage forKey:kCIInputGradientImageKey];
	return [colormapFilter valueForKey:kCIOutputImageKey];
}

@end
