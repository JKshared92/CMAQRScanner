//
//  CMAQRScanView.m
//  CMAQRScaner
//
//  Created by comma on 2018/05/20.
//

#import "CMAQRScanView.h"
#import <MSWeakTimer/MSWeakTimer.h>

@interface CMAQRScanView ()

@property (strong, nonatomic) MSWeakTimer *timer;
@property (strong, nonatomic) UIImageView *scanningline;

@end;

@implementation CMAQRScanView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = [UIColor clearColor];
    _borderColor = [UIColor whiteColor];
    _cornerLocation = CornerLoactionDefault;
    _cornerColor = [UIColor colorWithRed:85/255.0f green:183/255.0 blue:55/255.0 alpha:1.0];
    _cornerWidth = 2.0;
    _backgroundAlpha = 0.7;
    _animationTimeInterval = 0.02;
    _scanningImageName = @"CMAQRScanner.bundle/CMAScanningLine";
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _scanAreaSize = CGSizeMake(0.7 * MIN(screenSize.width, screenSize.height), 0.7 * MIN(screenSize.width, screenSize.height));
    
    self.scanningline = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:NSClassFromString(@"CMAQRScanner")] pathForResource:self.scanningImageName ofType:@"png"]]];
    self.scanningline.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    /// 边框 frame
    CGFloat borderW = self.scanAreaSize.width;
    CGFloat borderH = self.scanAreaSize.height;
    CGFloat borderX = (rect.size.width  - borderW) / 2;
    CGFloat borderY = (rect.size.height - borderH) / 2;
    CGFloat borderLineW = 0.2;
    
    /// 空白区域设置
    [[[UIColor blackColor] colorWithAlphaComponent:self.backgroundAlpha] setFill];
    UIRectFill(rect);
    // 获取上下文，并设置混合模式 -> kCGBlendModeDestinationOut
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    // 设置空白区
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX + 0.5 * borderLineW, borderY + 0.5 *borderLineW, borderW - borderLineW, borderH - borderLineW)];
    [bezierPath fill];
    // 执行混合模式
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    /// 边框设置
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX, borderY, borderW, borderH)];
    borderPath.lineCapStyle = kCGLineCapButt;
    borderPath.lineWidth = borderLineW;
    [self.borderColor set];
    [borderPath stroke];
    
    
    CGFloat cornerLenght = 20;
    /// 左上角小图标
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    leftTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    CGFloat insideExcess = fabs(0.5 * (self.cornerWidth - borderLineW));
    CGFloat outsideExcess = 0.5 * (borderLineW + self.cornerWidth);
    if (self.cornerLocation == CornerLoactionInside) {
        [leftTopPath moveToPoint:CGPointMake(borderX + insideExcess, borderY + cornerLenght + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLenght + insideExcess, borderY + insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [leftTopPath moveToPoint:CGPointMake(borderX - outsideExcess, borderY + cornerLenght - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLenght - outsideExcess, borderY - outsideExcess)];
    } else {
        [leftTopPath moveToPoint:CGPointMake(borderX, borderY + cornerLenght)];
        [leftTopPath addLineToPoint:CGPointMake(borderX, borderY)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLenght, borderY)];
    }
    
    [leftTopPath stroke];
    
    /// 左下角小图标
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    leftBottomPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLenght + insideExcess, borderY + borderH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + borderH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + borderH - cornerLenght - insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLenght - outsideExcess, borderY + borderH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY + borderH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY + borderH - cornerLenght + outsideExcess)];
    } else {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLenght, borderY + borderH)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX, borderY + borderH)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX, borderY + borderH - cornerLenght)];
    }
    
    [leftBottomPath stroke];
    
    /// 右上角小图标
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    rightTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLenght - insideExcess, borderY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + cornerLenght + insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLenght + outsideExcess, borderY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + cornerLenght - outsideExcess)];
    } else {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLenght, borderY)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW, borderY)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW, borderY + cornerLenght)];
    }
    
    [rightTopPath stroke];
    
    /// 右下角小图标
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    rightBottomPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + borderH - cornerLenght - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + borderH - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLenght - insideExcess, borderY + borderH - insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + borderH - cornerLenght + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + borderH + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLenght + outsideExcess, borderY + borderH + outsideExcess)];
    } else {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW, borderY + borderH - cornerLenght)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW, borderY + borderH)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLenght, borderY + borderH)];
    }
    
    [rightBottomPath stroke];
}

/** 添加定时器 */
- (void)addTimer {
    if (self.isAnimating) {
        [self removeTimer];
    }
   
    [self addSubview:self.scanningline];
    self.scanningline.frame = CGRectMake((self.bounds.size.width - self.scanAreaSize.width) / 2, (self.bounds.size.height - self.scanAreaSize.height) / 2, self.scanAreaSize.width, 3);
    
    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:self.animationTimeInterval target:self selector:@selector(begenScan) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
}

/** 移除定时器 */
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.scanningline removeFromSuperview];
}

/** 定时执行刷新UI */
- (void)begenScan {
    __block CGRect frame = _scanningline.frame;
    static BOOL flag = YES;

    CGRect scanAreaFrame = CGRectMake((self.bounds.size.width - self.scanAreaSize.width) / 2, (self.bounds.size.height - self.scanAreaSize.height) / 2, self.scanAreaSize.width, self.scanAreaSize.height);
    
    if (flag) {
        frame.origin.y = scanAreaFrame.origin.y;
        flag = NO;
        [UIView animateWithDuration:self.animationTimeInterval animations:^{
            frame.origin.y += 2;
            self.scanningline.frame = frame;
        } completion:nil];
    } else {
        if (self.scanningline.frame.origin.y >= scanAreaFrame.origin.y) {
            CGFloat scanContent_MaxY = scanAreaFrame.origin.y + self.frame.size.width - 2 * scanAreaFrame.origin.x;
            if (self.scanningline.frame.origin.y >= scanContent_MaxY - 10) {
                frame.origin.y = scanAreaFrame.origin.y;
                self.scanningline.frame = frame;
                flag = YES;
            } else {
                [UIView animateWithDuration:self.animationTimeInterval animations:^{
                    frame.origin.y += 2;
                    _scanningline.frame = frame;
                } completion:nil];
            }
        } else {
            flag = !flag;
        }
    }
}

- (void)beginAnimate {
    [self addTimer];
    _isAnimating = YES;
}

- (void)stopAnimate {
    [self removeTimer];
    _isAnimating = NO;
}

- (void)reloadConfig {
    if (self.isAnimating) {
        [self stopAnimate];
        [self setNeedsDisplay];
        [self beginAnimate];
    }else {
        [self setNeedsDisplay];
    }
}

#pragma mark - getter && setter
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self reloadConfig];
}

- (void)setScanAreaSize:(CGSize)scanAreaSize {
    _scanAreaSize = scanAreaSize;
    [self reloadConfig];
}

- (void)setCornerLocation:(CornerLoaction)cornerLocation {
    _cornerLocation = cornerLocation;
    [self reloadConfig];
}

- (void)setCornerColor:(UIColor *)cornerColor {
    _cornerColor = cornerColor;
    [self reloadConfig];
}

- (void)setCornerWidth:(CGFloat)cornerWidth {
    _cornerWidth = cornerWidth;
    [self reloadConfig];
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha {
    _backgroundAlpha = backgroundAlpha;
    [self reloadConfig];
}

- (void)setScanningImageName:(NSString *)scanningImageName {
    _scanningImageName = scanningImageName;
    self.scanningline.image = [UIImage imageNamed:self.scanningImageName];
}

@end
