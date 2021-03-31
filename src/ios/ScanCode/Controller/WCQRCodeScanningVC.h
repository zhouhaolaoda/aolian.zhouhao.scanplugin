//
//  WCQRCodeScanningVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^scanResult)(NSString *string);
@interface WCQRCodeScanningVC : UIViewController
@property (nonatomic, copy) scanResult result;

@end
