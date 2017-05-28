//
//  CCManageAutoUpload.m
//  Crypto Cloud Technology Nextcloud
//
//  Created by Marino Faggiana on 01/09/15.
//  Copyright (c) 2017 TWS. All rights reserved.
//
//  Author Marino Faggiana <m.faggiana@twsweb.it>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "CCManageAutoUpload.h"
#import "AppDelegate.h"
#import "NCBridgeSwift.h"

@implementation CCManageAutoUpload

//  From Settings
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])  {
        
        [self initializeForm];
    }
    
    return self;
}

// From Photos
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = doneButton;
        
        [self initializeForm];
    }
    
    return self;
}

- (void)initializeForm
{
    XLFormDescriptor *form ;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    tableAccount *tableAccount = [[NCManageDatabase sharedInstance] getAccountActive];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheming) name:@"changeTheming" object:nil];
    
    form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"_uploading_from_camera_", nil)];
    
    // Auto Upload
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    section.footerTitle = NSLocalizedString(@"_photo_folder_photocamera_", nil);

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"autoUpload" rowType:XLFormRowDescriptorTypeBooleanSwitch title:NSLocalizedString(@"_upload_camera_", nil)];
    
    if (tableAccount.autoUpload) row.value = @1;
    else row.value = @0;
    [row.cellConfig setObject:[UIFont systemFontOfSize:15.0]forKey:@"textLabel.font"];
    [section addFormRow:row];

    // Auto Upload Photo
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"autoUploadPhoto" rowType:XLFormRowDescriptorTypeBooleanSwitch title:NSLocalizedString(@"_upload_foto_camera_", nil)];
    row.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    if (tableAccount.autoUploadPhoto) row.value = @1;
    else row.value = @0;
    [row.cellConfig setObject:[UIFont systemFontOfSize:15.0]forKey:@"textLabel.font"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"autoUploadWWAnPhoto" rowType:XLFormRowDescriptorTypeBooleanSwitch title:NSLocalizedString(@"_wifi_only_", nil)];
    row.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    if (tableAccount.autoUploadWWAnPhoto) row.value = @1;
    else row.value = @0;
    [row.cellConfig setObject:[UIFont systemFontOfSize:15.0]forKey:@"textLabel.font"];
    [section addFormRow:row];
    
    // Auto Upload Video
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"autoUploadVideo" rowType:XLFormRowDescriptorTypeBooleanSwitch title:NSLocalizedString(@"_upload_video_camera_", nil)];
    row.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    if (tableAccount.autoUploadVideo) row.value = @1;
    else row.value = @0;
    [row.cellConfig setObject:[UIFont systemFontOfSize:15.0]forKey:@"textLabel.font"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"autoUploadWWAnVideo" rowType:XLFormRowDescriptorTypeBooleanSwitch title:NSLocalizedString(@"_wifi_only_", nil)];
    row.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    if (tableAccount.autoUploadWWAnVideo) row.value = @1;
    else row.value = @0;
    [row.cellConfig setObject:[UIFont systemFontOfSize:15.0]forKey:@"textLabel.font"];
    [section addFormRow:row];
    
    // Auto Upload Background
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"autoUploadBackground" rowType:XLFormRowDescriptorTypeBooleanSwitch title:NSLocalizedString(@"_upload_camera_background_", nil)];
    row.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    if (tableAccount.autoUploadBackground) row.value = @1;
    else row.value = @0;
    [row.cellConfig setObject:[UIFont systemFontOfSize:15.0]forKey:@"textLabel.font"];
    [section addFormRow:row];
    
    // Auto Upload Full
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    NSString *title = NSLocalizedString(@"_upload_camera_fullphotos_", nil);
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"autoUploadFull" rowType:XLFormRowDescriptorTypeBooleanSwitch title:title];
    row.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    row.value = 0;
    if (tableAccount.autoUploadFull) row.value = @1;
    else row.value = @0;
    [row.cellConfig setObject:[UIFont systemFontOfSize:15.0]forKey:@"textLabel.font"];
    [section addFormRow:row];
    
    // Auto Upload create subfolder

    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"autoUploadCreateSubfolder" rowType:XLFormRowDescriptorTypeBooleanSwitch title:NSLocalizedString(@"_upload_camera_create_subfolder_", nil)];
    row.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    if (tableAccount.autoUploadCreateSubfolder) row.value = @1;
    else row.value = @0;
    [row.cellConfig setObject:[UIFont systemFontOfSize:15.0]forKey:@"textLabel.font"];
    [section addFormRow:row];

    // end
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    self.form = form;
}

