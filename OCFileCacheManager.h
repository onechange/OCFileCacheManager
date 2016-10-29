//
//  OCFileCacheManager.h
//
//
//  Created by wangcheng on 2016/1/4.
//  Copyright © 2016年 onechange. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
  这个类的作用就是只需要传入文件夹的路径,就可以计算出文件大小或者将其删除
*/
@interface OCFileCacheManager : NSObject

/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹路径
 *  @param completeBlock 计算完成回调block 
 *
 */
+ (void)getDirectoryCacheSize:(NSString *)directoryPath completeBlock:(void(^)(NSInteger total))completeBlock;

/**
 *  获取文件尺寸
 *
 *  @param filePath 文件路径
 *
 *  @return 文件尺寸
 */
+ (NSInteger)getFileCacheSize:(NSString *)filePath;

/**
 *  删除文件缓存
 *
 *  @param filePath 文件路径
 */
+ (void)deleteFilePath:(NSString *)filePath;
@end
