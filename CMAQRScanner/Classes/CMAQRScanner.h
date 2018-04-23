//
//  CMAQRScanner.h
//  CMAQRScaner
//
//  Created by comma on 2018/05/20.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CMAQRScannerDelegate.h"

@interface CMAQRScanner : NSObject

/** 扫码结果的代理协议 */
@property (weak  , nonatomic, readwrite) id <CMAQRScannerDelegate> delegate;

/** 会话采集数据类型，默认为AVCaptureSessionPreset1920x1080 */
@property (copy  , nonatomic, readwrite) AVCaptureSessionPreset sessionPreset;

/** 扫码支持的编码格式，默认为AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code */
@property (strong, nonatomic, readwrite) NSArray<AVMetadataObjectType> *metadataObjectTypes;

/** 是否正在扫描 */
@property (assign, nonatomic, readonly ) BOOL isScanning;


/** 扫描范围（每一个取值0～1，以屏幕右上角为坐标原点） */
@property (assign, nonatomic, readwrite) CGRect rectOfInterest;


/** 显示实时摄像头预览的视图 */
@property (strong, nonatomic, readonly) AVCaptureVideoPreviewLayer *cameraPreviewLayer;

/** 重设配置，重设配置后会自动关闭扫描，如果需要，请自行重新打开 */
- (void)reloadConfig;

/** 开始扫描，并输出实时的摄像头预览视图 */
- (void)startScanning;

/** 停止扫描，并结束实时的摄像头预览视图 */
- (void)stopScanning;


@end