// Apparirà
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.backgroundColor = [NCBrandColor sharedInstance].tableBackground;

    // Color
    [app aspectNavigationControllerBar:self.navigationController.navigationBar encrypted:NO online:[app.reachability isReachable] hidden:NO];
    [app aspectTabBar:self.tabBarController.tabBar hidden:NO];
    
    // Request permission for camera roll access
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusRestricted:
                NSLog(@"[LOG] user can't grant access to camera roll");
                break;
            case PHAuthorizationStatusDenied:
                NSLog(@"[LOG] user denied access to camera roll");
                break;
            default:
                break;
        }
    }];

    [self reloadForm];
}

- (void)changeTheming
{
    if (self.isViewLoaded && self.view.window)
        [app changeTheming:self];
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue
{
    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
    
    tableAccount *tableAccount = [[NCManageDatabase sharedInstance] getAccountActive];
    
    if ([rowDescriptor.tag isEqualToString:@"autoUpload"]) {
        
        if ([[rowDescriptor.value valueData] boolValue] == YES) {
                        
            // Create Folder
            if (app.activeMain)
                [app.activeMain createFolderCameraUpload];
            
            [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUpload" state:YES];
            
            // Default
            [[NCManageDatabase sharedInstance] setAccountAutoUploadFileName:nil];
            [[NCManageDatabase sharedInstance] setAccountAutoUploadDirectory:nil activeUrl:app.activeUrl];
            
            // verifichiamo che almeno uno dei servizi (foto video) siano attivi, in caso contrario attiviamo le foto
            if (tableAccount.autoUploadPhoto == NO && tableAccount.autoUploadVideo == NO)
                [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadPhoto" state:YES];
            
            // Settings date
            if (tableAccount.autoUploadPhoto)
                [[NCManageDatabase sharedInstance] setAccountAutoUploadDateAssetType:PHAssetMediaTypeImage assetDate:[NSDate date]];
            if (tableAccount.autoUploadVideo)
                [[NCManageDatabase sharedInstance] setAccountAutoUploadDateAssetType:PHAssetMediaTypeVideo assetDate:[NSDate date]];
            
        } else {
            
            [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUpload" state:NO];
            [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadFull" state:NO];
            
            [[NCManageDatabase sharedInstance] setAccountAutoUploadDateAssetType:PHAssetMediaTypeImage assetDate:nil];
            [[NCManageDatabase sharedInstance] setAccountAutoUploadDateAssetType:PHAssetMediaTypeVideo assetDate:nil];

            // remove
            [[NCManageDatabase sharedInstance] clearTable:[tableAutomaticUpload class] account:app.activeAccount];
        }
        
        // Initialize Auto Upload
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"initStateCameraUpload" object:nil];
        
        [self reloadForm];
    }
    
    if ([rowDescriptor.tag isEqualToString:@"autoUploadBackground"]) {
        
        if ([[rowDescriptor.value valueData] boolValue] == YES) {
            
            BOOL isLocationIsEnabled = NO;
                
            if (app.activePhotosCameraUpload)
                [app.activePhotosCameraUpload checkIfLocationIsEnabled];
                
            if(isLocationIsEnabled == YES) {
                    
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"_cameraupload_background_title_", nil) message:[CCUtility localizableBrand:@"_cameraupload_background_msg_" table:nil] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"_ok_", nil), nil];
                [alertView show];
                    
                [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadBackground" state:YES];
                    
            } else {
                 
                [self reloadForm];
            }
            
        } else {
            
            [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadBackground" state:NO];
            [[CCManageLocation sharedInstance] stopSignificantChangeUpdates];
        }
    }

    if ([rowDescriptor.tag isEqualToString:@"autoUploadFull"]) {
        
        if ([[rowDescriptor.value valueData] boolValue] == YES) {
            
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"setupCameraUploadFull" object:nil];
            [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadFull" state:YES];
            
        } else {
            
            [[NCManageDatabase sharedInstance] clearTable:[tableAutomaticUpload class] account:app.activeAccount];
            [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadFull" state:NO];
        }
    }

    if ([rowDescriptor.tag isEqualToString:@"autoUploadPhoto"]) {
        
        if ([[rowDescriptor.value valueData] boolValue] == YES) {
            
            [[NCManageDatabase sharedInstance] setAccountAutoUploadDateAssetType:PHAssetMediaTypeImage assetDate:[NSDate date]];
            
        } else {
            
            [[NCManageDatabase sharedInstance] setAccountAutoUploadDateAssetType:PHAssetMediaTypeImage assetDate:nil];
        }
                
        [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadPhoto" state:[[rowDescriptor.value valueData] boolValue]];
        
    }
    
    if ([rowDescriptor.tag isEqualToString:@"autoUploadWWAnPhoto"]) {
        
        [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadWWAnPhoto" state:[[rowDescriptor.value valueData] boolValue]];
    }
    
    if ([rowDescriptor.tag isEqualToString:@"autoUploadVideo"]) {
    
        if ([[rowDescriptor.value valueData] boolValue] == YES) {
                
            [[NCManageDatabase sharedInstance] setAccountAutoUploadDateAssetType:PHAssetMediaTypeVideo assetDate:[NSDate date]];

        } else {
                
            [[NCManageDatabase sharedInstance] setAccountAutoUploadDateAssetType:PHAssetMediaTypeVideo assetDate:nil];
        }
            
        [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadVideo" state:[[rowDescriptor.value valueData] boolValue]];
    }
    
    if ([rowDescriptor.tag isEqualToString:@"autoUploadWWAnVideo"]) {
        
        [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadWWAnVideo" state:[[rowDescriptor.value valueData] boolValue]];
    }
    
    if ([rowDescriptor.tag isEqualToString:@"autoUploadCreateSubfolder"]) {
        
        [[NCManageDatabase sharedInstance] setAccountAutoUploadFiled:@"autoUploadCreateSubfolder" state:[[rowDescriptor.value valueData] boolValue]];
    }
}

- (void)done:(XLFormRowDescriptor *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadForm
{
    self.form.delegate = nil;
    
    XLFormRowDescriptor *rowAutoUpload = [self.form formRowWithTag:@"autoUpload"];
    
    XLFormRowDescriptor *rowAutoUploadPhoto = [self.form formRowWithTag:@"autoUploadPhoto"];
    XLFormRowDescriptor *rowAutoUploadWWAnPhoto = [self.form formRowWithTag:@"autoUploadWWAnPhoto"];
    
    XLFormRowDescriptor *rowAutoUploadVideo = [self.form formRowWithTag:@"autoUploadVideo"];
    XLFormRowDescriptor *rowAutoUploadWWAnVideo = [self.form formRowWithTag:@"autoUploadWWAnVideo"];
    
    XLFormRowDescriptor *rowAutoUploadBackground = [self.form formRowWithTag:@"autoUploadBackground"];
    
    XLFormRowDescriptor *rowAutoUploadFull = [self.form formRowWithTag:@"autoUploadFull"];
    
    XLFormRowDescriptor *rowAutoUploadCreateSubfolder = [self.form formRowWithTag:@"autoUploadCreateSubfolder"];

    
    // - STATUS ---------------------
    tableAccount *tableAccount = [[NCManageDatabase sharedInstance] getAccountActive];
    
    if (tableAccount.autoUpload)
        [rowAutoUpload setValue:@1]; else [rowAutoUpload setValue:@0];
    
    if (tableAccount.autoUploadPhoto)
        [rowAutoUploadPhoto setValue:@1]; else [rowAutoUploadPhoto setValue:@0];
    
    if (tableAccount.autoUploadWWAnPhoto)
        [rowAutoUploadWWAnPhoto setValue:@1]; else [rowAutoUploadWWAnPhoto setValue:@0];
    
    if (tableAccount.autoUploadVideo)
        [rowAutoUploadVideo setValue:@1]; else [rowAutoUploadVideo setValue:@0];
    
    if (tableAccount.autoUploadWWAnVideo)
        [rowAutoUploadWWAnVideo setValue:@1]; else [rowAutoUploadWWAnVideo setValue:@0];
    
    if (tableAccount.autoUploadBackground)
        [rowAutoUploadBackground setValue:@1]; else [rowAutoUploadBackground setValue:@0];
    
    if (tableAccount.autoUploadFull)
        [rowAutoUploadFull setValue:@1]; else [rowAutoUploadFull setValue:@0];
    
    if (tableAccount.autoUploadCreateSubfolder)
        [rowAutoUploadCreateSubfolder setValue:@1]; else [rowAutoUploadCreateSubfolder setValue:@0];
    
    // - HIDDEN ---------------------
    
    rowAutoUploadPhoto.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    rowAutoUploadWWAnPhoto.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    
    rowAutoUploadVideo.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    rowAutoUploadWWAnVideo.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    
    rowAutoUploadBackground.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    
    rowAutoUploadFull.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];
    
    rowAutoUploadCreateSubfolder.hidden = [NSString stringWithFormat:@"$%@==0", @"autoUpload"];

    // ----------------------
    
    [self.tableView reloadData];
    
    self.form.delegate = self;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    tableAccount *tableAccount = [[NCManageDatabase sharedInstance] getAccountActive];
    NSString *sectionName;
    
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"_uploading_from_camera_", nil);
            break;
        case 1:
            if (tableAccount.autoUpload) sectionName = NSLocalizedString(@"_upload_automatic_photos_", nil);
            else sectionName = @"";
            break;
        case 2:
            if (tableAccount.autoUpload) sectionName = NSLocalizedString(@"_upload_automatic_videos_", nil);
            else sectionName = @"";
            break;
        case 3:
            if (tableAccount.autoUpload) sectionName = NSLocalizedString(@"_upload_camera_background_", nil);
            else sectionName = @"";
            break;
        case 4:
            if (tableAccount.autoUpload) sectionName = NSLocalizedString(@"_upload_camera_fullphotos_", nil);
            else sectionName = @"";
            break;
        case 5:
            if (tableAccount.autoUpload) sectionName = NSLocalizedString(@"_upload_camera_create_subfolder_", nil);
            else sectionName = @"";
            break;
    }
    return sectionName;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    tableAccount *tableAccount = [[NCManageDatabase sharedInstance] getAccountActive];
    NSString *sectionName;
    
    switch (section)
    {
        case 0:
            sectionName = [CCUtility localizableBrand:@"_photo_folder_photocamera_" table:nil];
            break;
        case 3:
            if (tableAccount.autoUpload) sectionName = [CCUtility localizableBrand:@"_photo_folder_background_" table:nil];
            else sectionName = @"";
            break;
        case 4:
            if (tableAccount.autoUpload) sectionName =  [CCUtility localizableBrand:@"_upload_camera_fullphotos_footer_" table:nil];
            else sectionName = @"";
            break;
        case 5:
            if (tableAccount.autoUpload) sectionName =  [CCUtility localizableBrand:@"_upload_camera_create_subfolder_footer_" table:nil];
            else sectionName = @"";
            break;
    }
    return sectionName;
}

@end