# Android and Firebase (Firestore) issue
This is a demo code project to illustrate a performance issue encountered when using Firebase/Firestore with Flutter on Android devices. To test, clone the repository and run the app.


## The context
I've developed a Flutter app that runs on both Android and iOS devices. The app loads a list of documents from a collection stored in Firestore.


## The problem
I've observed significantly longer loading times on Android devices. I've conducted numerous tests using simulators, emulators, and real devices across various Android and iOS versions. While the tests consistently yielded fast results on iOS, the performance on Android real devices was considerably poorer. The performance further deteriorates when adding some `orderBy` on the request.


## Test result sample (with real devices)
| OS      | Fields | Documents | Duration |
|---------|--------|-----------|----------|
| IOS     | 10     | 2750      | 0.5sec   |
| ANDROID | 10     | 2750      | 2.8sec   |
| IOS     | 10     | 4795      | 0.7sec   |
| ANDROID | 10     | 4795      | 3.5sec   |


## How to reproduce and test ?
1) Download the code from my [Github]().
2) Retrieve the necessary packages.
3) Run the app on a real device (results may not be consistent on emulators).

Within the running app, there are several buttons that allow you to test the calls. You can view the results either directly in the app or within the logs.


## Troubleshooting
During testing, you might face issues if limits are reached on the Firebase demo project. If that happens, consider setting up your own Firebase project. Create two collections: `products10` and `product50`, and populate them with documents and random data. You can find CSV files with the necessary data in the project at `projectRoot/data`.


To set up your project, refer to the following documentation:
- [FirebaseCLI](https://firebase.google.com/docs/cli?hl=fr)
- [Firestore](https://firebase.google.com/docs/firestore?hl=fr)


## Packages used
- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- [firebase_core](https://pub.dev/packages/firebase_core)
