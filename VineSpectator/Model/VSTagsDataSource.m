//
//  VSTagsDataSource.m
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSTagsDataSource.h"
#import "VSTagCollectionViewCell.h"

// I want this to be the only class that can access all of the bottles

@interface VSTagsDataSource ()

@property VSBottleDataSource *bottleDataSource;
@property (nonatomic) NSString *bottleID;
@property (nonatomic) NSMutableArray *localTags;
@property (nonatomic) NSMutableArray *userTags;

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
    [[PFUser currentUser] saveInBackground];
}

- (NSMutableArray *)allTags
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:@[@"Search", @"Chrono"]];
    [array addObjectsFromArray:self.userTags];
    return array;
}

# pragma mark - Public Methods
- (void)removeTag:(NSString *)tag
{
    [self.localTags removeObject:tag];
}

- (void)addTag:(NSString *)tag
{
    [self.localTags addObject:tag];
}

- (void)saveTags
{
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    bottle.tags = self.localTags;
    [bottle save];
}

# pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.userTags.count;
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

- (NSString *)textForIndex:(NSInteger)index
{
    return self.userTags[index];
}

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath
{
    return self.userTags[indexPath.row];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VSTagCollectionViewCell *cell = (VSTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    NSString *tag = self.userTags[indexPath.row];
    cell.tag = tag;
    if ([self.localTags containsObject:tag]) {
        [cell setSelected:YES];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

# pragma mark - VSStackViewDataSource

- (NSInteger)numberOfViewsInStack
{
    return [self allTags].count;
}

- (UIView *)viewForIndex:(NSInteger)index
{
    UIView *view;
    view.backgroundColor = [UIColor lightSalmonColor];
    
    if (index == 0) {
//        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 73, 50) ];
//        [view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]]];
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    } else if (index == 1) {
//        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 73, 50) ];
//        [view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chrono"]]];
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chrono"]];
    } else {
        //view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 50) ];
        
        UILabel *tagLabel = [UILabel new];
        tagLabel.font = [UIFont fontWithName:@"Athelas-Regular" size:20];
        if (index % 2) {
            tagLabel.textColor = [UIColor wineColor];
        } else {
            tagLabel.textColor = [UIColor goldColor];
        }
        [tagLabel sizeToFit];
//        tagLabel.adjustsFontSizeToFitWidth = YES;
        NSString *text = [self textForIndex:index-2];
        tagLabel.text = text;
        return tagLabel;
        //[view addSubview:tagLabel];
        
//        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make){
//            make.center.equalTo(view);
//        }];
    }
    
    //    [tagLabel sizeToFit];
    //     CGSize size = [text sizeWithAttributes:@{@"NSFontAttributeName": [UIFont fontWithName:@"Athelas-Regular" size:20]}];
    //    NSString *text = [self.tagsDataSource textForIndexPath:indexPath];
    //    CGSize size = [text sizeWithAttributes:@{@"NSFontAttributeName": [UIFont fontWithName:@"YuMin-Medium" size:15.0]}];
    //    size.height += 10;
    //    size.width += 30;
    //    return size;
    return view;
}

@end
