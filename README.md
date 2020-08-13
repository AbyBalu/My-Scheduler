# My-Scheduler

Developed a simple cross platform Flutter app namely My scheduler where we can schedule our different tasks accordingly. It has login, logout functionality supported by Firebase. Signing in or signing up can be done through different modes like email, google account, or phone number. It has the provision of adding and deleting different tasks and are stored in Firestore for better reliability.

For the working of the project you must add your own google-services.json and GoogleService-Info.plist file from your firebase project as I have removed mine.

Implementation Guide:-

1 - Project

   - Open the Project in your android studio.
   - IMPORTANT: Change the Package Name. (https://stackoverflow.com/questions/16804093/android-studio-rename-package).
   
2 - Firebase Panel

   - Create Firebase Project (https://console.firebase.google.com/).
   - Import the file google-service.json into your project.
   - Connect to firebase console authentication and database from your IDE.
   - In firebase Storage Rules, change the value of allow read, write: from if request.auth != null to if true;.
