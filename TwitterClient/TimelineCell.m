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
    }
    
    return self;
}

@end
