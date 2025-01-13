# Campus Life Assistant App

Welcome to the **Campus Life Assistant App**, a project designed to enhance student life by providing features such as class schedule management, event notifications, assignment tracking, and more. Follow this guide to understand how to use the app and review the testing outputs.

---

## Getting Started

### Installation
1. **Download the App**: Locate the `.apk` file from the GitHub repository or the shared distribution link.
2. **Install the App**:
   - On your Android device, go to `Settings > Security > Install Unknown Apps` and enable installations from your source.
   - Open the `.apk` file and follow the prompts to install the app.

### Sign Up and Login
- **Sign Up**:
   - Open the app and click **Sign Up**.
   - Enter your email address, password, and other required details.
   - Once signed up, you’ll be redirected to the login screen.
- **Login**:
   - Use your registered email and password to log in.

---

## Features and Usage

### 1. Class Schedule Management
- **Add Classes**:
   - Navigate to the **Schedule** tab.
   - Click the **Add Class** button, input the class details (name, time, day), and save.
- **Edit or Delete Classes**:
   - Select a class from your schedule.
   - Use the **Edit** or **Delete** options to modify or remove the class.
- **Sync Across Devices**:
   - Ensure you are connected to the internet to sync your schedule with Cloud Firestore.

### 2. Offline Access
- All schedule and event data is stored locally using **SQFlite**, allowing you to access your information without an internet connection.

### 3. Event Notifications
- **Receive Notifications**:
   - The app sends reminders for upcoming events, deadlines, and class schedules using Firebase Cloud Messaging (FCM).
- **Customize Notifications**:
   - Go to **Settings > Notifications** to enable or disable specific notifications.

### 4. Assignment Tracker
- **Add Assignments**:
   - Navigate to the **Assignments** section.
   - Click **Add Assignment**, provide details (title, due date), and save.
- **Set Reminders**:
   - The app uses local notifications to remind you of approaching deadlines.
- **Offline Support**:
   - Assignments are stored locally and synced with Cloud Firestore when online.

### 5. Study Group Finder
- **Create a Group**:
   - Go to the **Study Groups** tab and select **Create Group**.
   - Add a group name and description, and invite members.
- **Join/Leave Groups**:
   - Browse available groups and join one that suits your needs.
   - Leave a group by selecting the **Leave Group** option in the group details.

### 6. Feedback System
- **Submit Feedback**:
   - Navigate to the **Feedback** section.
   - Provide feedback for courses, professors, or campus services.
   - Submit your rating and comments.
- All feedback is securely stored in the Cloud Firestore database.

### 7. User Interface
- Enjoy a user-friendly and intuitive interface designed for effortless navigation.

### 8. Troubleshooting
- If you encounter bugs or issues, refer to the **Help** section within the app for common fixes.
- Contact support using the **Feedback** form for unresolved issues.

---

## Testing Output

Below is a summary of the testing process and results for each feature of the app.

### 1. Firebase Authentication
| Test Scenario                      | Expected Outcome                    | Actual Outcome                  | Status   |
|------------------------------------|--------------------------------------|----------------------------------|----------|
| User Sign-Up with valid email/password | Account successfully created         | Account successfully created    | ✅ Pass  |
| User Login with valid credentials  | User logged in and redirected to home screen | Login successful               | ✅ Pass  |
| User Login with invalid credentials | Error message displayed ("Invalid credentials") | Error message displayed       | ✅ Pass  |
| Forgot Password                    | Password reset email sent            | Email sent successfully         | ✅ Pass  |

### 2. Class Schedule Management
| Test Scenario                      | Expected Outcome                    | Actual Outcome                  | Status   |
|------------------------------------|--------------------------------------|----------------------------------|----------|
| Adding a new class                 | Class added to schedule and synced to Firestore | Successfully added and synced  | ✅ Pass  |
| Editing an existing class          | Updated class details displayed      | Details updated correctly       | ✅ Pass  |
| Deleting a class                   | Class removed from schedule          | Class removed successfully      | ✅ Pass  |
| Offline access to schedule         | Schedule displayed using local storage | Successfully accessed offline  | ✅ Pass  |

### 3. Offline Storage Integration (SQFlite)
| Test Scenario                      | Expected Outcome                    | Actual Outcome                  | Status   |
|------------------------------------|--------------------------------------|----------------------------------|----------|
| Adding data while offline          | Data saved locally                   | Data saved in SQFlite           | ✅ Pass  |
| Syncing data after reconnecting    | Data synced to Firestore             | Data synced correctly           | ✅ Pass  |

### 4. Event Notifications (FCM)
| Test Scenario                      | Expected Outcome                    | Actual Outcome                  | Status   |
|------------------------------------|--------------------------------------|----------------------------------|----------|
| Receiving a push notification      | Notification appears on the device   | Notification received           | ✅ Pass  |
| Customizing notification settings  | User preferences saved and applied   | Settings updated successfully   | ✅ Pass  |

### 5. Assignment Tracker
| Test Scenario                      | Expected Outcome                    | Actual Outcome                  | Status   |
|------------------------------------|--------------------------------------|----------------------------------|----------|
| Adding a new assignment            | Assignment added with reminders set | Successfully added and reminders working | ✅ Pass  |
| Accessing assignments offline      | Assignments displayed using local storage | Successfully displayed         | ✅ Pass  |
| Deadline reminder notification     | Notification received before the deadline | Reminder received on time      | ✅ Pass  |

### 6. Study Group Finder
| Test Scenario                      | Expected Outcome                    | Actual Outcome                  | Status   |
|------------------------------------|--------------------------------------|----------------------------------|----------|
| Creating a new study group         | Group created and visible to others  | Group created successfully      | ✅ Pass  |
| Joining a study group              | User added to group                  | Successfully joined the group   | ✅ Pass  |
| Leaving a study group              | User removed from group              | Successfully left the group     | ✅ Pass  |

### 7. Feedback System
| Test Scenario                      | Expected Outcome                    | Actual Outcome                  | Status   |
|------------------------------------|--------------------------------------|----------------------------------|----------|
| Submitting feedback                | Feedback saved to Firestore          | Successfully submitted          | ✅ Pass  |
| Viewing submitted feedback         | Feedback retrieved from Firestore    | Successfully retrieved          | ✅ Pass  |

### 8. Final Integration & UI Enhancements
| Test Scenario                      | Expected Outcome                    | Actual Outcome                  | Status   |
|------------------------------------|--------------------------------------|----------------------------------|----------|
| Seamless navigation between features | Smooth transitions with no crashes  | Seamless navigation             | ✅ Pass  |
| Polished and user-friendly UI      | Intuitive design and layout          | UI optimized and user-friendly  | ✅ Pass  |

---

## Testing Summary

### Overall Performance
- **Test Environment**: 
  - Device: Android Emulator (API Level 30) & Physical Device (Android 11).
  - Network: Both online and offline scenarios tested.
- **Bug Status**: No critical bugs found during testing.

### Key Highlights
- All features functioned as intended.
- Offline functionality using **SQFlite** performed well under various scenarios.
- Firebase Authentication and FCM notifications worked seamlessly.

---

This concludes the user guide and testing output for the Campus Life Assistant App. Enjoy using the app to simplify your student life!
