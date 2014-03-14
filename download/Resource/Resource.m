//
//  Resource.m
//  TankOnlineClient
//
//  Created by hj on 13-8-2.
//  Copyright 2013 PHJ. All rights reserved.
//

#import "Resource.h"

#define DOCUMENT_FOLDER_NAME @"Documents"
#define RESOURCE_FOLDER_NAME @"Cache"

@implementation Resource
+ (NSString*)getDocmentsPath{
    NSString * folder=[NSString stringWithFormat:@"/%@/",DOCUMENT_FOLDER_NAME];
    
	BOOL isDir;
	BOOL dirExist=[[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir];
	if(!dirExist ||!isDir )
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:folder 
								  withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return [NSHomeDirectory() stringByAppendingString:folder];
}

+(NSString *)getResourcesPath{
    NSString * folder=[NSString stringWithFormat:@"/%@/%@/",DOCUMENT_FOLDER_NAME,RESOURCE_FOLDER_NAME];
	NSString * path=[NSHomeDirectory() stringByAppendingString:folder];
	BOOL isDir;
	BOOL dirExist=[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	if(!dirExist ||!isDir )
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:path 
								  withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return path;
}

+ (NSString*)getResourcePathWithName:(NSString*)name{
    if (name.length<1) {
        return nil;
    }
    if (name.length>7 && [[[name substringToIndex:7] lowercaseString] compare:@"http://"]==NSOrderedSame) {
        name = [name substringFromIndex:7];
    }
	NSString * path =[[Resource getResourcesPath] stringByAppendingPathComponent:name];
	return path;
}

+ (NSString *)generateFileName{
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

+(void)createPath:(NSString*)path{
    if ([[path substringFromIndex:[path length]-1] compare:@"/"]!=NSOrderedSame) {
        path=[path stringByDeletingLastPathComponent];
    }
    
    BOOL isDir;
	BOOL dirExist=[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	if(!dirExist )
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:path
								  withIntermediateDirectories:YES attributes:nil error:nil];
	}
}

#pragma mark 
+ (NSArray*)getArrayWithPlistName:(NSString*)plistName{
	
	NSString *plistPath=[[Resource getDocmentsPath] stringByAppendingFormat:@"%@.plist",plistName];
	NSArray * result=[NSArray arrayWithContentsOfFile:plistPath];
	if (result==nil) {
		NSBundle *bundles=[NSBundle mainBundle];
		plistPath=[bundles pathForResource:plistName ofType:@"plist"];
		result=[NSArray arrayWithContentsOfFile:plistPath];
	}
	return result;
}

+ (BOOL)saveArray:(NSArray*)array ToPlistName:(NSString*)plistName{
    NSString *plistPath=[[Resource getDocmentsPath] stringByAppendingFormat:@"%@.plist",plistName];
	if (array) {
        return [array writeToFile:plistPath atomically:YES];
    }
    return FALSE;
}

+ (BOOL)saveDictionary:(NSDictionary*)dic ToPlistName:(NSString*)plistName{
    NSString *plistPath=[[Resource getDocmentsPath] stringByAppendingFormat:@"%@.plist",plistName];
	BOOL result=NO;
    if (dic) {
        result= [dic writeToFile:plistPath atomically:YES];
    }
    return result;
}

+ (NSDictionary*)getDictionaryWithPlistName:(NSString*)plistName{
	
	NSString *plistPath=[[Resource getDocmentsPath] stringByAppendingFormat:@"%@.plist",plistName];
	NSDictionary * result=[NSDictionary dictionaryWithContentsOfFile:plistPath];
	if (result==nil) {
		NSBundle *bundles=[NSBundle mainBundle];
		plistPath=[bundles pathForResource:plistName ofType:@"plist"];
		result=[NSDictionary dictionaryWithContentsOfFile:plistPath];
	}
	return result;
}

#pragma mark - Image
+(UIImage*)getImageWithName:(NSString*)imageName{
    if (!imageName || [imageName length]<1) {
        return nil;
    }
    
    NSString *newImageFile = imageName;
    if (imageName.length>7 && [[[imageName substringToIndex:7] lowercaseString] compare:@"http://"]==NSOrderedSame) {
        newImageFile = [imageName substringFromIndex:7];
    }
    
	NSString * path=[[Resource getResourcesPath] stringByAppendingPathComponent:newImageFile];
    
	UIImage * image=[UIImage imageWithContentsOfFile:path];
	if (image) {
		return image;
	}
	return [UIImage imageNamed:newImageFile];
    
}

+(UIImage*)getSmallImage:(UIImage*)image{
    UIImage * source=image;
    float targetWidth=image.size.width;
    float targetHeight=image.size.height;
    if (targetWidth>150 || targetHeight>150) {
        float scale=MAX(targetWidth, targetHeight)/200.0f;
        
        targetWidth=targetWidth/scale;
        targetHeight=targetHeight/scale;
        
        UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
        [image drawInRect:CGRectMake(0, 0, targetWidth,targetHeight)];
        source=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return source;
}

+(UIImage*)compressImage:(UIImage*)image MaxWidth:(float)width MaxHeight:(float)height{
    if(!image){
        return nil;
    }
    int targetWidth=image.size.width;
    int targetHeight=image.size.height;
    float scale=MAX(targetWidth/width,targetHeight/height);
    
    UIImage * source=image;
    if (scale>1) {
        targetWidth=targetWidth/scale;
        targetHeight=targetHeight/scale;
        
        UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
        [image drawInRect:CGRectMake(0, 0, targetWidth,targetHeight)];
        source=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    NSLog(@"compress image from %fx%f to %fx%f",image.size.width,image.size.height,source.size.width,source.size.height);
    return source;
}

+(NSString*)saveImage:(UIImage*)image{
    NSString * name = [NSString stringWithFormat:@"upload/local/%@.jpg",[Resource generateFileName]];
    NSString * destinationPath=[NSString stringWithFormat:@"%@%@",[Resource getResourcesPath],name];
    
    UIImage * source=image;
    
    float targetWidth=image.size.width;
    float targetHeight=image.size.height;
    float scale=MAX(targetWidth/640,targetHeight/960);
    if (scale>1) {
        targetWidth=targetWidth/scale;
        targetHeight=targetHeight/scale;
        
        UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
        [image drawInRect:CGRectMake(0, 0, targetWidth,targetHeight)];
        source=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [Resource createPath:destinationPath];
    NSData *imageData = UIImageJPEGRepresentation(source, 0.6);
    [imageData writeToFile:destinationPath atomically:YES];
    
    return name;
}

+(NSString*)saveImage:(UIImage*)image Compress:(BOOL)compress MaxWidth:(float)maxWidth MaxHeight:(float)maxHeight{
    NSString * name = [NSString stringWithFormat:@"upload/local/%@.jpg",[Resource generateFileName]];
    NSString * destinationPath=[NSString stringWithFormat:@"%@%@",[Resource getResourcesPath],name];
    
    if (maxWidth<=0) {
        maxWidth=640;
    }
    if (maxHeight<=0) {
        maxHeight=960;
    }
    
    UIImage * source=image;
    if (compress) {
        float targetWidth=image.size.width;
        float targetHeight=image.size.height;
        float scale=MAX(targetWidth/maxWidth,targetHeight/maxHeight);
        if (scale>1) {
            targetWidth=targetWidth/scale;
            targetHeight=targetHeight/scale;
            
            UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
            [image drawInRect:CGRectMake(0, 0, targetWidth,targetHeight)];
            source=UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    [Resource createPath:destinationPath];
    NSData *imageData = UIImageJPEGRepresentation(source, 0.6);
    [imageData writeToFile:destinationPath atomically:YES];
    return destinationPath;
    
}

+(void)clearCache{
    NSString * destinationPath=[Resource getResourcesPath];
    float size = [Resource folderSizeAtPath:destinationPath];
    NSLog(@"size:%f",size);
    if (size>200) { //大于200M清除缓存
        [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];
        [Resource createPath:destinationPath];
    }
}

//单个文件的大小
+(long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
+(float)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [Resource fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

@end
