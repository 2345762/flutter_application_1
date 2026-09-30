# Firebase AI Setup Guide

This document outlines the manual steps required to set up Firebase AI Logic for the AI Tutor feature in the Flight Operations Officer study app.

## Prerequisites

- Firebase project created and configured
- Flutter app with Firebase Core already initialized
- Netlify domain ready for App Check configuration

## Manual Firebase Console Steps

### 1. Enable Firebase AI Logic

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Build** → **AI Logic** → **Get Started**
4. Click **Enable AI Logic** for your project
5. Select the pricing plan (Spark/Blaze) - AI Logic requires Blaze plan for production use
6. Accept the terms and conditions

### 2. Enable Gemini Developer API

1. In Firebase Console, go to **Build** → **AI Logic** → **Models**
2. Ensure **Gemini Developer API** is enabled
3. Note: The app uses `gemini-2.5-flash` model
4. Verify that the model is available in your region

### 3. Configure App Check for Web

Since this is a Flutter web app deployed on Netlify, you need to configure App Check with reCAPTCHA:

1. Go to **Build** → **App Check** in Firebase Console
2. Click **Get Started** 
3. Select **Web apps** as your platform
4. Choose **reCAPTCHA v3** as the App Check provider
5. Register your Netlify domain:
   - Enter your Netlify domain (e.g., `your-app.netlify.app`)
   - Add any custom domains if applicable
6. Copy the **reCAPTCHA Site Key** - you'll need this for initialization
7. Copy the **App Check Token** for verification

### 4. Restrict App Check to Your Netlify Domain

To prevent abuse and ensure only your Netlify app can use the AI service:

1. In **App Check** settings, go to **App Check tokens**
2. Find your web app token
3. Click on the token to view details
4. Ensure the domain restrictions are set to your Netlify domain
5. Enable **Token refresh** for web apps

### 5. Configure Firebase AI Security Rules

Navigate to **Build** → **AI Logic** → **Security** and configure:

1. **Authentication Requirement**: Ensure requests require authenticated users
2. **Rate Limiting**: Set appropriate rate limits to prevent abuse
3. **Content Filtering**: Enable safety filters for educational content
4. **Quota Management**: Monitor and set daily/monthly quotas

### 6. Add Firebase AI Initialization to Your App

In your `main.dart`, ensure Firebase AI is properly initialized alongside Firebase Core:

```dart
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

// In your main() function after Firebase.initializeApp():
await FirebaseAppCheck.instance.activate(
  webRecaptchaSiteKey: 'YOUR_RECAPTCHA_SITE_KEY',
);

// Firebase AI will be automatically available via FirebaseAI.googleAI()
```

## Important Security Notes

### ⚠️ Security Considerations

1. **No API Keys in Client Code**: Never hardcode Gemini API keys or Firebase secrets in your Flutter code. Firebase AI Logic handles authentication via Firebase.

2. **App Check is Mandatory**: Always use App Check to prevent unauthorized access to your AI service.

3. **Domain Restriction**: Restrict App Check tokens to your specific Netlify domain to prevent abuse from other sites.

4. **Authentication**: Consider requiring user authentication for AI Tutor access to track usage and prevent abuse.

5. **Rate Limiting**: Implement both client-side (the 3-second cooldown in the service) and server-side rate limiting.

6. **Cost Monitoring**: Monitor Firebase AI usage costs, as AI API calls can accumulate charges.

## Testing the Setup

### Local Development

For local testing, you may need to:
1. Use Firebase emulators if available for AI Logic
2. Temporarily disable App Check (only for development)
3. Use test API keys with strict quotas

### Production Testing

1. Deploy to Netlify
2. Verify App Check is working by checking Firebase Console logs
3. Test AI Tutor feature with various questions
4. Monitor usage and costs in Firebase Console

## Troubleshooting

### Common Issues

**"Firebase AI not enabled"**
- Ensure AI Logic is enabled in Firebase Console
- Check your Firebase project billing plan (Blaze required)

**"App Check token invalid"**
- Verify reCAPTCHA site key is correct
- Check domain restrictions in App Check settings
- Ensure your Netlify domain is properly registered

**"Quota exceeded"**
- Check Firebase AI quotas in Console
- Monitor usage patterns
- Consider implementing additional rate limiting

**"Network error"**
- Verify internet connectivity
- Check Firebase project region availability
- Ensure CORS settings allow requests from your domain

## Monitoring and Maintenance

1. **Usage Monitoring**: Regularly check AI Logic usage in Firebase Console
2. **Cost Alerts**: Set up billing alerts for unexpected usage spikes
3. **Error Tracking**: Monitor Firebase AI errors and adjust security rules as needed
4. **Performance**: Track response times and optimize prompts if needed

## Support Resources

- [Firebase AI Logic Documentation](https://firebase.google.com/docs/ai-logic)
- [Firebase App Check Documentation](https://firebase.google.com/docs/app-check)
- [Firebase Console Support](https://console.firebase.google.com/support)
- [FlutterFire GitHub Issues](https://github.com/firebase/flutterfire/issues)