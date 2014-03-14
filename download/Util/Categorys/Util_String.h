//
//  Util_String.h
//  cocosText
//
//  Created by hj on 13-8-1.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_INLINE NSString * IntString(int v) {
    return [NSString stringWithFormat:@"%d",v];
}

@interface Util_String : NSObject

+(NSString *)generateFileName;
+(NSString *)generateTradeNO;

@end


//////
@interface NSString (Util_String)

-(NSString *)getFirstLetter;

-(NSString *)trimString;
//过滤敏感字
-(NSString *)filterString;

-(BOOL)isHaveIllegalCharacter;

-(BOOL)isValidateEmail;

-(BOOL)isMobileNumber;

-(BOOL)isCharacterAndNumber;

-(BOOL)isChinese;

-(BOOL)isNumber;

-(BOOL)isChinCharAndNum;

-(BOOL)isChineseAndChar;

@end

@interface NSMutableAttributedString (TTT)

// 设置某段字的颜色
- (void)setColor:(UIColor *)color withRange:(NSRange)range;

// 设置某段字的字体
- (void)setFont:(UIFont *)font withRange:(NSRange)range;

// 设置某段字的风格
- (void)setUnderlineStyle:(CTUnderlineStyle)style withRange:(NSRange)range;

@end
