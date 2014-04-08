BackGroundFetchData
===================

fetch data when app is in Background

-This works best for apps that have frequent content updates, like social networking, news, or weather apps.

-The first step in enabling Background Fetch is to specify that you’ll use the feature in the UIBackgroundModes key in your info plist. The easiest way to do this is to use the new Capabilities tab in Xcode 5’s project editor, which includes a Background Modes section for easy configuration of multitasking options.

-The final step is to implement the following method in your application delegate:

  - (void)application:(UIApplication *)application 
      performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler

- For testing Background Fetches:
    
    -There are two ways you can simulate a background fetch. 
    
      The easiest method is to run your application from Xcode and click Simulate Background Fetch under Xcode’s Debug menu while your app is running.
      second method is :Begin by clicking in your project schemes, and then by selecting the Manage Schemes… option.In the window that appears, make sure that the BackgroundFetchDemo scheme is selected, and then go to the small gear icon lying at the bottom-left side of the window. From the menu that appears, select the Duplicate option.
      A new window comes up, where you should perform the following steps:

      1.Set the BackgroundFetchDemo_Test as the name of the scheme (or any other name you like).
      
      2.At the left pane, make sure that the Run options is selected.
      
      3.In the main window area, select the Options tab.
      
      4.Select the Launch due to a background fetch event checkbox.
      
      Click on the OK, and then again OK to close all windows.

      On the Xcode toolbar, select the new scheme and then run the application. You’ll notice that the app won’t show on the Simulator, however on the debugger you’ll see a message regarding the result of the background fetch. If new data is found, then just click on the app’s icon on the Simulator.
      
-To run the application in normal mode again, just select the BackgroundFetchDemo scheme (the default one), and you are ready.       
