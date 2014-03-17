//
//  Util_String.m
//  cocosText
//
//  Created by hj on 13-8-1.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "Util_String.h"

@implementation Util_String

+(NSString *)generateFileName{
    const int N = 8;
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

+(NSString*)generateTradeNO{
	const int N = 15;
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

@end


///////
@implementation NSString (Util_String)

-(NSString *)getFirstLetter{
//    if (self.length==0) {
//        return @"#";
//    }
//    if ([[self substringToIndex:1] isCharacterAndNumber]) {
//        return [self substringToIndex:1];
//    }
//    char code = pinyinFirstLetter([self characterAtIndex:0]);
//    return [NSString stringWithFormat:@"%c",code];
    return self;
}

-(NSString *)trimString{
//    NSArray * arr_Character=[NSArray arrayWithObjects:@"\\",@"\"",nil];
//    for (int i=0; i<[arr_Character count]; i++) {
//        NSString * str = [arr_Character objectAtIndex:i];
//        self=[self stringByReplacingOccurrencesOfString:str withString:@""];
//    }
    return self;
}

//过滤敏感字
-(NSString *)filterString{
//    NSArray * arr_Character = [[CachCenter shared] SqlGetPublicInfoForKey:CACH_KEY_FILTER CachHour:0];
//    if (arr_Character && [arr_Character count]>0) {
//        for (int i=0; i<[arr_Character count]; i++) {
//            NSDictionary * dic = [arr_Character objectAtIndex:i];
//            NSString * str = [dic objectForKey:@"keyword"];
//            NSString * newStr = @"*";
//            for (int i=1; i<str.length; i++) {
//                newStr = [newStr stringByAppendingString:@"*"];
//            }
//            if (str) {
//                self=[self stringByReplacingOccurrencesOfString:str withString:newStr];
//            }
//        }
//    }
    return self;
}

-(BOOL)isHaveIllegalCharacter{
//    NSArray * arr_Character=[NSArray arrayWithObjects:@"=",nil];
//    for (int i=0; i<[arr_Character count]; i++) {
//        NSRange foundObj = [self rangeOfString:[arr_Character objectAtIndex:i] options:NSCaseInsensitiveSearch];
//        if (foundObj.location!=NSNotFound) {
//            return YES;
//        }
//    }
    return NO;
}

-(BOOL)isValidateEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL)isMobileNumber{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    return ([regextestmobile evaluateWithObject:self] || [regextestcm evaluateWithObject:self]
            || [regextestct evaluateWithObject:self]  || [regextestcu evaluateWithObject:self]);

}

-(BOOL)isCharacterAndNumber{
    NSString * str = @"^[A-Za-z0-9]+$";
    NSPredicate * Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [Test evaluateWithObject:self];
}

-(BOOL)isChinese{
    NSString * str = @"^[\u4e00-\u9fa5]+$";
    NSPredicate * Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [Test evaluateWithObject:self];
}

-(BOOL)isNumber{
    NSString * str = @"^[0-9]+$";
    NSPredicate * Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [Test evaluateWithObject:self];
}

-(BOOL)isChinCharAndNum{
    NSString * str = @"^[A-Za-z0-9\u4e00-\u9fa5]+$";
    NSPredicate * Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [Test evaluateWithObject:self];
}

-(BOOL)isChineseAndChar{
    NSString * str = @"^[A-Za-z\u4e00-\u9fa5]+$";
    NSPredicate * Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [Test evaluateWithObject:self];
}

@end


////////
@implementation NSMutableAttributedString (TTT)

- (void)setColor:(UIColor *)color withRange:(NSRange)range{
    int length = range.location+range.length;
    if (length > self.length) {
        return;
    }
    [self addAttribute:(NSString *)kCTForegroundColorAttributeName
                 value:(id)color.CGColor
                 range:range];
}

- (void)setFont:(UIFont *)font withRange:(NSRange)range{
    int length = range.location+range.length;
    if (length > self.length) {
        return;
    }
    [self addAttribute:(NSString *)kCTFontAttributeName
                 value:(id)CTFontCreateWithName((CFStringRef)font.fontName,
                                                font.pointSize,
                                                NULL)
                 range:range];
}

- (void)setUnderlineStyle:(CTUnderlineStyle)style withRange:(NSRange)range{
    int length = range.location+range.length;
    if (length > self.length) {
        return;
    }
    [self addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                 value:(id)[NSNumber numberWithInt:style]
                 range:range];
}

@end
