//
//  TimelineCell.m
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "TimelineCell.h"

@implementation TimelineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (TimelineCell *)updateViews {
    if(self.tweet) {
        self.userNameLabel.text = self.tweet[@"user"][@"name"];
        self.userScreenNameLabel.text = [[NSString alloc] initWithFormat:@"@%@", self.tweet[@"user"][@"screen_name"]];
        self.tweetLabel.text = self.tweet[@"text"];
        self.timeLabel.text = [TimeFormatter getTimeIntervalString:self.tweet[@"created_at"]];
        
        NSURL *userImgURL = [NSURL URLWithString:self.tweet[@"user"][@"profile_image_url"]];
        [self.userImageView setImageWithURL:userImgURL];
        
        // change the star image if the tweet is favorited
        NSInteger favorited = [(NSNumber *)self.tweet[@"favorited"] integerValue];
        if(favorited == 0) {
            [self.favoriteButton setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        }
        else {
            [self.favoriteButton setImage:[UIImage imageNamed:@"solid_star.png"] forState:UIControlStateNormal];
        }
    }
    
    return self;
}

- (IBAction)onReplyButton:(id)sender {
    NSLog(@"on reply");
}

- (IBAction)onRetweetButton:(id)sender {
    [[TwitterAPI instance] postRetweet:self.tweet[@"id_str"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Retweet" message:@"Success!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to Retweet. Error:%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Retweet" message:@"Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)onFavoriteButton:(id)sender {
    NSInteger favorited = [(NSNumber *)self.tweet[@"favorited"] integerValue];
    if(favorited == 0) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"solid_star.png"] forState:UIControlStateNormal];
        
        [[TwitterAPI instance] postFavorite:self.tweet[@"id_str"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to favorite. Error: %@", error);
        }];
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        
        [[TwitterAPI instance] postRemoveFavorite:self.tweet[@"id_str"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to remove favorite. Error:%@", error);
        }];
    }
}


@end
