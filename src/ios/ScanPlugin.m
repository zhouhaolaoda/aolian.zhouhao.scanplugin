/********* ScanPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>
#import "WCQRCodeScanningVC.h"
@interface ScanPlugin : CDVPlugin {
  // Member variables go here.
}

- (void)scan:(CDVInvokedUrlCommand*)command;
@end

@implementation ScanPlugin


-(void)scan:(CDVInvokedUrlCommand*)command{
    WCQRCodeScanningVC *WBVC = [[WCQRCodeScanningVC alloc] init];
    WBVC.result = ^(NSString * str){
        CDVPluginResult* pluginResult = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:str];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
    [self QRCodeScanVC:WBVC];
}


- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.viewController presentViewController:scanVC animated:YES completion:nil];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
//                [self.navigationController pushViewController:scanVC animated:YES];
                [self.viewController presentViewController:scanVC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

                }];

                [alertC addAction:alertA];
                [self.viewController presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }

            default:
                break;
        }
        return;
    }

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

    }];

    [alertC addAction:alertA];
    [self.viewController presentViewController:alertC animated:YES completion:nil];
}

@end
