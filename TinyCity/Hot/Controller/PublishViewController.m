//
//  PublishViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "PublishViewController.h"
#import "UserInfoModel.h"
#import "UserLocation.h"
#import "CommentModel.h"

@interface PublishViewController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, strong) UITextView *textV;
@property (nonatomic, strong) UIImageView *imagev;
@property (nonatomic, strong) NSData *currentData;
@property (nonatomic, strong) UserLocation *userLocation;
@property (nonatomic, copy) NSString *locationAddress;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UILabel *locationLabel;
@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发表文字";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:(UIBarButtonItemStylePlain) target:self action:@selector(publish)];
    [self loadPublishView];
    _progress = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    _progress.frame = CGRectMake(50, 150, self.view.width - 100, 30);
    _progress.progressTintColor = PLRandomColor;
    _progress.hidden = YES;
    [self.view addSubview:_progress];
}
#pragma mark -- 获取当前位置
-(void)loadLocationService{
    
    UserLocation *userLocation = [UserLocation shareInstance];
    [userLocation startLocationService];
    self.userLocation = userLocation;
    __weak typeof(self)weakSelf = self;
    self.userLocation.block = ^(CLLocationCoordinate2D location,NSString *address){
        NSLog(@"%f%f%@",location.longitude,location.latitude,address);
        weakSelf.locationAddress = address;
        [weakSelf.locationLabel setText:address];
    };
    
}

#pragma mark 发表动态
- (void)publish
{
    _progress.hidden = NO;
    NSLog(@"开始发表");
    AVUser *user = [AVUser currentUser];
    UserInfoModel *model = [[UserInfoModel alloc] init];
    model.textInfo = self.textV.text;
    model.userIcon = @"image";
    model.userName = user.username;
    model.praise_num = @"0";
    model.relay_num = @"0";
    model.location = _locationAddress;
    CommentModel *mode = [[CommentModel alloc] init];
    mode.reviewers = @"";
    mode.byReviewers = @"";
    mode.thumbsUp = [NSMutableArray array];
    mode.commentContent = [NSMutableArray array];
    model.model = mode;
    if (_currentData != nil) {
        AVFile *file = [AVFile fileWithData:_currentData];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
//                PLLog(@"%@",error);
            }
        } progressBlock:^(NSInteger percentDone) {
            [_progress setProgress:percentDone animated:YES];
        }];
        model.file = file;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    model.create_time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];;
    [model saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    if (self.delegate && [_delegate respondsToSelector:@selector(passValueInModel:)]) {
        [_delegate passValueInModel:model];
    }
}
#pragma mark -- 加载发表页面
- (void)loadPublishView
{
    UITextView *textV = [[UITextView alloc] init];
    textV.x = 0;
    textV.y = 0;
    textV.width = self.view.width;
    textV.height = self.view.height*2/3 - 60;
    textV.delegate = self;
    [self.view addSubview:textV];
    textV.font = [UIFont systemFontOfSize:17];
    self.textV = textV;
    
    UILabel *field = [[UILabel alloc] init];
    field.text = @"请输入...";
    field.font = [UIFont systemFontOfSize:15];
    field.x = 5;
    field.y = 0;
    field.width = self.view.width/3;
    field.adjustsFontSizeToFitWidth = YES;
    field.height = 35;
    [textV addSubview:field];
    self.placeholder = field;
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.y = textV.height - 60;
    button.height = 60;
    button.width = 60;
    button.x = 0;
    [button setImage:[UIImage imageNamed:@"iconfont-tianjia"] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(addImage:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    UIImageView *imagev = [[UIImageView alloc] init];
    imagev.frame = CGRectMake(10, CGRectGetMaxY(button.frame) + 10, (self.view.width - 20)/2, (self.view.width - 20)/2);
    imagev.backgroundColor = PLRandomColor;
    [imagev.image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    imagev.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imagev];
    self.imagev = imagev;
    
    UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imagev.frame)+10, imagev.y, self.view.width/4, 30)];
    textL.text = @"当前位置：";
    textL.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:textL];
    
    UISwitch *switchUI = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textL.frame)+10, imagev.y, self.view.width - CGRectGetMaxX(textL.frame) - 10, 30)];
    [switchUI setOn:NO animated:YES];
    [switchUI addTarget:self action:@selector(addLocation:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:switchUI];
    
    UILabel *locationL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(textL.frame), CGRectGetMaxY(textL.frame) + 10, self.view.width/2 - 20, 50)];
    locationL.numberOfLines = 0;
    [self.view addSubview:locationL];
    self.locationLabel = locationL;
}

#pragma mark -- UISwitch方法
- (void)addLocation:(UISwitch *)swith
{
    if (swith.isOn) {
        [self loadLocationService];
    }else{
        _locationLabel.text = @"";
    }
}

#pragma mark -- UITextViewDelegate代理
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placeholder.hidden = NO;
    }else{
        _placeholder.hidden = YES;
    }
}

- (void)addImage:(UIButton *)sender
{
    [self pickImage];
}
-(void)pickImage {
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置图像选取控制器的类型为静态图像
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    //允许用户进行编辑
    imagePickerController.allowsEditing = YES;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
#pragma mark --UIImagePickerControllerDelegate代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //打印出字典中的内容
    NSLog(@"get the media info: %@", info);
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //获取用户编辑之后的图像
        UIImage* editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //将该图像保存到媒体库中
//        UIImageWriteToSavedPhotosAlbum(editedImage, self, nil, NULL);
        //        UIImageWriteToSavedPhotosAlbum(editedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//        self.dataArray = [NSMutableArray arrayWithObject:editedImage];
//        [NSKeyedArchiver archiveRootObject:editedImage toFile:_imagePath];
        _currentData = [NSData data];
        NSData *data = UIImagePNGRepresentation(editedImage);
        _currentData = data;
        [_imagev setImage:editedImage];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    NSLog(@"销毁了");
}

@end
