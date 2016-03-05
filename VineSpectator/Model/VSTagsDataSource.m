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
    [array addObjectsFromArray:@[@"Search", @"Chrono"]];
    [array addObjectsFromArray:self.userTags];
    return array;
}

// UI Test: Add a Tag, tag a bottle, delete the tag, edit the bottle, put the tag back..
# pragma mark - Public Methods
- (void)addTag:(NSString *)tag
{
    [self.localTags addObject:tag];
}

- (void)removeTag:(NSString *)tag
{
    [self.localTags removeObject:tag];
}

- (void)saveTags
{
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    bottle.tags = self.localTags;
    [bottle save];
}

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath
{
    return self.userTags[indexPath.row];
}

- (NSString *)textForStackIndex:(NSInteger)stackIndex
{
    switch (stackIndex) {
        case 0:
            return @"search";
        case 1:
            return @"chrono";
        default:
            return [self textForIndex:stackIndex-2];
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
    return [self allTags].count + 1;
}

- (UIButton *)viewForIndex:(NSInteger)index
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50,50)];
    button.backgroundColor = [UIColor lightSalmonColor];
    if (index == 0) {
        [button setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [button sizeToFit];
    } else if (index == 1) {
        [button setImage:[UIImage imageNamed:@"chrono"] forState:UIControlStateNormal];
        [button sizeToFit];
    }
    else {
        NSString *text;
        if (index == self.numberOfViewsInStack - 1) {
            text = @"+";
            button.titleLabel.font = [UIFont fontWithName:@"Athelas-Regular" size:40];
        } else {
            text = [self textForIndex:index-2];
            button.titleLabel.font = [UIFont fontWithName:@"Athelas-Regular" size:20];
        }
        [button setTitleColor:[UIColor wineColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor goldColor] forState:UIControlStateNormal];
        [button setTitle:text forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button.titleLabel sizeToFit];
        [button sizeToFit];
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
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    return bottle.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VSTagCollectionViewCell *cell = (VSTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    
    NSString *tag = bottle.tags[indexPath.row];
    cell.tag = tag;
    if ([self.localTags containsObject:tag]) {
        [cell setSelected:YES];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

@end
