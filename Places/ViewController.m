//
//  ViewController.m
//  Places
//
//  Created by Serban Chiricescu on 29/06/15.
//  Copyright (c) 2015 Qualitance. All rights reserved.
//

#import "ViewController.h"
#import "Profile.h"
#import "Settings.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (nonatomic, strong) Profile *profile;
@property (nonatomic, strong) Settings *settings;
@property (weak, nonatomic) IBOutlet UIImageView *profileIamge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerXToButton;
@property (weak, nonatomic) UIView *selectedView;
@property (strong, nonatomic) NSDictionary *userInfo;

@property (nonatomic) CGPoint lastLocation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _profile = [[Profile alloc] init];
    _settings = [[Settings alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    UIScreenEdgePanGestureRecognizer *panRight = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pangGesture:)];
    [panRight setEdges:UIRectEdgeRight];
    [self.view addGestureRecognizer:panRight];
    
    UIScreenEdgePanGestureRecognizer *panLeft = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pangGesture:)];
    [panLeft setEdges:UIRectEdgeLeft];
    [self.view addGestureRecognizer:panLeft];
    
}


- (IBAction)buttonPressed:(UIButton *)sender {
    if (![sender isSelected])
    {
        if ([sender isEqual:_profileButton])
        {
            [_profileView setHidden:NO];
            [_settingsView setHidden:YES];
            [_profileButton setSelected:YES];
            [_settingsButton setSelected:NO];
        }
        else  if ([sender isEqual:_settingsButton])
        {
            [_profileView setHidden:YES];
            [_settingsView setHidden:NO];
            [_profileButton setSelected:NO];
            [_settingsButton setSelected:YES];
        }
        [self updateIndicationViewWithDuration:0.5];
    }
}
- (IBAction)datePickerChange:(id)sender {
    _profile.birthday = _datePicker.date;
}

-(IBAction)updatePhoto:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Select Photo", nil];
    
    
    [actionSheet showInView:self.view];
}


#pragma mark -
#pragma mark Keyboard
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)note {
    _userInfo = note.userInfo;
    isKeyboardUp = YES;
    [self adjustHeight];
}

bool isKeyboardUp;

-(void)adjustHeight
{
    NSTimeInterval duration = [_userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [_userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardFrameEnd = [_userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        if (-50 -(keyboardFrameEnd.size.height - (self.view.frame.size.height - (_selectedView.frame.origin.y + _selectedView.frame.size.height))) < 0)
        {
            self.view.frame = CGRectMake(0,-50 -(keyboardFrameEnd.size.height - (self.view.frame.size.height - (_selectedView.frame.origin.y + _selectedView.frame.size.height))) ,self.view.frame.size.width,self.view.frame.size.height);
        }
        
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)note {
    isKeyboardUp = NO;
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        isKeyboardUp = NO;
    } completion:nil];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![touch.view isEqual: _profileIamge] || touch.view == nil) {
        return;
    }
    
    _lastLocation = [touch locationInView: _profileIamge];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![touch.view isEqual: _profileIamge]) {
        return;
    }
    
    CGPoint location = [touch locationInView: _profileIamge];
    
    CGFloat xDisplacement = location.x - _lastLocation.x;
    CGFloat yDisplacement = location.y - _lastLocation.y;
    
    CGRect frame = touch.view.frame;
    frame.origin.x += xDisplacement;
    frame.origin.y += yDisplacement;
    touch.view.frame = frame;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _lastLocation=location;
    } completion:nil];
    
}

#pragma mark -
#pragma mark WillRotate

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateIndicationViewWithDuration:0.0];
}

-(void)updateIndicationViewWithDuration:(CGFloat)duration
{
    if ([_profileButton isSelected])
    {
        _centerXToButton.constant = 0;
    }
    else
    {
        _centerXToButton.constant = _settingsButton.frame.size.width;
    }
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
        {
            [self uploadPhotoFrom:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        case 1:
        {
            [self uploadPhotoFrom:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        default:
            break;
    }
    
}

- (void)uploadPhotoFrom:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:
         sourceType])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = sourceType;
        //imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        //imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        
    }
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        _profile.photo =info[UIImagePickerControllerOriginalImage];
        _profileIamge.image = _profile.photo;
    }
}

#pragma -mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _selectedView = (UIView *)textField;
    if (isKeyboardUp)
    {
        [self adjustHeight];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_firstNameTextField isEqual:textField])
    {
        _profile.firstName = textField.text;
        [_lastNameTextField becomeFirstResponder];
    }
    if ([_lastNameTextField isEqual:textField])
    {
        _profile.lastName = textField.text;
    }
}

#pragma -mark
#pragma mark SettingsView

- (IBAction)demoSwitch:(UISwitch *)sender {
    _settings.showDemo = [sender isSelected];
}

- (IBAction)notificationSwitch:(id)sender {
    _settings.sendNotifications = [sender isSelected];
}


#pragma -mark
#pragma mark UIGestureRecognizer
- (void)pangGesture:(UIScreenEdgePanGestureRecognizer *)sender{
    if (sender.edges == UIRectEdgeLeft)
    {
        [self buttonPressed:_profileButton];
    }
    else if (sender.edges == UIRectEdgeRight)
    {
        [self buttonPressed:_settingsButton];
    }
    
}



@end
