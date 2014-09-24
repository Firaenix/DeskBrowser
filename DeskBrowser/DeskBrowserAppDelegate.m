//
//  DeskBrowserAppDelegate.m
//  DeskBrowser
//
//  Created by Nick Carton on 1/07/11.
//  Copyright 2011 Firaenix. All rights reserved.
//

#import "DeskBrowserAppDelegate.h"
#import <ServiceManagement/ServiceManagement.h>

@implementation DeskBrowserAppDelegate

// House cleaning and more initialisation points
@synthesize WebPage;
@synthesize timerComboBox;
@synthesize goToFacebook;
@synthesize goToHelp;

@synthesize TwitActiveOPSlider;
@synthesize TwitOpacityCheckBox;
@synthesize FBOpacCheckBox;
@synthesize FBActiveOPSlider;
@synthesize ActiveOPSlider;
@synthesize GOpacCheckBox;
@synthesize GActiveOPSlider;

@synthesize MainWindow;
@synthesize PrefsWindow;
@synthesize FBPrefsWind;
@synthesize TwitPrefsWind;
@synthesize GPrefsWind;

@synthesize URLIndicator;
@synthesize OpenURLText;

@synthesize launchAtLoginButton = launchAtLoginButton;

//-------------------------When the application has successfully been launched----------------------------------


/*When the application finishes launching, all these methods are called to initialise and set the desired results */
- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    
    [WebPage setApplicationNameForUserAgent:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.55.3 (KHTML, like Gecko) Version/5.1.3 Safari/534.53.10"];
    [WebPage setContinuousSpellCheckingEnabled:YES];
    [MainWindow setCollectionBehavior:NSWindowCollectionBehaviorDefault];
    
}


//---------------------When the application resigns its active status------------------------------
/*This method makes sure that when the application resigns its status of 
 being active, it runs the method setIgnoresMouseEvents as a subroutine
 and sets the Boolean value to yes so that you can not click on the window. */

- (void)applicationDidResignActive:(NSNotification *)notification {
    NSUInteger masks = [MainWindow styleMask];
    if ( masks & NSFullScreenWindowMask) {
        //[self setIgnoresMouseEvents:NO];
        [MainWindow setHasShadow:YES];
        [MainWindow setCollectionBehavior:NSWindowCollectionBehaviorDefault | NSWindowCollectionBehaviorFullScreenPrimary];
        [MainWindow setLevel:kCGNormalWindowLevel];
    }else {
        [MainWindow setStyleMask:NSBorderlessWindowMask];
        [MainWindow setCollectionBehavior:NSWindowCollectionBehaviorTransient]; 
        [MainWindow setLevel:kCGDesktopIconWindowLevel - 1]; //Fixed
        [MainWindow setHasShadow:NO];
        //[self setIgnoresMouseEvents:YES];
        [self.WebPage setShouldUpdateWhileOffscreen:YES];
    }
    
    if (!timer) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [self startTimer:[prefs integerForKey:@"RefreshInterval"]];
    }
}



//---------------------When the application becomes active after being inactive-------------------------------

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    NSUInteger masks = [MainWindow styleMask];
    if ( masks & NSFullScreenWindowMask) {
        [MainWindow setHasShadow:YES];
        [MainWindow setCollectionBehavior:NSWindowCollectionBehaviorDefault | NSWindowCollectionBehaviorFullScreenPrimary];
        [MainWindow setLevel:kCGNormalWindowLevel];
    

    }else {
        [MainWindow setOpaque:NO];
        [MainWindow setHasShadow:YES];
        [MainWindow setStyleMask:NSResizableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask];   
        [MainWindow setTitle:@"DeskBrowser"];
        [MainWindow setCollectionBehavior:NSWindowCollectionBehaviorDefault | NSWindowCollectionBehaviorFullScreenPrimary];
        [MainWindow setLevel:kCGNormalWindowLevel];
        //Sets the Window border to active with required variables to reinitialise the webview window
        
    }

    [timer invalidate];
    timer = nil;

}



