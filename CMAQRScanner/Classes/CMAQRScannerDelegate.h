//
//  CMAQRScannerDelegate.h
//  CMAQRScaner
//
//  Created by comma on 2018/05/20.
//

#import <Foundation/Foundation.h>

@class CMAQRScanner;

@protocol CMAQRScannerDelegate <NSObject>

@required

/**
 输出实时摄像头预览

 @param scanner 二维码扫码器
 @param metadataObjects 二维码的数据信息
 */
- (void)scanner:(CMAQRScanner *)scanner didOutputMetadataObjects:(NSArray *)metadataObjects;

@optional

/**
 输出光线强弱值

 @param scanner 二维码扫码器
 @param brightnessValue 光线强弱值
 */
- (void)scanner:(CMAQRScanner *)scanner brightnessValue:(CGFloat)brightnessValue;

@end
