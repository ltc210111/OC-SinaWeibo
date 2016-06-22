//
//  NewBlogViewController.m
//  weibo
//
//  Created by lotic on 16/6/14.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "NewBlogViewController.h"
#import "View+MASAdditions.h"
#import "MainViewTableViewController.h"
#import "JLPhotoBrowerViewController.h"
#import "JKImagePickerController.h"
#import "NewBlogPicCell.h"

@interface NewBlogViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,JKImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *editFile;

//照片选择
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosCollectionViewHeightContrains;
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *picCollectionV;

@property (weak, nonatomic) IBOutlet UIView *toolsV;

@end

@implementation NewBlogViewController

-(void)viewDidLoad {
    [self hideKeyBoard];
    
    self.picCollectionV.backgroundColor = [UIColor clearColor];
    self.picCollectionV.delegate = self;
    self.picCollectionV.dataSource = self;
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [self hideKeyBoard];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    //keyboard键盘方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard) name:UIKeyboardDidHideNotification object:nil];
    [self.editFile becomeFirstResponder];
}
#pragma mark - keyboard
//keyboard键盘出现
-(void)willShowKeyBoard:(NSNotification *)noti{
    CGFloat keyBoardHeight = [[[noti userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
    [self.toolsV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-keyBoardHeight));
    }];
    [UIView animateWithDuration:0.1f
                     animations:^{
                         [self.navigationController.view layoutIfNeeded]; // Called on parent view
                     }];
}
//keyboard键盘收回
-(void)hideKeyBoard{
    [self.editFile resignFirstResponder];
    [UIView animateWithDuration:0.1f animations:^{
        [self.toolsV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.height.equalTo(@40);
            make.width.equalTo(@(SCREENWIDTH));
        }];
    }completion:^(BOOL finished) {
        
    }];
    self.inputView.hidden = YES;
}

#pragma mark - action
- (IBAction)cancelAct:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
    MainViewTableViewController *userM = (MainViewTableViewController *)[sb instantiateViewControllerWithIdentifier:@"MainVIewCV"];
//    [self.navigationController pushViewController:userM animated:YES];
    [self.navigationController.tabBarController setSelectedIndex:0];
    [self.editFile resignFirstResponder];
}

- (IBAction)sendAct:(id)sender {
    [self upNews];
}

- (IBAction)act:(id)sender {
    [self.editFile resignFirstResponder];
}

- (IBAction)delPhoto:(UIButton *)sender {
    [self.photosArray removeObjectAtIndex:sender.tag - 1000];
    [self.assetsArray removeObjectAtIndex:sender.tag - 1000];
    [_picCollectionV reloadData];
    _photosCollectionViewHeightContrains.constant = [_picCollectionV.collectionViewLayout collectionViewContentSize].height;
}

- (IBAction)addPhoto:(id)sender {
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 0;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    navigationController.navigationBar.barTintColor = [UIColor colorWithRed:69.f/255.0f green:68.f/255.0f blue:73.f/255.0f alpha:1.0f];
    navigationController.navigationBar.translucent = NO;
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - Collection View Delegate DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewBlogPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewBlogPicCell" forIndexPath:indexPath];
    if (self.photosArray.count == 0 || indexPath.row == self.photosArray.count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
    }
    else {
        [cell.cellPic setImage:self.photosArray[indexPath.row]];
        cell.cellDelBtn.tag = 1000+indexPath.row;
    }
    return cell;
}

#pragma mark - <JKImagePickerControllerDelegate>
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source {
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    NSMutableArray *photosArray = [NSMutableArray new];
    for (JKAssets* asset in self.assetsArray) {
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                [photosArray addObject:image];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
    self.photosArray = photosArray;
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [_picCollectionV reloadData];
        _photosCollectionViewHeightContrains.constant = [_picCollectionV.collectionViewLayout collectionViewContentSize].height;
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - lazyLoad
- (NSMutableArray *)photosArray {
    if (!_photosArray) {
        _photosArray = [NSMutableArray new];
    }
    return _photosArray;
}

#pragma mark - netWork
-(void)upNews {
    NSString *status = [self.editFile.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",status);
}
@end
