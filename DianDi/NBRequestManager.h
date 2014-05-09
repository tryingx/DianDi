//
//  NBRequestManager.h
//  NewsBeijingDemo
//
//  Created by Lori on 13-12-9.
//  Copyright (c) 2013年 Lori. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBRequestManager;

@protocol NBRequestDataDelegate <NSObject>
//(代理方法的嵌套) 默认是必须实现requried
- (void)request:(NBRequestManager *)request didFinishLoadingWithInfo:(id)info;
- (void)request:(NBRequestManager *)request didFailedLoadingWithError:(NSError *)error;

@end

@interface NBRequestManager : NSObject<NSURLConnectionDataDelegate>
{
    //参数字典
    NSMutableDictionary *paramsDic;
}

@property (nonatomic, assign)id<NBRequestDataDelegate> delegate;

+ (id)sharedRequest;
- (void)startRequestInfo:(NSString *)url;
-(void)URLRefresh:(NSInteger)startrecord;

@end
