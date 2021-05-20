//  ViewController.m
//  
//  Created by ___ORGANIZATIONNAME___ on 2021/1/18
//  
//
//
//                    ██████╗ ██╗  ██╗     ██╗ ██████╗ ███╗   ██╗███████╗
//                    ██╔══██╗██║ ██╔╝     ██║██╔═══██╗████╗  ██║██╔════╝
//                    ██║  ██║█████╔╝      ██║██║   ██║██╔██╗ ██║█████╗
//                    ██║  ██║██╔═██╗ ██   ██║██║   ██║██║╚██╗██║██╔══╝
//                    ██████╔╝██║  ██╗╚█████╔╝╚██████╔╝██║ ╚████║███████╗
//                    ╚═════╝ ╚═╝  ╚═╝ ╚════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝
//
//

#import "DKLaunchViewController.h"
#import "DKHelper.h"
#import <AVFoundation/AVFoundation.h>
@interface DKLaunchViewController ()<HWDMP4PlayDelegate>
@property (nonatomic,strong)AVAudioPlayer * player;
@property (nonatomic,strong)UIView *controlView;
@property (nonatomic,strong)UIView *animaView;
@property (nonatomic,assign)int animaIndex ;
@property (nonatomic,assign)BOOL hasNext ;
/// 点击跳过动画，已切换到下个视图
@property (nonatomic,assign)BOOL hasExit ;
@property (nonatomic,strong)UILabel *textLabel;
@end

@implementation DKLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.animaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width *16/9)];
    self.animaView.center = self.view.center;
    [self.view addSubview:self.animaView];
    self.view.backgroundColor = UIColor.blackColor;
    [self.navigationController.navigationBar setHidden:true];

    if (self.setType !=0 ){
        NSString* path = [NSString stringWithFormat:@"/Library/Application Support/dkhelper/vapFiles/launchBgm.mp3"];
        if (![NSFileManager.defaultManager fileExistsAtPath:path]){
            path = [NSBundle.mainBundle pathForResource:@"launchBgm" ofType:@"mp3"];
        }
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        [self.player play];
        [self.player setNumberOfLoops:100];

        self.controlView = [[UIView alloc] initWithFrame:self.view.frame];
        self.controlView.backgroundColor = UIColor.clearColor;
        [self.view addSubview:self.controlView];

        UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
        exitBtn.frame = CGRectMake(15, 80, 80, 40);
        [exitBtn addTarget:self action:@selector(exitVC) forControlEvents:UIControlEventTouchUpInside];
        [self.controlView addSubview:exitBtn];

        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setTitle:@"右滑下一个" forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        nextBtn.frame = CGRectMake( UIScreen.mainScreen.bounds.size.width -  100, 80, 80, 40);
        [nextBtn addTarget:self action:@selector(nextAnima:) forControlEvents:UIControlEventTouchUpInside];
        [self.controlView addSubview:nextBtn];

        UIButton *setDoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [setDoneBtn setTitle:(self.setType==1 ? @"设为启动图" : @"设为聊天背景") forState:UIControlStateNormal];
        setDoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        setDoneBtn.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width -  120, UIScreen.mainScreen.bounds.size.height -  100, 100, 40);
        [setDoneBtn addTarget:self action:@selector(setLaunch) forControlEvents:UIControlEventTouchUpInside];
        [self.controlView addSubview:setDoneBtn];
        UIPanGestureRecognizer *swip = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(nextAnima:)];
        [self.view addGestureRecognizer:swip];

        UILabel * label = [[UILabel alloc] init];
        self.textLabel = label;
        label.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height/3*2,  UIScreen.mainScreen.bounds.size.width, 70);
        [self.view addSubview:label];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
    }
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showControl)]];
    self.animaIndex = self.setType == 2 ? (DKHelperConfig.dkChatBGIndex.intValue - 1) : (DKHelperConfig.dkLaunchIndex.intValue - 1);
    [self nextAnima:nil];

}

