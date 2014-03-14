//
//  Util_Color.m
//  JGMobile
//
//  Created by hj on 13-8-1.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "Util_Color.h"

@implementation UIColor (Util_Color)

+ (UIColor*) colorWithHex:(long)hexColor{
    return [UIColor colorWithHex:hexColor alpha:0.4f];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}


+ (UIColor *)fromShortHexValue:(NSUInteger)hex{
	return [UIColor fromShortHexValue:hex alpha:1.0f];
}

+ (UIColor *)fromShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha{
	NSUInteger r = ((hex >> 8) & 0x0000000F);
	NSUInteger g = ((hex >> 4) & 0x0000000F);
	NSUInteger b = ((hex >> 0) & 0x0000000F);
	
	float fr = (r * 1.0f) / 15.0f;
	float fg = (g * 1.0f) / 15.0f;
	float fb = (b * 1.0f) / 15.0f;
	
	return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
}


+ (UIColor *)colorWithString:(NSString *)string{
	if ( nil == string || 0 == string.length )
		return [UIColor clearColor];
	
	string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
	NSArray *	array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *	color = [array objectAtIndex:0];
    CGFloat		alpha = 1.0f;
    
	if ( array.count == 2 )
    {
        alpha = [[array objectAtIndex:1] floatValue];
    }
    
    if ( [color hasPrefix:@"#"] ) // #FFF
    {
		color = [color substringFromIndex:1];
        
		if ( color.length == 3 )
		{
			NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
			return [UIColor fromShortHexValue:hexRGB alpha:alpha];
		}
		else if ( color.length == 6 )
		{
			NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
			return [UIColor colorWithHex:hexRGB];
		}
    }
    else if ( [color hasPrefix:@"0x"] || [color hasPrefix:@"0X"] ) // #FFF
    {
		color = [color substringFromIndex:2];
		
		if ( color.length == 8 )
		{
			NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
			return [UIColor colorWithHex:hexRGB];
		}
		else if ( color.length == 6 )
		{
			NSUInteger hexRGB = strtol(color.UTF8String , nil, 16);
			return [UIColor colorWithHex:hexRGB alpha:1.0f];
		}
	}
    else
    {
        static NSMutableDictionary * __colors = nil;
        
        if ( nil == __colors )
        {
            __colors = [[NSMutableDictionary alloc] init];
            [__colors setObject:[UIColor clearColor] forKey:@"clear"];
            [__colors setObject:[UIColor clearColor] forKey:@"transparent"];
            [__colors setObject:[UIColor redColor] forKey:@"red"];
            [__colors setObject:[UIColor blackColor] forKey:@"black"];
            [__colors setObject:[UIColor darkGrayColor] forKey:@"darkGray"];
            [__colors setObject:[UIColor lightGrayColor] forKey:@"lightGray"];
            [__colors setObject:[UIColor whiteColor] forKey:@"white"];
            [__colors setObject:[UIColor grayColor] forKey:@"gray"];
            [__colors setObject:[UIColor redColor] forKey:@"red"];
            [__colors setObject:[UIColor greenColor] forKey:@"green"];
            [__colors setObject:[UIColor blueColor] forKey:@"blue"];
            [__colors setObject:[UIColor cyanColor] forKey:@"cyan"];
            [__colors setObject:[UIColor yellowColor] forKey:@"yellow"];
            [__colors setObject:[UIColor magentaColor] forKey:@"magenta"];
            [__colors setObject:[UIColor orangeColor] forKey:@"orange"];
            [__colors setObject:[UIColor purpleColor] forKey:@"purple"];
            [__colors setObject:[UIColor brownColor] forKey:@"brown"];
        }
        
        return [__colors objectForKey:color.lowercaseString];
    }
    
    return [UIColor clearColor];
}


@end