-(void)awakeFromNib{
    [MainWindow setHasShadow:YES];
    [MainWindow setCollectionBehavior:NSWindowCollectionBehaviorTransient | NSWindowCollectionBehaviorFullScreenPrimary];
    [MainWindow setLevel:kCGNormalWindowLevel];
    //Sets the Window border to active with required variables to reinitialise the webview window
    [MainWindow setStyleMask:NSResizableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask];   
    [MainWindow setTitle:@"DeskBrowser"];

    [WebPage setFrameLoadDelegate:self];
    
    [WebPage setApplicationNameForUserAgent:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.55.3 (KHTML, like Gecko) Version/5.1.3 Safari/534.53.10"];
    [MainWindow setFrameAutosaveName:@"DeskBrowserFrameSave"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (! [prefs doubleForKey:@"MainOpacityValue"] || [prefs doubleForKey:@"MainOpacityValue"] <= 0.18) {
        [prefs setDouble:0.7 forKey:@"MainOpacityValue"];
    }
    
    if (![prefs doubleForKey:@"TwitOpacityValue"]) {
        [prefs setDouble:0.7 forKey:@"TwitOpacityValue"];
    }
    if (![prefs doubleForKey:@"FBOpacityValue"]) {
        [prefs setDouble:0.7 forKey:@"FBOpacityValue"];
    }
    if (![prefs doubleForKey:@"GOpacityValue"]) {
        [prefs setDouble:0.7 forKey:@"GOpacityValue"];
    }
    if (![prefs boolForKey:@"LaunchAtLogin"]) {
        [prefs setBool:false forKey:@"LaunchAtLogin"];
    }
    
    double activeOpacity = [prefs doubleForKey:@"MainOpacityValue"];
    double TwitactiveOpacity = [prefs doubleForKey:@"TwitOpacityValue"];
    double FBactiveOpacity = [prefs doubleForKey:@"FBOpacityValue"];
    double GactiveOpacity = [prefs doubleForKey:@"GOpacityValue"];
    bool LaunchAtLogin = [prefs boolForKey:@"LaunchAtLogin"];

    
    [ActiveOPSlider setDoubleValue:activeOpacity];
    NSLog(@"Opacity: %f", activeOpacity);
    [self.MainWindow setAlphaValue:[ActiveOPSlider doubleValue]];
    [GActiveOPSlider setDoubleValue:GactiveOpacity];
    [FBActiveOPSlider setDoubleValue:FBactiveOpacity];
    [TwitActiveOPSlider setDoubleValue:TwitactiveOpacity];
    
    int refreshInt = [prefs integerForKey:@"RefreshInterval"];
    int refreshSel = [prefs integerForKey:@"RefreshSelection"];
    //NSLog(@"%@", refreshInt);
    [timerComboBox selectItemAtIndex:refreshSel];
    int mins = refreshInt;
    [self startTimer:mins];
    
    bool twitCheck = [prefs boolForKey:@"TwitCheckBoxState"];
    bool FBCheck = [prefs boolForKey:@"FBCheckBoxState"];
    bool GCheck = [prefs boolForKey:@"GCheckBoxState"];
    
    [TwitOpacityCheckBox setState:twitCheck];
    [TwitActiveOPSlider setEnabled:twitCheck];
    [FBOpacCheckBox setState:FBCheck];
    [FBActiveOPSlider setEnabled:FBCheck];
    [GOpacCheckBox setState:GCheck];
    [GActiveOPSlider setEnabled:GCheck];
    [self GoogleCheckboxClicked:self];
    
    if (LaunchAtLogin == TRUE) {
        [launchAtLoginButton setIntValue:0];
    }else{
        [launchAtLoginButton setIntValue:1];
    }
    
    
    
    
    NSString* lastURL = [prefs objectForKey:@"LastWebPage"];
	if ( lastURL ){
        [[WebPage mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:lastURL]]];
    }
	else{
		[[WebPage mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.facebook.com"]]];
    }
}


//-------------------------WEBVIEW RELATED SETTINGS-----------------------------------------


- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame{
    [URLIndicator startAnimation:self];
    
}
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    
    [URLIndicator stopAnimation:self];
}


//------------------------CHANGE TRANSPARENCY-----------------------

/* This method changes the transparency/Opacity of the entire window. Therefore, all the objects that are displayed in the window, inherit the transparency/Opacity */

- (IBAction)changeTransparency:(id)sender {
    //Set the windows alpha value, thereby changing the opacity
    
    [self.MainWindow setAlphaValue:[sender doubleValue]];
    [[NSUserDefaults standardUserDefaults] setDouble:[sender doubleValue] forKey:@"MainOpacityValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeTwitTransparency:(id)sender {
    
    if ([self.WebPage.mainFrameURL isEqualToString:@"https://twitter.com/"] || [self.WebPage.mainFrameURL isEqualToString:@"http://twitter.com/"])
    {
        NSLog(@"True");
        [self.MainWindow setAlphaValue:[sender doubleValue]];
        
    }else {
        NSLog(@"False");
    }
    [[NSUserDefaults standardUserDefaults] setDouble:[sender doubleValue] forKey:@"TwitOpacityValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeFacebookTransparency:(id)sender {
    if ([self.WebPage.mainFrameURL isEqualToString:@"http://www.facebook.com/"] || [self.WebPage.mainFrameURL isEqualToString:@"https://www.facebook.com/"])
    {
        [self.MainWindow setAlphaValue:[sender doubleValue]];
    }
    [[NSUserDefaults standardUserDefaults] setDouble:[sender doubleValue] forKey:@"FBOpacityValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeGoogleTransparency:(id)sender {
    NSLog(@"URL: %@", self.WebPage.mainFrameURL);
    if ([self.WebPage.mainFrameURL isEqualToString:@"https://plus.google.com/"] || [self.WebPage.mainFrameURL isEqualToString:@"http://plus.google.com/"])
    {
        [self.MainWindow setAlphaValue:[sender doubleValue]];
    }
    [[NSUserDefaults standardUserDefaults] setDouble:[sender doubleValue] forKey:@"GOpacityValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



//The below methods are used for redirecting the webpage to the respective webpages eg.
                        /* Facebook, Twitter, Google+ and my Help Document */

- (IBAction)helpRedirect:(id)sender
{
    [[WebPage mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.sddmajorproj.wordpress.com/help"]]];
}

- (IBAction)facebookRedirect:(id)sender
{
    [[WebPage mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.facebook.com"]]];
    if ([FBOpacCheckBox state] == NSOnState) {
        [self.MainWindow setAlphaValue:[self.FBActiveOPSlider doubleValue]];
    }else {
        [self.MainWindow setAlphaValue:[self.ActiveOPSlider doubleValue]];
    }
    
}

- (IBAction)twitterRedirect:(id)sender
{
    [[WebPage mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.twitter.com"]]];
    
    if ([TwitOpacityCheckBox state] == NSOnState) {
        [self.MainWindow setAlphaValue:[self.TwitActiveOPSlider doubleValue]];
    }else {
        [self.MainWindow setAlphaValue:[self.ActiveOPSlider doubleValue]];
    }
}

- (IBAction)gplusRedirect:(id)sender
{
    [[WebPage mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://plus.google.com"]]];
    
    if ([GOpacCheckBox state] == NSOnState) {
        [self.MainWindow setAlphaValue:[self.GActiveOPSlider doubleValue]];
    }else {
        [self.MainWindow setAlphaValue:[self.ActiveOPSlider doubleValue]];
    }

}

- (IBAction)FBCheckboxClicked:(id)sender {
    NSLog(@"%ld", [FBOpacCheckBox state]);
    if ([FBOpacCheckBox state] == NSOnState) {
        [self.FBActiveOPSlider setEnabled:TRUE];
    }else if ([FBOpacCheckBox state] == NSOffState) {
        [self.FBActiveOPSlider setEnabled:FALSE];
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    double FBactiveOpacity = [prefs doubleForKey:@"FBOpacityValue"];
    
    
    if ([self.WebPage.mainFrameURL isEqualToString:@"http://www.facebook.com/"] || [self.WebPage.mainFrameURL isEqualToString:@"https://www.facebook.com/"]) {
        if ([FBOpacCheckBox state] == NSOnState) {
            //[self.FBActiveOPSlider setEnabled:TRUE];
            NSLog(@"%f", [sender doubleValue]);
            [self.MainWindow setAlphaValue:FBactiveOpacity];
        }
        else if ([FBOpacCheckBox state] == NSOffState){
            //[self.FBActiveOPSlider setEnabled:FALSE];
            [self.MainWindow setAlphaValue:[self.ActiveOPSlider doubleValue]];
        }

    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setBool:[FBOpacCheckBox state] forKey:@"FBCheckBoxState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)TwitCheckboxClicked:(id)sender {
    if ([TwitOpacityCheckBox state] == NSOnState) {
        [self.TwitActiveOPSlider setEnabled:TRUE];
    }else if ([TwitOpacityCheckBox state] == NSOffState) {
        [self.TwitActiveOPSlider setEnabled:FALSE];
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    double TwitactiveOpacity = [prefs doubleForKey:@"TwitOpacityValue"];
    
    if ([self.WebPage.mainFrameURL isEqualToString:@"https://twitter.com/"] || [self.WebPage.mainFrameURL isEqualToString:@"http://twitter.com/"]) {
        if ([TwitOpacityCheckBox state] == NSOnState) {
            //[self.TwitActiveOPSlider setEnabled:TRUE];
            [self.MainWindow setAlphaValue:TwitactiveOpacity];
        }
        else if ([TwitOpacityCheckBox state] == NSOffState){
            //[self.TwitActiveOPSlider setEnabled:FALSE];
            [self.MainWindow setAlphaValue:[self.ActiveOPSlider doubleValue]];
        }

    }
    
    
    
    [[NSUserDefaults standardUserDefaults]setBool:[TwitOpacityCheckBox state] forKey:@"TwitCheckBoxState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)GoogleCheckboxClicked:(id)sender{
    if ([GOpacCheckBox state] == NSOnState) {
        [self.GActiveOPSlider setEnabled:TRUE];
    }else if ([GOpacCheckBox state] == NSOffState) {
        [self.GActiveOPSlider setEnabled:FALSE];
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    double GactiveOpacity = [prefs doubleForKey:@"GOpacityValue"];
    
    if ([self.WebPage.mainFrameURL isEqualToString:@"https://plus.google.com/"] || [self.WebPage.mainFrameURL isEqualToString:@"http://plus.google.com/"]) {
        if ([GOpacCheckBox state] == NSOnState) {
            //[self.GActiveOPSlider setEnabled:TRUE];
            [self.MainWindow setAlphaValue:GactiveOpacity];
        }
        else if ([GOpacCheckBox state] == NSOffState){
            //[self.GActiveOPSlider setEnabled:FALSE];
            [self.MainWindow setAlphaValue:[self.ActiveOPSlider doubleValue]];
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setBool:[GOpacCheckBox state] forKey:@"GCheckBoxState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




- (IBAction)OpenURLText:(id)sender {
    NSString* urlString = self.OpenURLText.stringValue;
    NSString* urlExtension = [urlString pathExtension];
	
    NSURL* url = [NSURL URLWithString:urlString];
    
    if (![url scheme]) {
        if ([urlExtension isEqualToString:@""]) {
            NSLog(@"Run here!");
            NSString *query = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/search?q=%@", query]];
        }else {
            urlString = [@"http://" stringByAppendingString:urlString];
            //self.OpenURLText.stringValue = urlString;
            url = [NSURL URLWithString:urlString];
        }
    }
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [self.WebPage.mainFrame loadRequest:req];
}

- (IBAction)setRefreshInterval:(id)sender {
    
    int selected = [(NSComboBoxCell*)sender indexOfSelectedItem];
	int mins = 0;

    
	
	if ( selected == 1 ){
        NSLog(@"Fired!!!!!!!!!");
		mins = 1;
    }
	else if ( selected == 2 ){
        NSLog(@"Fired!!!!!!!!!");
		mins = 2;
    }
	else if ( selected == 3 ){
        NSLog(@"Fired!!!!!!!!!");
		mins = 5;
    }
	else if ( selected == 4 ){
        NSLog(@"Fired!!!!!!!!!");
		mins = 10;
    }
	else if ( selected == 5 ){
        NSLog(@"Fired!!!!!!!!!");
		mins = 15;
    }
	else if ( selected == 6 ){
        NSLog(@"Fired!!!!!!!!!");
		mins = 30;
    }
	else if ( selected == 7 ){
        NSLog(@"Fired!!!!!!!!!");
		mins = 60;
    }
	else if ( selected == 8 ){
        NSLog(@"Fired!!!!!!!!!");
		mins = 2 * 60;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:selected forKey:@"RefreshSelection"];
    [[NSUserDefaults standardUserDefaults] setInteger:mins forKey:@"RefreshInterval"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    [self startTimer:mins];
    
}

- (void)startTimer:(int)mins
{
    
	if ( timer )
	{
		[timer invalidate];
		timer = nil;
	}
	
	if ( mins == 0 ){
        NSLog(@"Starting Timer!");
		return;
    }
	timer = [NSTimer scheduledTimerWithTimeInterval:(mins * 60) target:self selector:@selector(refreshTimerFired:) userInfo:nil repeats:YES];
}

- (void)refresh:(id)sender
{
	[[WebPage mainFrame] reload];
    NSLog(@"Refreshing...");
}


- (void)refreshTimerFired:(NSTimer*)inTimer
{
	//NSLog(@"reloading page...");
	[self refresh:self];
}


-(IBAction)toggleLaunchAtLogin:(id)sender
{
    int clickedSegment = [sender selectedSegment];
    if (clickedSegment == 0) { // ON
        // Turn on launch at login
        if (SMLoginItemSetEnabled((__bridge CFStringRef)@"com.Firaenix.DeskBrowser-Helper", YES)){
            NSAlert *notice = [NSAlert alertWithMessageText:@"Notice"
                                              defaultButton:@"OK"
                                            alternateButton:nil
                                                otherButton:nil
                                  informativeTextWithFormat:@"If you want to turn off automatic login for DeskBrowser, you must disable it via DeskBrowser, it will not appear in the Login items list in System Preferences."];
            [notice runModal];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LaunchAtLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)@"com.Firaenix.DeskBrowser-Helper", YES)) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"An error ocurred"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"Couldn't add Helper App to launch at login item list."];
            [alert runModal];
        }
    }
    if (clickedSegment == 1) { // OFF
        // Turn off launch at login
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LaunchAtLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)@"com.Firaenix.DeskBrowser-Helper", NO)) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"An error ocurred"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"Couldn't remove Helper App from launch at login item list."];
            [alert runModal];
        }
    }
}


//----------------------------------------------------------

- (BOOL)inFullScreenMode {
    NSApplicationPresentationOptions opts = [[NSApp sharedApplication ] presentationOptions];
    if ( opts & NSApplicationPresentationFullScreen) {
        /* Set Window collection settings to NSWindowCollectionBehaviourDefault
           Set Window Opacity to 1 (full)
           Set IgnoresMouseEvents to False
        */
        return YES;
    }
    return NO;
}
/*
 ----------------------------------NOTE IF THIS IS RELEASED, IT CAUSES SIGABRT ON STARTUP--------------------------------
 
-(void)release{
    //[launchAtLoginButton release];
    [MainWindow release];
}*/

//all code below here is to write and retrieve cached information files from the users Core Data Library files and some other house cleaning initialisation work for the Cocoa framework.


/**
    Returns the directory the application uses to store the Core Data store file. This code uses a directory named "DeskBrowser" in the user's Library directory.
 */
- (NSURL *)applicationFilesDirectory {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *libraryURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    return [libraryURL URLByAppendingPathComponent:@"DeskBrowser"];
}

/**
    Creates if necessary and returns the managed object model for the application.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel) {
        return __managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DeskBrowser" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
    Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator) {
        return __persistentStoreCoordinator;
    }

    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
        
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    else {
        if ([[properties objectForKey:NSURLIsDirectoryKey] boolValue] != YES) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]]; 
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"DeskBrowser.storedata"];
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        __persistentStoreCoordinator = nil;
        return nil;
    }

    return __persistentStoreCoordinator;
}

/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext) {
        return __managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];

    return __managedObjectContext;
}

/**
    Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}

/**
    Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
 */
- (IBAction)saveAction:(id)sender {
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    // Save changes in the application's managed object context before the application terminates.
    //[[NSUserDefaults standardUserDefaults] setURL:[NSURL URLWithString:[self.WebPage mainFrameURL]] forKey:@"LastWebPage"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.WebPage mainFrameURL] forKey:@"LastWebPage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    if (!__managedObjectContext) {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end