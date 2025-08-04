#!/bin/bash

echo "🚀 Running Wayagram in Production Mode..."
flutter run \
  --dart-define=ENVIRONMENT=production \
  --dart-define=API_BASE_URL=https://services.wayagram.ng/ \
  --dart-define=APP_NAME="Wayagram" \
  --dart-define=BUNDLE_ID=ng.wayagram \
  --dart-define=APP_WEB_URL=https://wayagram.ng/ \
  --dart-define=FIREBASE_ANDROID_APP_ID=1:276195200870:android:948a35f4f34ec7978b42a7\
  --dart-define=FIREBASE_IOS_APP_ID=1:276195200870:ios:c5b085cee4bdadf88b42a7