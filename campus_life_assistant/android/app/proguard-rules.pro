# Keep annotations
-keepattributes Signature
-keepattributes *Annotation*

# Keep Firebase and Google classes
-keep class com.google.** { *; }
-keep class com.firebase.** { *; }
-keepnames class com.google.** { *; }
-keepclassmembers class com.google.** { *; }
-dontwarn com.google.**

# Keep Gson SerializedName fields
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
