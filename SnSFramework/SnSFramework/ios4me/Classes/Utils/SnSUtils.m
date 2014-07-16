/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 */

//
//  SnSDelegate.m
//  SnSFramework
//
//  Created by Édouard Mercier on 18/12/2009.
//

#import "SnSUtils.h"
#import "UIScreen+Resolutions.h"
#import "UIDevice+DeviceDetection.h"

#pragma mark -
#pragma mark SnSUtils

@implementation SnSUtils

+ (BOOL) isPad {
#ifdef UI_USER_INTERFACE_IDIOM
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
	return NO;
#endif
}

+ (BOOL) emailIsValid:(NSString *)email
{
	
	NSString *emailRegEx = 
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx] ;
	
	return [regExPredicate evaluateWithObject:[email lowercaseString]];
}

+ (NSString*) applicationDocumentsPath                                                                                     
{                                                                                                                       
    NSArray *aPaths			= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);          
    NSString *aWritablePath	= [aPaths objectAtIndex:0];                                                                 
    
    return aWritablePath;                                                                                               
}

+ (NSString*) applicationCachesPath
{                                                                                                                       
    NSArray *aPaths			= NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);          
    NSString *aWritablePath	= [aPaths objectAtIndex:0];                                                                 
    
    return aWritablePath;                                                                                               
}
@end


#pragma mark -
#pragma mark SnSFontUtils

@implementation SnSFontUtils

+ (UIFont *)updateFontSize:(UIFont *)font addPointSize:(CGFloat)point
{
	return [font fontWithSize:(font.pointSize + point)];
}

@end

#pragma mark -
#pragma mark SnSColorUtils

@implementation SnSColorUtils


+ (UIColor *) colorFromWebColor:(NSString *)color {
	NSUInteger red = 0;
	NSUInteger green = 0;
	NSUInteger blue = 0;
	UIColor *result = nil;
	
	if (sscanf([color UTF8String], "#%2tx%2tx%2tx", &red, &green, &blue) == 3) {
		result = [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:1.0];
	}
	
	return result;
}

@end

#pragma mark -
#pragma mark SnSDateUtils

@implementation SnSDateUtils

static NSDateFormatter* sISO8601;

+ (NSDate *) dateFromISO8601:(NSString *) str {
	if (sISO8601 == nil) {
		sISO8601 = [[NSDateFormatter alloc] init];
		[sISO8601 setTimeStyle:NSDateFormatterFullStyle];
		[sISO8601 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	}
	if ([str hasSuffix:@"Z"]) {
		str = [str substringToIndex:(str.length-1)];
	}
	
	NSDate *d = [sISO8601 dateFromString:str];
	return d;
	
}

+ (NSString *) formatDate:(NSDate *)date withPattern:(NSString *)pattern withLocale:(NSLocale *)locale
{	
	NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
	
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:(locale!=nil)?locale:frLocale];
	[dateFormatter setTimeStyle:NSDateFormatterFullStyle];
	[dateFormatter setDateFormat:pattern];
	NSString * formattedDate = [dateFormatter stringFromDate:date];
	[frLocale release];
	[dateFormatter release];
	return formattedDate;	
}

+ (NSDate *) parseString:(NSString *)string withPattern:(NSString *)pattern withLocale:(NSLocale *)locale
{	
	NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
	
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:(locale!=nil)?locale:frLocale];
	[dateFormatter setTimeStyle:NSDateFormatterFullStyle];
	[dateFormatter setDateFormat:pattern];
	NSDate * date = [dateFormatter dateFromString:string];
	[frLocale release];
	[dateFormatter release];
	return date;	
}

@end


#pragma mark -
#pragma mark SnSUILabelUtils

@implementation SnSUILabelUtils

+ (void)resizeLabelHeight:(UILabel *)myLabel usingVerticalAlign:(int)vertAlign 
{
	[self setUILabel:myLabel withMaxWidth:myLabel.frame.size.width withText:myLabel.text usingVerticalAlign:vertAlign];
}

+ (void)setUILabel:(UILabel *)myLabel withMaxWidth:(CGFloat)maxWidth withText:(NSString *)theText usingVerticalAlign:(int)vertAlign 
{
	[self setUILabel:myLabel withMaxFrame:CGRectMake(myLabel.frame.origin.x,myLabel.frame.origin.y,maxWidth,NSIntegerMax) withText:theText usingVerticalAlign:vertAlign];
}

+ (void)setUILabel:(UILabel *)myLabel withMaxFrame:(CGRect)maxFrame withText:(NSString *)theText usingVerticalAlign:(int)vertAlign 
{
	CGSize stringSize = [theText sizeWithFont:myLabel.font constrainedToSize:maxFrame.size lineBreakMode:myLabel.lineBreakMode];
	
	switch (vertAlign) {
		case 0: // vertical align = top
			myLabel.frame = CGRectMake(myLabel.frame.origin.x, 
									   myLabel.frame.origin.y, 
									   stringSize.width, 
									   stringSize.height
									   );
			break;
			
		case 1: // vertical align = middle
			// don't do anything, lines will be placed in vertical middle by default
			break;
			
		case 2: // vertical align = bottom
			myLabel.frame = CGRectMake(myLabel.frame.origin.x, 
									   (myLabel.frame.origin.y + myLabel.frame.size.height) - stringSize.height, 
									   stringSize.width, 
									   stringSize.height
									   );
			break;
	}
	
	myLabel.text = theText;
}

@end

#pragma mark -
#pragma mark SnSImageUtils

@implementation SnSImageUtils

const NSString * DEFAULT_EXTENTION = @".png";

