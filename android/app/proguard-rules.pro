# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep SharedPreferences
-keep class androidx.preference.** { *; }

# Keep asset loading
-keep class android.content.res.AssetManager { *; }

# Keep image loading libraries
-keep class com.davemorrissey.labs.subscaleview.** { *; }

# Gson specific rules
-keep class com.google.gson.** { *; }
-keep class sun.misc.Unsafe { *; }

# Keep model classes
-keep class com.example.mushaf_noor.models.** { *; }

# General rules for release builds
-dontwarn com.google.common.**
-dontwarn javax.annotation.**
-dontwarn javax.inject.**
-dontwarn sun.misc.Unsafe

# Ignore Play Core missing classes (not used in this app)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }