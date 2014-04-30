//
//  UIAlertView+Variety.h
//  Alerts
//
//  Created by masafumi hayashi on 4/29/14.
//  Copyright (c) 2014 masafumi hayashi. All rights reserved.
//

@import UIKit;

@interface UIAlertView (Variety)
+ (instancetype)alertWithMessage:(NSString *)message;
+ (instancetype)alertWithConfirmMessage:(NSString *)message;
+ (instancetype)alertWithDebugMessage:(NSString *)message;
+ (instancetype)alertWithErrorMessage:(NSString *)message;
+ (instancetype)alertWithInfoMessage:(NSString *)message;
+ (instancetype)alertWithWarningMessage:(NSString *)message;
- (instancetype)title:(NSString *)title;
- (instancetype)addOkButton;
- (instancetype)addOkButton:(void(^)())block;
- (instancetype)addCancelButton;
- (instancetype)addCancelButton:(void(^)())block;
- (instancetype)addButton:(NSString *)title;
- (instancetype)addButton:(NSString *)title block:(void(^)())block;
@end
