// UIImage-SQLitePersistence.h
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------
#if (TARGET_OS_IPHONE)
#import "NSObject-SQLitePersistence.h"

@implementation UIImage(SQLitePersistence)
+ (id)objectWithSQLBlobRepresentation:(NSData *)data
{
	return  [UIImage imageWithData:data];	
}
- (NSData *)sqlBlobRepresentationOfSelf{
	return UIImagePNGRepresentation (self);
}
+ (BOOL)canBeStoredInSQLite
{
	return YES;
}
+ (NSString *)columnTypeForObjectStorage
{
	return kSQLiteColumnTypeBlob;	
}
+ (BOOL)shouldBeStoredInBlob
{
	return YES;
}
@end
#endif