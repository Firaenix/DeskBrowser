//
//  DeskBrowserAppDelegate.h
//  DeskBrowser
//
//  Created by Nick Carton on 1/07/11.
//  Copyright 2011 Firaenix. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/Webkit.h>
#import <WebKit/WebView.h>
#import <Carbon/Carbon.h>

/* This is where you define variables and make pointers to reference points in your interface*/
@interface DeskBrowserAppDelegate : NSObject <NSApplicationDelegate, NSComboBoxDelegate, NSWindowDelegate, NSMenuDelegate> {
    NSWindow *window;
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;
    
    IBOutlet NSTextField *OpenURLText;
    IBOutlet NSSlider *ActiveOPSlider;
    IBOutlet NSWindow *PrefsWindow;
    IBOutlet NSWindow *MainWindow;
    //Facebook Related interface variables (buttons, sliders, etc.)
    IBOutlet NSWindow *FBPrefsWind;
    IBOutlet NSSlider *FBActiveOPSlider;
    IBOutlet NSButton *FBOpacCheckBox;
    IBOutlet NSMenuItem *goToFacebook;
    //Twitter Related interface variables (buttons, sliders, etc.)
    IBOutlet NSWindow *TwitPrefsWind;
    IBOutlet NSSlider *TwitActiveOPSlider;
    IBOutlet NSButton *TwitOpacityCheckBox;
    
    IBOutlet NSView *GPrefsWind;
    IBOutlet NSButton *GOpacCheckBox;
    IBOutlet NSSlider *GActiveOPSlider;
    IBOutlet NSProgressIndicator *URLIndicator;
    
    
    
    //Button for redirect to help blog
    IBOutlet NSMenuItem *goToHelp;
    WebView *WebPage;
    
    NSTimer *timer;
    IBOutlet NSComboBoxCell *timerComboBox;
    IBOutlet NSSegmentedControl *launchAtLoginButton;
}
//These variables are the initilisation variables for the respective methods
//These methods are automatically run when the application opens.
@property (readonly, unsafe_unretained, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, unsafe_unretained, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, unsafe_unretained, nonatomic) NSManagedObjectContext *managedObjectContext;

//- (IBAction)saveAction:(id)sender;
@property (strong, nonatomic) IBOutlet NSProgressIndicator *URLIndicator;

@property (strong, nonatomic) IBOutlet NSTextField *OpenURLText;
@property (strong, nonatomic) IBOutlet NSWindow *PrefsWindow;
@property (strong, nonatomic) IBOutlet NSWindow *MainWindow;
@property (strong, nonatomic) IBOutlet NSWindow *FBPrefsWind;
@property (strong, nonatomic) IBOutlet NSWindow *TwitPrefsWind;
@property (strong, nonatomic) IBOutlet NSView *GPrefsWind;

@property (strong, nonatomic) IBOutlet NSSlider *FBActiveOPSlider;
@property (strong, nonatomic) IBOutlet NSButton *FBOpacCheckBox;
@property (strong, nonatomic) IBOutlet NSSlider *TwitActiveOPSlider;
@property (strong, nonatomic) IBOutlet NSButton *TwitOpacityCheckBox;
@property (strong, nonatomic) IBOutlet NSSlider *ActiveOPSlider;
@property (strong, nonatomic) IBOutlet NSButton *GOpacCheckBox;
@property (strong, nonatomic) IBOutlet NSSlider *GActiveOPSlider;

@property (strong, nonatomic) IBOutlet NSMenuItem *goToFacebook;
@property (strong, nonatomic) IBOutlet NSMenuItem *goToHelp;
@property (strong, nonatomic) IBOutlet WebView *WebPage;
@property (strong, nonatomic) IBOutlet NSComboBoxCell *timerComboBox;

@property (retain, nonatomic) IBOutlet NSSegmentedControl *launchAtLoginButton;

//For Changing Transparency
- (IBAction)changeTransparency:(id)sender;
- (IBAction)changeTwitTransparency:(id)sender;
- (IBAction)changeFacebookTransparency:(id)sender;
- (IBAction)changeGoogleTransparency:(id)sender;

//NSWindow related initialisation variables
- (BOOL)inFullScreenMode;
//Navigation related initilisation variables
- (IBAction)helpRedirect:(id)sender;
/* This variable is the initilisation variable
 for the helpRedirect method. It allows the user
 to click the help button and then be redirected to my
 Help website on my blog. */
- (IBAction)facebookRedirect:(id)sender;
- (IBAction)twitterRedirect:(id)sender;
- (IBAction)gplusRedirect:(id)sender;
- (IBAction)FBCheckboxClicked:(id)sender;
- (IBAction)TwitCheckboxClicked:(id)sender;
- (IBAction)GoogleCheckboxClicked:(id)sender;
- (IBAction)OpenURLText:(id)sender;
- (IBAction)setRefreshInterval:(id)sender;


//Click this button to launch the app when the machine starts.
-(IBAction)toggleLaunchAtLogin:(id)sender;


//- (void)initPreferences;




@end
