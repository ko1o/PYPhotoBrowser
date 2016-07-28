//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void(^PYBytesReceivedBlock)(unsigned long long totalBytesDownloaded, unsigned long long totalBytesExpectedToDownload);

@interface PYDownloadDataManager : NSObject
// 自动开启下载任务
- (instancetype)downloadFileWithRequest:(NSMutableURLRequest *)request tempFilePatch:(NSString *)tempPath CacheFilePath:(NSString *)cachePath bytesReceivedBlock:(PYBytesReceivedBlock)block;

// 取消下载
- (void)cancel;

@end
