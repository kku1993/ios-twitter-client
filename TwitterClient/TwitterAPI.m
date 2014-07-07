//
//  TwitterAPI.m
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "TwitterAPI.h"

@implementation TwitterAPI

+ (TwitterAPI *)instance {
    static dispatch_once_t onceToken;
    static TwitterAPI *instance = nil;
    static NSDictionary *config = nil;
    
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
        config = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        instance = [[TwitterAPI alloc] initWithBaseURL:[NSURL URLWithString:config[@"twitter_url"]] consumerKey:config[@"twitter_api_key"] consumerSecret:config[@"twitter_api_secret"]];
    });
    
    return instance;
}

- (void)login {
    [self
        fetchRequestTokenWithPath:@"oauth/request_token"
        method:@"POST"
        callbackURL:[NSURL URLWithString:@"ktwitter://oauth"]
        scope:nil
        success:^(BDBOAuthToken *requestToken){
            NSLog(@"request token: %@", requestToken);
            
            NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        }
        failure:^(NSError *err) {
            NSLog(@"%@", err);
        }
    ];
}

- (void)logout {
    [self.requestSerializer removeAccessToken];
}

- (BOOL)isLoggedIn {
    return [self.requestSerializer accessToken] != nil;
}

- (AFHTTPRequestOperation *)getHomeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)getTweetDetail:(NSString*)tweetID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *path = [[NSString alloc] initWithFormat:@"1.1/statuses/home_timeline.json?id=%@", tweetID];
    return [self GET:path parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)getUserDetailWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)postNewTweet:(NSString *)tweet success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *params = @{@"status": tweet};
    return [self POST:@"1.1/statuses/update.json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)postFavorite:(NSString *)tweetID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *params = @{@"id": tweetID};
    return [self POST:@"1.1/favorites/create.json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)postRemoveFavorite:(NSString *)tweetID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *params = @{@"id": tweetID};
    return [self POST:@"1.1/favorites/destroy.json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)postRetweet:(NSString *)tweetID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *path = [[NSString alloc] initWithFormat:@"1.1/statuses/retweet/%@.json", tweetID];
    return [self POST:path parameters:nil success:success failure:failure];

}

@end
