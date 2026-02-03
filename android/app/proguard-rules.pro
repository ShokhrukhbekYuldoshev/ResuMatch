# Suppress the specific JP2 warning
-dontwarn com.gemalto.jp2.JP2Decoder

# Firebase / Google AI standard keep rules
-keep class com.google.firebase.** { *; }
-keep class com.google.ai.client.generativeai.** { *; }

# Suppress warnings from common libraries that use reflection
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**