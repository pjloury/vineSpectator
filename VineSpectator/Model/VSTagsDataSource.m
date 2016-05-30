//
//  VSTagsDataSource.m
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSTagsDataSource.h"
#import "VSTagCollectionViewCell.h"
#import "VSFilterView.h"

// I want this to be the only class that can access all of the bottles

@interface VSTagsDataSource ()

@property VSBottleDataSource *bottleDataSource;
@property (nonatomic) NSString *bottleID;
@property (nonatomic) NSMutableArray *localTags;
@end

@implementation VSTagsDataSource

@synthesize userTags = _userTags;

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource
{
    self = [super init];
    _bottleDataSource = bottleDataSource;
    return self;
}

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource bottleID:(NSString *)bottleID
{
    self = [super init];
    _bottleDataSource = bottleDataSource;
    _bottleID = bottleID;
    NSMutableArray *bottleTags = [[self.bottleDataSource bottleForID:self.bottleID].tags mutableCopy];
    if (!bottleTags) {
        _localTags = [NSMutableArray array];
    } else {
        _localTags = bottleTags;
    }
    return self;
}

- (NSArray *)userTags
{
    return [[PFUser currentUser] objectForKey:@"tags"];
}

- (void)setUserTags:(NSArray *)userTags
{
    _userTags = [userTags mutableCopy];
    [[PFUser currentUser] setObject:userTags forKey:@"tags"];
    [[PFUser currentUser] save];
}

- (NSMutableArray *)allTags
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:@[@"search", @"chrono", @"drank", @"red", @"white"]];
    [array addObjectsFromArray:self.userTags];
    return array;
}

// UI Test: Add a Tag, tag a bottle, delete the tag, edit the bottle, put the tag back..
# pragma mark - Public Methods
- (void)addTag:(NSString *)tag
{
    [self.localTags addObject:tag];
    [self saveTags];
}

- (void)removeTag:(NSString *)tag
{
    [self.localTags removeObject:tag];
    [self saveTags];
}

- (void)saveTags
{
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    bottle.tags = self.localTags;
    [bottle saveInBackground];
}

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath
{
    return self.userTags[indexPath.row];
}

- (NSString *)textForStackIndex:(NSInteger)stackIndex
{
    if (stackIndex < self.allTags.count) {
        return [self.allTags[stackIndex] capitalizedString];
    } else {
        return @"+";
    }
}

# pragma mark - private
- (NSString *)textForIndex:(NSInteger)index
{
    return self.userTags[index];
}


# pragma mark - VSStackViewDataSource
- (NSInteger)numberOfViewsInStack
{
    return [self allTags].count + 1; // Add 1 for the + button
}

- (UIButton *)viewForIndex:(NSInteger)index
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50,50)];
    button.backgroundColor = [UIColor lightSalmonColor];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (index == 0) {
        UIImage *image = [UIImage imageNamed:@"search"];
        UIImage *tintImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [button setImage:tintImage forState:UIControlStateNormal];
        button.tintColor = [UIColor goldColor];
        [button sizeToFit];
    } else if (index == 1) {
        UIImage *image = [UIImage imageNamed:@"chrono"];
        UIImage *tintImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [button setImage:tintImage forState:UIControlStateNormal];
        button.tintColor = [UIColor goldColor];
        [button sizeToFit];
    } else if (index == 2) {
        UIImage *image = [UIImage imageNamed:@"glass"];
        UIImage *tintImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [button setImage:tintImage forState:UIControlStateNormal];
        button.tintColor = [UIColor goldColor];
        [button sizeToFit];
    }
    else {
        NSString *text;
        // If the last object
        if (index == self.numberOfViewsInStack - 1) {
            text = @"+";
            button.titleLabel.font = [UIFont fontWithName:@"Athelas-Regular" size:40];
        } else {
            // text for index 2
            text = [self textForStackIndex:index];//[self textForIndeIndex:index-2];
            button.titleLabel.font = [UIFont fontWithName:@"Athelas-Regular" size:20];
        }
        
        [button setTitleColor:[UIColor wineColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor goldColor] forState:UIControlStateNormal];
        [button setTitle:text forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button.titleLabel sizeToFit];
        [button sizeToFit];
        
        if ([text isEqualToString:@"Red"]) {
            [button setTitleColor:[UIColor redInkColor] forState:UIControlStateNormal];
        }
    }
    
    NSInteger width = button.frame.size.width;
    button.adjustsImageWhenHighlighted = NO;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(width + 20);
        make.height.equalTo(50);
    }];
    
    return button;
}

# pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.userTags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VSTagCollectionViewCell *cell = (VSTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    
    NSString *tag = self.userTags[indexPath.row];
    cell.tag = tag;
    
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    NSLog(bottle.computedTags.description);
    
    if (bottle.computedTags.count > 0) {
        if ([self.localTags containsObject:tag]) {
            [cell setSelected:YES];
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    return cell;
}

@end
