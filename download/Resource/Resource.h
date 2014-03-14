//
//  Resource.h
//  TankOnlineClient
//
//  Created by hj on 13-8-2.
//  Copyright 2013 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resource : NSObject

+ (NSString*) getDocmentsPath;
+ (NSString*) getResourcesPath;
+ (NSString*) getResourcePathWithName:(NSString*)name;
+ (NSString *)generateFileName;
+ (void)      createPath:(NSString*)path;

+ (NSArray*)  getArrayWithPlistName:(NSString*)plistName;
+ (NSDictionary*)getDictionaryWithPlistName:(NSString*)plistName;
+ (BOOL)      saveArray:(NSArray*)array ToPlistName:(NSString*)plistName;
+ (BOOL)      saveDictionary:(NSDictionary*)dic ToPlistName:(NSString*)plistName;

+(UIImage *)  getImageWithName:(NSString*)image;
+(UIImage *)  getSmallImage:(UIImage*)image;
+(UIImage *)  compressImage:(UIImage*)image MaxWidth:(float)width MaxHeight:(float)height;

+(NSString *) saveImage:(UIImage*)image;
+(NSString *) saveImage:(UIImage*)image Compress:(BOOL)compress MaxWidth:(float)maxWidth MaxHeight:(float)maxHeight;

+(void)       clearCache;

@end
