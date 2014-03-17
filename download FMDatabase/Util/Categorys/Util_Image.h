//
//  Util_Image.h
//  FpiFramework
//
//  Created by hj on 13-8-12.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Util_Image)

+ (UIImage *)imageWithNamed:(NSString *)imageName;

/*垂直翻转*/
- (UIImage *)flipVertical;

/*水平翻转*/
- (UIImage *)flipHorizontal;

/*改变size*/
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;

/*裁切*/
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

#pragma mark - 
- (UIImage *)transprent;

- (UIImage *)rounded;
- (UIImage *)rounded:(CGRect)rect;

- (UIImage *)stretched;
- (UIImage *)stretched:(UIEdgeInsets)capInsets;

- (UIImage *)grayscale;

- (UIColor *)patternColor;

- (UIImage *)merge:(UIImage *)image;
- (UIImage *)resize:(CGSize)newSize;

- (NSData *)dataWithExt:(NSString *)ext;

@end
