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
5. Accept the terms and conditions

### 2. Enable Gemini Developer API

1. In Firebase Console, go to **Build** → **AI Logic** → **Models**
2. Ensure **Gemini Developer API** is enabled
3. Note: The app uses `gemini-2.5-flash` model
4. Verify that the model is available in your region

### 3. Configure App Check for Web (reCAPTCHA Enterprise)

Since this is a Flutter web app deployed on Netlify, you need to configure App Check with reCAPTCHA Enterprise (Fraud Defense):

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Navigate to **Security** → **Fraud Defense** (reCAPTCHA Enterprise)
4. Create a new reCAPTCHA Enterprise key:
   - Label: Flutter Web App
   - Platform: Web
   - Domains: `app-eov.netlify.app` and `localhost`
5. Copy the **reCAPTCHA Enterprise Site Key ID**
6. Go to [Firebase Console](https://console.firebase.google.com/)
7. Navigate to **Build** → **App Check** → **Apps**
8. Register your web app with the reCAPTCHA Enterprise Site Key ID

### 4. Deployment and Verification Order

Follow this exact order:

1. **Deploy code**: Deploy your Flutter web app to Netlify
2. **Check App Check**: Verify App Check is working in Firebase Console (check metrics/logs)
3. **Check APIs metrics**: Monitor AI Logic API usage in Firebase Console
4. **Enforce App Check**: Once verified working, enforce App Check on Firebase AI Logic only
   - **IMPORTANT**: Do NOT enforce App Check on Firestore, Auth, or Storage unless explicitly instructed

### 5. Local Development Testing

For local testing with localhost:

1. Use the App Check debug token
2. Add `FIREBASE_APPCHECK_DEBUG_TOKEN` to your `web/index.html` (as a meta tag or script)
3. **CRITICAL**: NEVER commit this debug token line to the repository
4. Remove or comment out the debug token before committing

## Important Security Notes

### ⚠️ Security Considerations

1. **No API Keys in Client Code**: Never hardcode Gemini API keys or Firebase secrets in your Flutter code. Firebase AI Logic handles authentication via Firebase.

2. **App Check is Mandatory**: Always use App Check to prevent unauthorized access to your AI service.

3. **Domain Restriction**: Restrict reCAPTCHA Enterprise to your specific Netlify domain and localhost to prevent abuse from other sites.

4. **Rate Limiting**: Implement both client-side (the 3-second cooldown in the service) and server-side rate limiting.

5. **Cost Monitoring**: Monitor Firebase AI usage costs, as AI API calls can accumulate charges.

## Testing the Setup

### Production Testing

1. Deploy to Netlify
2. Verify App Check is working by checking Firebase Console logs
3. Test AI Tutor feature with various questions
4. Monitor usage and costs in Firebase Console

## Troubleshooting

### Common Issues

**"Firebase AI not enabled"**
- Ensure AI Logic is enabled in Firebase Console

**"App Check token invalid"**
- Verify reCAPTCHA Enterprise site key ID is correct
- Check domain restrictions in Google Cloud Console
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
3. **Error Tracking**: Monitor Firebase AI errors and adjust as needed
4. **Performance**: Track response times and optimize prompts if needed

## Support Resources

- [Firebase AI Logic Documentation](https://firebase.google.com/docs/ai-logic)
- [Firebase App Check Documentation](https://firebase.google.com/docs/app-check)
- [Firebase Console Support](https://console.firebase.google.com/support)
- [FlutterFire GitHub Issues](https://github.com/firebase/flutterfire/issues)
