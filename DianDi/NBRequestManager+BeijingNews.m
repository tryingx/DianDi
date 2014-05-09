//
//  NBRequestManager+BeijingNews.m
//  NewsBeijingDemo
//
//  Created by Lori on 13-12-9.
//  Copyright (c) 2013年 Lori. All rights reserved.
//

#import "NBRequestManager+BeijingNews.h"

@implementation NBRequestManager (BeijingNews)

- (void) requestWithCid:(NSString *)cid startRecord:(NSString *)start length:(NSString *)length
{
    if (!paramsDic) {
        paramsDic = [[NSMutableDictionary alloc] init];
    }
    
    [paramsDic setObject:cid forKey:@"cid"];
    [paramsDic setObject:start forKey:@"startRecord"];
    [paramsDic setObject:length forKey:@"len"];
    [paramsDic setObject:@"1234567890" forKey:@"udid"];
    
}

@end
