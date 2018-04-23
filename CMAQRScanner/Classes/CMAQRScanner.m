//
//  CMAQRScanner.m
//  CMAQRScaner
//
//  Created by comma on 2018/05/20.
//

#import "CMAQRScanner.h"

@interface CMAQRScanner ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoDataOutput   *videoDataOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (strong, nonatomic) AVCaptureDeviceInput       *deviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput    *metadataOutput;

@end

@implementation CMAQRScanner

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
    self.session             = [[AVCaptureSession alloc] init];
    self.videoDataOutput     = [[AVCaptureVideoDataOutput alloc] init];
    self.videoPreviewLayer   = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.deviceInput         = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
    self.metadataOutput      = [[AVCaptureMetadataOutput alloc] init];
    self.rectOfInterest      = CGRectMake(0, 0, 1, 1);
    self.sessionPreset       = AVCaptureSessionPreset1920x1080;
    self.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
}

#pragma mark - - - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count < 1) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanner:didOutputMetadataObjects:)]) {
        [self.delegate scanner:self didOutputMetadataObjects:metadataObjects];
    }
}

#pragma mark - - - AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // 这个方法会时时调用，但内存很稳定
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];

    if (self.delegate && [self.delegate respondsToSelector:@selector(scanner:brightnessValue:)]) {
        [self.delegate scanner:self brightnessValue:brightnessValue];
    }
}

- (void)startScanning {
    if (self.isScanning) {
        [self stopScanning];
    }
    [self reloadConfig];
    [self.session startRunning];
    _isScanning = YES;
}

- (void)stopScanning {
    [self.session stopRunning];
    _isScanning = NO;
}

- (void)reloadConfig {

    [self.session removeInput:self.deviceInput];
    [self.session removeOutput:self.metadataOutput];
    [self.session removeOutput:self.videoDataOutput];
    
    [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.metadataOutput.rectOfInterest = self.rectOfInterest;

    [self.videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.session.sessionPreset = self.sessionPreset;
    
    [self.session addOutput:self.metadataOutput];
    [self.session addOutput:self.videoDataOutput];
    [self.session addInput:self.deviceInput];
    
    self.metadataOutput.metadataObjectTypes = self.metadataObjectTypes?self.metadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
}

#pragma mark - getter && setter
- (AVCaptureVideoPreviewLayer *)cameraPreviewLayer {
    return self.videoPreviewLayer;
}

@end
