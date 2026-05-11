# Flutter-specific
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Dart/Flutter internals
-dontwarn io.flutter.embedding.**

# Keep annotations
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
-keepattributes Exceptions

# SQLite (drift/sqlite3)
-keep class org.sqlite.** { *; }
-keep class sqlite3.** { *; }

# Hive
-keep class ** extends com.google.crypto.tink.** { *; }

# OkHttp / Dio networking
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }

# Gson / JSON serialization
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Flutter Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Home Widget
-keep class es.antonborri.home_widget.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.** { *; }

# Cached Network Image
-keep class com.baseflow.** { *; }

# Connectivity Plus
-keep class dev.fluttercommunity.plus.connectivity.** { *; }

# InAppWebView
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}
