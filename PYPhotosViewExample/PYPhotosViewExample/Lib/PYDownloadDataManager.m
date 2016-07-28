//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYDownloadDataManager.h"

@interface PYDownloadDataManager ()<NSURLConnectionDataDelegate>
{
    NSString *_tempPath; // 临时存储路径
    NSString *_cachePath; // 下载完成时，存储路径
    NSFileManager *_fileManager; // 文件管理者
    NSFileHandle *_fileHandle; // 文件处理
    NSURLConnection *_connection; // 下载连接
    long long _totalLength; // 文件总大小
    long long _currentLength; // 当前文件大小
    PYBytesReceivedBlock _bytesReceivedBlock; // 接收数据回调
}

@end

@implementation PYDownloadDataManager

- (instancetype)downloadFileWithRequest:(NSMutableURLRequest *)request tempFilePatch:(NSString *)tempPath CacheFilePath:(NSString *)cachePath bytesReceivedBlock:(PYBytesReceivedBlock)block
{
    if (!request) return nil;
    // 记录存储路径
    _tempPath = tempPath;
    _cachePath = cachePath;
    _fileManager = [NSFileManager defaultManager];
    _fileHandle = [NSFileHandle fileHandleForWritingAtPath:_tempPath];
    _bytesReceivedBlock = block;
    
    // 获取当前文件大小
    _currentLength = [[_fileManager attributesOfItemAtPath:_tempPath error:nil] fileSize];
    
    // 设置请求头(断点下载)
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", _currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    // 开启下载任务(自动发起异步请求)
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    return self;
}


#pragma mark - NSURLConnectionDownloadDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 接收到服务器的响应
    // 创建一个空的文件 到 沙盒中
    if (![_fileManager fileExistsAtPath:_tempPath]) {
        [_fileManager createFileAtPath:_tempPath contents:nil attributes:nil];
    }
    
    // 创建一个用来写数据的文件句柄
    _fileHandle = [NSFileHandle fileHandleForWritingAtPath:_tempPath];
    
    // 获得文件的总大小
    _totalLength = _currentLength + response.expectedContentLength;
    
    // 设置文件大小（用于HttpServer）
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:_totalLength forKey:@"file_length"];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 接收数据
    // 移动到文件后面
    [_fileHandle seekToEndOfFile];
    // 写入数据
    [_fileHandle writeData:data];
    // 获取当前文件大小
    _currentLength += data.length;
    
    if (_bytesReceivedBlock) // 如果有回调函数，就调用
        _bytesReceivedBlock(_currentLength, _totalLength);
    // 刷新文件
    [_fileHandle synchronizeFile];
    
    if (_currentLength == _totalLength) {   // 转移到存储
        // 加载完毕
        NSError *error;
        [_fileManager moveItemAtPath:_tempPath toPath:_cachePath error:&error];
       
    }

}


- (void)cancel
{
    // 关闭文件
    [_fileHandle closeFile];
    _fileHandle = nil;
    
    [_connection cancel];
}

@end
