//
//  NBRequestManager.m
//  NewsBeijingDemo
//
//  Created by Lori on 13-12-9.
//  Copyright (c) 2013年 Lori. All rights reserved.
//

#import "NBRequestManager.h"
#import "ViewController.h"
//
@interface NBRequestManager ()
//
{
    //
    NSMutableData *receivedData;
    
}

@end

//添加私有类目 处理本类的事物
@interface NBRequestManager (URLCreation)

//参数字符串
- (NSString *)_createParamString;
//clean数据
- (void)_cleanCatchedData;

@end

@implementation NBRequestManager (URLCreation)

- (NSString *)_createParamString
{
    NSString *paramString = nil;
    NSMutableArray *paramArray = [NSMutableArray array];
    //
    for (NSString *key in paramsDic.allKeys) {
        NSString *tempString = [NSString stringWithFormat:@"%@=%@",key,[paramsDic objectForKey:key]];
        [paramArray addObject:tempString];
    }
    
    paramString = [paramArray componentsJoinedByString:@"&"];
    return paramString;
}

- (void)_cleanCatchedData
{
    //
    [receivedData setData:nil];
}

@end

@implementation NBRequestManager

+ (id)sharedRequest
{
    static NBRequestManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NBRequestManager alloc] init];
    });
    return instance;
}

-(void)URLRefresh:(NSInteger)startrecord{
    NSString *str = @"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?";
    NSString *url = [str stringByAppendingFormat:@"date=20131129&startRecord=%d&len=30&udid=1234567890&terminalType=Ipad&cid=218",startrecord];
    [self startRequestInfo:url];
}

- (void)startRequestInfo:(NSString *)url
{
    NSURL *sourceAddressURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:sourceAddressURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[self _createParamString] dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!receivedData) {
        receivedData = [[NSMutableData alloc] init];
    }
    [receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:receivedData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(request:didFinishLoadingWithInfo:)]) {
        [self.delegate request:self didFinishLoadingWithInfo:dic];
    }
    
    [self _cleanCatchedData];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(request:didFailedLoadingWithError:)]) {
        [self.delegate request:self didFailedLoadingWithError:error];
    }
    [self _cleanCatchedData];
}

@end
