//
//  CIImage+NSImageUtilities.m
//

#import "CIImage+NSImageUtilities.h"

@implementation CIImage (NSImageUtilities)

- (NSImage *)nsImageFromRect:(CGRect)r
{
    NSImage *image;
    //NSCIImageRep *ir;
    
    //ir = [NSCIImageRep imageRepWithCIImage:self];
    //image = [[NSImage alloc] initWithSize: NSMakeSize(r.size.width, r.size.height)];
    //[image addRepresentation:ir];
    //return image;

	
	image = [NSImage imageWithSize:NSMakeSize(r.size.width, r.size.height)
						   flipped:YES
			 drawingHandler:^BOOL(NSRect dstRect) {
				 // this method is recommended as it's valid at any (e.g. Retina) resolutions
				 [self drawAtPoint: NSMakePoint(0,0)
							 fromRect: NSMakeRect(0,0,r.size.width,r.size.height)
							operation: NSCompositeSourceOver
							 fraction: 1.0];
				 return true;
			 }];
	return image;
}

- (NSImage *)nsImage
{
	return [self nsImageFromRect:[self extent]];
}

@end