+ (UIImage *) addImage:(UIImage *)firstImage andOtherImage:(UIImage *)secondImage
{
	CGSize firstSize = firstImage.size;
	CGSize secondSize = secondImage.size;
	CGSize size;
	if (CGSizeEqualToSize(firstSize,secondSize)) 
		size = firstSize;
	else 
	{
		if (firstSize.width <= secondSize.width) 
			size = secondSize;
		else 
			size = firstSize;
	}
	UIGraphicsBeginImageContext(size);
	
	[firstImage drawAtPoint:CGPointMake((size.width - firstSize.width)/2, (size.height - firstSize.height)/2)];
	[secondImage drawAtPoint:CGPointMake((size.width - secondSize.width)/2, (size.height - secondSize.height)/2)];
	// Why the second UIImage is to be be retained is a total mistery!
	[secondImage retain];
	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}

+ (UIImage *) centerImage:(UIImage *)image inFrame:(CGRect)frame
{
	UIGraphicsBeginImageContext(frame.size);
	CGSize imageSize = image.size;
	CGPoint origin = CGPointMake((frame.size.width - imageSize.width)/2, (frame.size.height - imageSize.height)/2);
	[image drawAtPoint:origin];
	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}

+ (UIImage *)scaleAndRotateImage:(UIImage *)image andMaxSizeWidth:(int)maxWidth
{
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > maxWidth || height > maxWidth) 
	{
		CGFloat ratio = width/height;
		if (ratio > 1) 
		{
			bounds.size.width = maxWidth;
			bounds.size.height = bounds.size.width / ratio;
		}
		else 
		{
			bounds.size.height = maxWidth;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
	{
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else
	{
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

+ (UIImage *) imageNamed:(NSString *)name
{
	return [self imageNamed:name withExtention:nil];
}

+ (UIImage *) imageNamed:(NSString *)name withExtention:(NSString *)extention
{
	if ([UIDevice iOSVersion] >= 4.0)
	{
		// If Retina screen 4 inch we use naming convention filename-568h@2x
        if ([UIScreen resolution] == UIScreenResolutioniPhoneRetina4)
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-568h@2x",name ] ofType:((extention != nil) ? extention : @"png")];
            if (filePath != nil)
            {
                return [UIImage imageWithContentsOfFile:filePath];
            }
        }
        
        // iOS works without extention
		UIImage * result = [UIImage imageNamed:name];
		// HACK : Only for iPhone application running on iPad
		
		if (result == nil) 
		{
			NSString *pathBaseUrl = [[NSBundle mainBundle] bundlePath];
			BOOL isDirectory = NO;
			
			// get the iPhone ressource for Retina Display
			NSString * fileName = [NSString stringWithFormat:@"%@@2x~iphone%@",name ,(extention != nil) ? extention : DEFAULT_EXTENTION];
			
			BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[pathBaseUrl stringByAppendingPathComponent:fileName] isDirectory:&isDirectory];
			if (!fileExists) 
				fileName = [NSString stringWithFormat:@"%@%@",name ,(extention != nil) ? extention : DEFAULT_EXTENTION];
			
			result = [UIImage imageNamed:fileName];
		}
		return result;
	}
	else 
	{
		//NSArray * extentionsList = [NSArray arrayWithObjects:@".png", @".jpg", @".jpeg", @".gif", nil];
		
		if ([name rangeOfString:@"."].length > 0) 
		{
			// une extention est spécifiée, on ne fait rien de special
			return [UIImage imageNamed:name];
		}
		else 
		{
			NSString * fileName;
			// Test the device type
			if ([UIDevice isIPad]) 
			{
				// Device iPad
				fileName = [NSString stringWithFormat:@"%@~ipad%@",name ,(extention != nil) ? extention : DEFAULT_EXTENTION];
			}
			else 
			{
				// Device iPhone
				fileName = [NSString stringWithFormat:@"%@~iphone%@",name ,(extention != nil) ? extention : DEFAULT_EXTENTION];
			}
			
			NSString *pathBaseUrl = [[NSBundle mainBundle] bundlePath];
			BOOL isDirectory = NO;
			BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[pathBaseUrl stringByAppendingPathComponent:fileName] isDirectory:&isDirectory];
			
			if (fileExists == YES) 
				return [UIImage imageNamed:fileName];
			else 
				return [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",name ,(extention != nil) ? extention : DEFAULT_EXTENTION]];
		}
	}
	
	return [UIImage imageNamed:name];
}

+ (UIImage *)imageWithColor:(UIColor *)color 
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}

@end

#pragma mark -
#pragma mark SnSFileUtils

@implementation SnSFileUtils : NSObject

/**
 http://developer.apple.com/devcenter/download.action?path=/ios/ios_5.0.1_beta/iclouddonotbackupattribute.pdf
 
 *iOS 5.0.1 beta introduces a new "do not back up" attribute for specifying files that should remain on device, even in low storage situations. 
 Use this attribute with data that can be recreated but needs to persist even in low storage situations for proper functioning of your app or because customers expect it to be available during offline use. 
 This attribute works on marked files regardless of what directory they are in, including the Documents directory. 
 These files will not be purged and will not be included in the user's iCloud or iTunes backup. 
 Because these files do use on-device storage space, your app is responsible for monitoring and purging these files periodically.
 To set the "do not back up" attribute, add the following method to a class in your application. 
 Whenever you create a file that should not be backed up to iCloud, write the data to the file and then call this method, passing in a URL that points to the file.
 **/
#include <sys/xattr.h>
+ (void) AddSkipBackupAttributeToFile: (NSURL*) url
{
    u_int8_t b = 1;
    setxattr([[url path] fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}
@end

