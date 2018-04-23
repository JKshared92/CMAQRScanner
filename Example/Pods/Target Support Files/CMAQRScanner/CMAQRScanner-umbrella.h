#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CMAQRScanner.h"
#import "CMAQRScannerDelegate.h"
#import "CMAQRScanView.h"

FOUNDATION_EXPORT double CMAQRScannerVersionNumber;
FOUNDATION_EXPORT const unsigned char CMAQRScannerVersionString[];

