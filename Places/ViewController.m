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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _profile = [[Profile alloc] init];
    _settings = [[Settings alloc] init];
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
            _centerXToButton.constant = 0;
        }
        else  if ([sender isEqual:_settingsButton])
        {
            [_profileView setHidden:YES];
            [_settingsView setHidden:NO];
            [_profileButton setSelected:NO];
            [_settingsButton setSelected:YES];
            _centerXToButton.constant = _settingsButton.frame.size.width;
        }
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}
- (IBAction)datePickerChange:(id)sender {
    _profile.birthday = _datePicker.date;
}

-(IBAction)updatePhoto:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Select Photo", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet setTag:1];
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark WillRotate

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([_profileButton isSelected])
    {
        _centerXToButton.constant = 0;
    }
    else
    {
        _centerXToButton.constant = _settingsButton.frame.size.width;
    }
            [self.view layoutIfNeeded];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        NSInteger i = buttonIndex;
        switch(i)
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
}

- (void)uploadPhotoFrom:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:
         sourceType])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = sourceType;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
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
@end
