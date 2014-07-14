//
//  MenuViewController.m
//  TwitterClient
//
//  Created by Kevin Ku on 7/13/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isShowing = false;
        
        self.options = [[NSArray alloc] initWithObjects:@"Profile", @"Timeline", @"Mentions", @"Logout", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.optionsTableView.delegate = self;
    self.optionsTableView.dataSource = self;
    
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    if(self.userData) {
        NSURL *userImgURL = [NSURL URLWithString:self.userData[@"profile_image_url"]];
        [self.userImageView setImageWithURL:userImgURL];
        
        self.userNameLabel.text = self.userData[@"name"];
        self.userScreenNameLabel.text = [[NSString alloc] initWithFormat:@"@%@", self.userData[@"screen_name"]];
    }
}

- (void) getUserInfo {
    [[TwitterAPI instance] getUserDetailWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.userData = responseObject;
        
        [self initViews];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get user information. Error: %@", error);
    }];
}

// table view functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.optionsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // open tweet detail view
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:indexPath, @"IndexPath", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuOptionSelectedNotification" object:self userInfo:userInfo];
}

@end
