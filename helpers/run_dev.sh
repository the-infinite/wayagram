#!/bin/bash

echo "🚀 Running Wayagram in Development Mode..."
flutter run \
  --dart-define=ENVIRONMENT=development \
  --dart-define=API_BASE_URL=https://services.wayagram.ng/ \
  --dart-define=APP_NAME="Wayagram Dev" \
  --dart-define=BUNDLE_ID=ng.wayagram.dev \
  --dart-define=APP_WEB_URL=https://wayagram.ng/ \
  --dart-define=FIREBASE_ANDROID_APP_ID=1:276195200870:android:86d92470ee9355f58b42a7 \
  --dart-define=FIREBASE_IOS_APP_ID=1:276195200870:ios:9618ca822e5d47d48b42a7

  