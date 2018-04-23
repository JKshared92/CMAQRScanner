//
//  CMAQRScanView.h
//  CMAQRScaner
//
//  Created by comma on 2018/05/20.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CornerLoaction) {
    CornerLoactionDefault = 0,// 默认与边框线同中心点
    CornerLoactionInside  = 1,// 在边框线内部
    CornerLoactionOutside = 2,// 在边框线外部
};

@interface CMAQRScanView : UIView

/** 扫描线名 */
@property (copy, nonatomic) NSString *scanningImageName;

/** 边框颜色，默认白色 */
@property (strong, nonatomic) UIColor *borderColor;

/** 扫码框的大小，默认屏幕宽度的0.7倍 */
@property (assign, nonatomic) CGSize  scanAreaSize;

/** 边角位置，默认 CornerLoactionDefault */
@property (assign, nonatomic) CornerLoaction cornerLocation;

/** 边角颜色，默认微信颜色 */
@property (strong, nonatomic) UIColor *cornerColor;

/** 边角宽度，默认 2.0f */
@property (assign, nonatomic) CGFloat cornerWidth;

/** 扫描区周边颜色的 alpha 值，默认 0.7f */
@property (assign, nonatomic) CGFloat backgroundAlpha;

/** 扫描线动画时间，默认 0.02 */
@property (assign, nonatomic) NSTimeInterval animationTimeInterval;

/** 是否正在执行扫描动画 */
@property (assign, nonatomic, readonly) BOOL isAnimating;

/** 开启扫描动画 */
- (void)beginAnimate;

/** 停止扫描动画 */
- (void)stopAnimate;

@end