- (void)exitVC{
    [self.navigationController popViewControllerAnimated:true];
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)showControl{
    if (self.setType == 0){
        [self goNextVC];
        self.hasExit = true;
    }
    [UIView animateWithDuration:0.25 animations:^{
        int alpha = ceil(self.controlView.alpha);
        self.controlView.alpha = (alpha + 1) % 2;
    }];
}

- (void)nextAnima:(NSObject *) gest{
    self.hasNext = false;

    BOOL isNext = true;
    if ([gest isKindOfClass:UIPanGestureRecognizer.class]){
        UIPanGestureRecognizer *recog = (UIPanGestureRecognizer *)gest;
        if (recog.state != UIGestureRecognizerStateEnded){return;}
        CGPoint trans = [recog translationInView:recog.view];
        if (trans.x > 0 ){
            isNext = false;
        }else {
            isNext = true;
        }

    }
    self.animaIndex += (isNext? 1 : -1);
    self.animaIndex = self.animaIndex > 0 ? self.animaIndex : 0;
    self.animaIndex = self.animaIndex % 13;
    NSString *animaName = DKLaunchHelper.animaNames[self.animaIndex][@"name"];
    NSString *text = DKLaunchHelper.animaNames[self.animaIndex][@"desc"];
    self.textLabel.text = [NSString stringWithFormat:@"%@\n%@",text,animaName];
    self.textLabel.textColor = DKLaunchHelper.animaNames[self.animaIndex][@"color"];

    NSString* path = [NSString stringWithFormat:@"/Library/Application Support/dkhelper/vapFiles/%@",[NSString stringWithFormat:@"%@Vap.mp4", animaName]];
    if (![NSFileManager.defaultManager fileExistsAtPath:path]){
        path = [NSBundle.mainBundle pathForResource:[NSString stringWithFormat:@"%@Vap", animaName] ofType:@"mp4"];
    }
    [self.animaView playHWDMP4:path repeatCount:0 delegate:self];
    self.hasNext = true;

}

- (void)setLaunch{
    NSString *text = DKLaunchHelper.animaNames[self.animaIndex][@"desc"];
    if (self.setType == 2){
        //设为聊天背景
        DKHelperConfig.dkChatBGIndex = [NSNumber numberWithInt:self.animaIndex];
        [DKHelper showAlertWithTitle:@"已设置聊天背景为" message:text btnTitle:@"确定" handler:^(UIButton *sender) {}];
        return;
    }
    NSString *animaName = DKLaunchHelper.animaNames[self.animaIndex][@"name"];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:self.animaView.frame];

    NSString* path = [NSString stringWithFormat:@"/Library/Application Support/dkhelper/vapFiles/%@",[NSString stringWithFormat:@"%@.jpg", animaName]];
    if (![NSFileManager.defaultManager fileExistsAtPath:path]){
        path = [NSBundle.mainBundle pathForResource:animaName ofType:@"jpg"];
    }
    imgv.image =  [[UIImage alloc] initWithContentsOfFile:path];
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = UIColor.blackColor;
    bgView.clipsToBounds = true;
    [bgView addSubview:imgv];
    [LaunchImageHelper changeAllLaunchImageToPortrait:bgView.dkScreenShoot];
    DKHelperConfig.dkLaunchIndex = [NSNumber numberWithInt:self.animaIndex];
    [NSUserDefaults.standardUserDefaults synchronize];
    [DKHelper showAlertWithTitle:@"已设置启动图为" message:text btnTitle:@"确定" handler:^(UIButton *sender) {}];
}

-(void)viewDidStopPlayMP4:(NSInteger)lastFrameIndex view:(VAPView *)container{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.setType == 0){
            if (self.hasExit){return;}
            [self goNextVC];
            return;
        }
        if (self.hasNext){
            [self nextAnima:nil];
        }
    });
}

-(void)goNextVC{
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    window.rootViewController = nil;
    [UIApplication.sharedApplication.keyWindow setHidden:true];
    [UIApplication.sharedApplication.keyWindow makeKeyAndVisible];
}

@end


