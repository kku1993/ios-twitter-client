//
//  TwitterAPI.h
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterAPI : BDBOAuth1RequestOperationManager

+ (TwitterAPI *)instance;

- (void)login;
- (void)logout;
- (BOOL)isLoggedIn;
- (AFHTTPRequestOperation *)getHomeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)getTweetDetail:(NSString*)tweetID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
