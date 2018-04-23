//
//  CMAViewController.m
//  CMAQRScanner
//
//  Created by comma on 04/23/2018.
//  Copyright (c) 2018 comma. All rights reserved.
//

#import "CMAViewController.h"

@import CMAQRScanner;

@interface CMAViewController ()<CMAQRScannerDelegate>

@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet CMAQRScanView *scanView;

@property (strong, nonatomic) CMAQRScanner *scanner;

@end

@implementation CMAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestAccess];
}

- (void)requestAccess {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"未检测到您的摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        //从未授权过
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (granted) {
                    // 用户同意了访问相机权限
                    [self startQRCodeScanning];
                } else {
                    // 用户拒绝了访问相机权限
                }
            });
        }];
        return;
    }
    
    if (status == AVAuthorizationStatusAuthorized) {
        // 用户允许当前应用访问相机
        [self startQRCodeScanning];
        
        return;
    }
    
    if (status == AVAuthorizationStatusDenied) {
        // 用户拒绝当前应用访问相机
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"未打开相机权限----请在\"设置-隐私-相机\"选项中，允许访问您的相机" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
}

- (void)startQRCodeScanning {
    if (!self.scanner) {
        self.scanner = [[CMAQRScanner alloc] init];
        self.scanner.delegate = self;
    }
    [self.cameraPreviewView.layer addSublayer:self.scanner.cameraPreviewLayer];
    self.scanner.cameraPreviewLayer.frame = self.cameraPreviewView.bounds;
    [self.scanner startScanning];
    
    [self.scanView beginAnimate];
}

- (IBAction)didPressedButton:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"边框颜色"]) {
        if (CGColorEqualToColor(self.scanView.cornerColor.CGColor, [UIColor colorWithRed:85/255.0f green:183/255.0 blue:55/255.0 alpha:1.0].CGColor)) {
            self.scanView.cornerColor = [UIColor redColor];
        }else {
            self.scanView.cornerColor = [UIColor colorWithRed:85/255.0f green:183/255.0 blue:55/255.0 alpha:1.0];
        }
        return;
    }
    if ([sender.currentTitle isEqualToString:@"边框区域"]) {
        if (CGSizeEqualToSize(self.scanView.scanAreaSize, CGSizeMake(100, 100))) {
            CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            self.scanView.scanAreaSize = CGSizeMake(0.6 * width,0.6 * width);
        }else{
            self.scanView.scanAreaSize = CGSizeMake(100, 100);
        }
        return;
    }
    if ([sender.currentTitle isEqualToString:@"边角位置"]) {
        if (self.scanView.cornerLocation == CornerLoactionDefault) {
            self.scanView.cornerLocation = CornerLoactionInside;
        }else if (self.scanView.cornerLocation == CornerLoactionInside) {
            self.scanView.cornerLocation = CornerLoactionOutside;
        }else if (self.scanView.cornerLocation == CornerLoactionOutside) {
            self.scanView.cornerLocation = CornerLoactionDefault;
        }
        return;
    }
    if ([sender.currentTitle isEqualToString:@"边角宽度"]) {
        if (self.scanView.cornerWidth == 2.0f) {
            self.scanView.cornerWidth = 4.0f;
        }else {
            self.scanView.cornerWidth = 2.0f;
        }
        return;
    }
    if ([sender.currentTitle isEqualToString:@"背景颜色"]) {
        self.scanView.backgroundAlpha = 1.0f - self.scanView.backgroundAlpha;
        return;
    }
}

#pragma mark - CMAQRScannerDelegate
- (void)scanner:(CMAQRScanner *)scanner didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"%@",metadataObjects.firstObject);
}

@end
