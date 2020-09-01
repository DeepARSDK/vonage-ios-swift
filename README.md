# vonage-ios-swift

This sample application demonstrates how to use the DeepAR SDK to add face filters and masks to your video call using the [Vonage Video(formerly OpenTok) iOS SDK](https://tokbox.com/developer/sdks/ios/).

To run the sample:

1) Sign up at [DeepAR](https://developer.deepar.ai) and create a project.
2) Copy the license key and paste it to `ViewController.m` (instead of your_license_key_here string)
3) Download the DeepAR SDK from https://developer.deepar.ai and copy the DeepAR.framework into vonage-ios-objc folder
4) Run pod install
5) Sign up on https://www.vonage.com/communications-apis/video and either create a new project or use an existing project. create a project
6) Go to your project page and scroll down to the Project Tools section. From there, you can generate a session ID and token manually. Use the project’s API key along with the session ID and token you generated.
7) To quickly test the demo go to https://tokbox.com/developer/tools/playground/ on another device (e.g. desktop) to create a conversation room where you can see the feed from test app:
	- On the playground choose "Create new session"
	- Enter your API key
	- Choose latest JS SDK and leave other options unchanged
	- Click "Create" and on the next screen select Connect
	- Now in your session playground screen select "Publish stream" and "Continue" in the next dialog (you don't need to set any options)
	- Now you should be able to view the stream from your device where you created the Playground session and if you run the example iOS app the app should connect once you click Start call (and give all required permissions to the app, like microphone)


Check this tutorial for more in-depth explanation: https://www.nexmo.com/blog/2020/09/01/create-custom-ar-filters-with-vonage-video-api-and-deepar
