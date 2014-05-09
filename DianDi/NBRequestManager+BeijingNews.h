//
//  NBRequestManager+BeijingNews.h
//  NewsBeijingDemo
//
//  Created by Lori on 13-12-9.
//  Copyright (c) 2013年 Lori. All rights reserved.
//

#import "NBRequestManager.h"

@interface NBRequestManager (BeijingNews)

- (void) requestWithCid:(NSString *)cid startRecord:(NSString *)start length:(NSString *)length;

@end
