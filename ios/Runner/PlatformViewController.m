// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#import <Foundation/Foundation.h>
#import "PlatformViewController.h"

@interface PlatformViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *screenUI;
@property (weak, nonatomic) IBOutlet UILabel *incrementLabel;
@end

@implementation PlatformViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setIncrementLabelText];
    
  // Add an observer that will respond to loginComplete
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)handleIncrement:(id)sender {
  self.counter++;
  [self setIncrementLabelText];
}

- (IBAction)switchToFlutterView:(id)sender {
    NSString* messageFromInput = self.textField.text;
    
    [self.delegate sendMessage:messageFromInput];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setIncrementLabelText {
    NSString* message = [NSString stringWithFormat:@"Message from Flutter: %@", self.message];
    self.incrementLabel.text = message;
}

@end



