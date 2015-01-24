//
//  DUTableViewController.m
//  DUCache
//
//  Created by Essam on 1/24/15.
//  Copyright (c) 2015 Essam. All rights reserved.
//

#import "DUTableViewController.h"
#import <DUCache.h>

@interface DUTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) NSInteger cellsCount;
@property (nonatomic) NSArray *urls;

@end

@implementation DUTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DUCacheOperation *operation = [[DUCache defaultCache] objectForUrl:[NSURL URLWithString: @"http://freesoftwarekit.com/server13/photos/zebQQrYkCm2g7M~/178443_Beautiful-Bird-Color-Cute-wallpapers_2560x1600.jpg"]
                                                     completionHandler:^(DUOperationResult result, UIImage *data) {
                                                         self.imageView.image = data;
                                                     }];
    [operation cancel];
    
    self.cellsCount = 5;
    self.urls = @[[NSURL URLWithString:@"http://wallpoper.com/images/00/40/99/05/nature-birds_00409905.jpg"],
                  [NSURL URLWithString:@"http://freesoftwarekit.com/server13/photos/zebQQrYkCm2g7M~/178443_Beautiful-Bird-Color-Cute-wallpapers_2560x1600.jpg"],
                  [NSURL URLWithString:@"http://www.hdwallpapersinn.com/wp-content/uploads/2014/07/birds-wallpapers-vented-bulbul-light-gorgeous-cute-animal-little-wallpaper-array-wallwuzz-hd-wallpaper-3602.jpg"],
                  [NSURL URLWithString:@"http://wallpoper.com/images/00/40/99/05/nature-birds_00409905.jpg"]];
}

- (IBAction)randomize {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
    
    [[DUCache defaultCache] objectForUrl:[NSURL URLWithString:@"http://ip.jsontest.com/"]
                       completionHandler:^(DUOperationResult result, NSDictionary *data) {
                           cell.textLabel.text = data[@"ip"];
                           [cell setNeedsLayout];
                       }];
    
    [[DUCache defaultCache] objectForUrl:self.urls[arc4random() % self.urls.count]
                       completionHandler:^(DUOperationResult result, UIImage *data) {
                           cell.imageView.image = data;
                           [cell setNeedsLayout];
                       }];


    return cell;
}

@end
