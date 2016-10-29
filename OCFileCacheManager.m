//
//  OCFileCacheManager.m
//
//
//  Created by wangcheng on 2016/1/4.
//  Copyright © 2016年 onechange. All rights reserved.
//

#import "OCFileCacheManager.h"

@implementation OCFileCacheManager

+ (NSInteger)getFileCacheSize:(NSString *)filePath
{
    //创建文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    //获取文件尺寸
    NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
    return [attr[NSFileSize] integerValue];
}


+ (void)getDirectoryCacheSize:(NSString *)directoryPath completeBlock:(void(^)(NSInteger))completeBlock
{
    //开辟异步线程计算
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager *mgr = [NSFileManager defaultManager];
        // 判断传入路径是否是文件夹路径
        BOOL isDirectory;
        BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
        // 文件不存在 或者 传入不是文件夹,就不执行下面计算
        if (!isExist || !isDirectory) {
            //抛异常
            NSException *excp = [NSException exceptionWithName:@"FileError" reason:@"传入文件不存在或者传入的不是文件夹" userInfo:nil];
            [excp raise];
        }
        //计算文件夹尺寸,将所有文件尺寸相加
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        NSInteger total = 0;
        //遍历所有子路径
        for (NSString *subPath in subPaths) {
            //文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            BOOL isDirectory;
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            //文件存在并且不是文件夹,而且也不是隐藏文件,才需要计算
            if (isExist && ! isDirectory && ![filePath containsString:@"DS"]) {
                // 获取文件尺寸
                total += [self getFileCacheSize:filePath];
            }
        }
        // 回到主线程调用block
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock(total);
            }
        });
    });
}

+ (void)deleteFilePath:(NSString *)filePath
{
    //创建文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    //判断是文件夹还是文件
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!isExist) return;
    if (isDirectory) {
        // 删文件夹
        // 遍历所有子路径 一个一个删除
        NSArray *subPaths = [mgr subpathsAtPath:filePath];
        for (NSString *subPath in subPaths) {
            // 文件全路径
            NSString *subfilePath = [filePath stringByAppendingPathComponent:subPath];
            // 删除文件
            [mgr removeItemAtPath:subfilePath error:nil];
        }
    } else {
        [mgr removeItemAtPath:filePath error:nil];
    }
}
@end
