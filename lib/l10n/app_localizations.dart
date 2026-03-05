import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @continueCapturingMoments.
  ///
  /// In en, this message translates to:
  /// **'Continue capturing your moments'**
  String get continueCapturingMoments;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your Email'**
  String get enterYourEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @nameMin2.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMin2;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpTitle;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterYourEmailLower.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmailLower;

  /// No description provided for @useAtLeast8.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters with uppercase, lowercase, number, and special character.'**
  String get useAtLeast8;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @signingUp.
  ///
  /// In en, this message translates to:
  /// **'Signing Up...'**
  String get signingUp;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address you used when you join and we\'ll send you instructions to reset your password'**
  String get resetPasswordDescription;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @networkTimeoutTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Network timeout. Please try again.'**
  String get networkTimeoutTryAgain;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent!'**
  String get resetLinkSent;

  /// No description provided for @resetLinkSentDescription.
  ///
  /// In en, this message translates to:
  /// **'If this email exists, reset instructions have been sent.'**
  String get resetLinkSentDescription;

  /// No description provided for @requesting.
  ///
  /// In en, this message translates to:
  /// **'Requesting...'**
  String get requesting;

  /// No description provided for @requestPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Request password Reset'**
  String get requestPasswordReset;

  /// No description provided for @haveResetToken.
  ///
  /// In en, this message translates to:
  /// **'Have a reset token? '**
  String get haveResetToken;

  /// No description provided for @resetNow.
  ///
  /// In en, this message translates to:
  /// **'Reset now'**
  String get resetNow;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'You remember your password. '**
  String get rememberPassword;

  /// No description provided for @resetLinkSentLongDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to your email address, please check your inbox and spam folder to proceed'**
  String get resetLinkSentLongDescription;

  /// No description provided for @didntReceiveLink.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t received the link. '**
  String get didntReceiveLink;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyYourEmail;

  /// No description provided for @verifyEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and click the verification link before signing in.'**
  String get verifyEmailDescription;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @sendVerificationEmail.
  ///
  /// In en, this message translates to:
  /// **'Send verification email'**
  String get sendVerificationEmail;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent'**
  String get emailSent;

  /// No description provided for @emailSentDescription.
  ///
  /// In en, this message translates to:
  /// **'If this email exists and is unverified, a verification email has been sent.'**
  String get emailSentDescription;

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify now'**
  String get verifyNow;

  /// No description provided for @alreadyVerified.
  ///
  /// In en, this message translates to:
  /// **'I already verified'**
  String get alreadyVerified;

  /// No description provided for @pleaseEnterVerificationToken.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification token'**
  String get pleaseEnterVerificationToken;

  /// No description provided for @emailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email Verified'**
  String get emailVerified;

  /// No description provided for @emailVerifiedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your email has been verified successfully.'**
  String get emailVerifiedDescription;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @verifyTokenDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your verification token from email to activate your account.'**
  String get verifyTokenDescription;

  /// No description provided for @enterVerificationToken.
  ///
  /// In en, this message translates to:
  /// **'Enter verification token'**
  String get enterVerificationToken;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @resendVerificationEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend verification email'**
  String get resendVerificationEmail;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @resetTokenAndPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the reset token from your email and your new password.'**
  String get resetTokenAndPasswordDescription;

  /// No description provided for @enterResetToken.
  ///
  /// In en, this message translates to:
  /// **'Enter reset token'**
  String get enterResetToken;

  /// No description provided for @resetToken.
  ///
  /// In en, this message translates to:
  /// **'Reset Token'**
  String get resetToken;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @passwordResetSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Successful'**
  String get passwordResetSuccessful;

  /// No description provided for @passwordResetSuccessfulDescription.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated. Please sign in.'**
  String get passwordResetSuccessfulDescription;

  /// No description provided for @resetting.
  ///
  /// In en, this message translates to:
  /// **'Resetting...'**
  String get resetting;

  /// No description provided for @malePoses.
  ///
  /// In en, this message translates to:
  /// **'Male Poses'**
  String get malePoses;

  /// No description provided for @femalePoses.
  ///
  /// In en, this message translates to:
  /// **'Female Poses'**
  String get femalePoses;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String helloUser(Object name);

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @readyForNextPhoto.
  ///
  /// In en, this message translates to:
  /// **'Ready for your next photo?'**
  String get readyForNextPhoto;

  /// No description provided for @poseOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Pose of the Day'**
  String get poseOfTheDay;

  /// No description provided for @tryThisPose.
  ///
  /// In en, this message translates to:
  /// **'Try this pose'**
  String get tryThisPose;

  /// No description provided for @noProfileImageToShow.
  ///
  /// In en, this message translates to:
  /// **'No profile image to show'**
  String get noProfileImageToShow;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Language Updated'**
  String get languageUpdated;

  /// No description provided for @languageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}.'**
  String languageChangedTo(Object language);

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get noName;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No Email'**
  String get noEmail;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountQuestion;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent.\nAll your photos, settings, and profile data will be erased forever.'**
  String get deleteAccountDescription;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'I understand that my data cannot be recovered.'**
  String get deleteAccountConfirm;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account Deleted'**
  String get accountDeleted;

  /// No description provided for @accountDeletedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted successfully.'**
  String get accountDeletedDescription;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyHeading.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy for Posea - Pose Suggesting App'**
  String get privacyPolicyHeading;

  /// No description provided for @privacyPolicyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: March 2026'**
  String get privacyPolicyLastUpdated;

  /// No description provided for @privacyPolicySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get privacyPolicySection1Title;

  /// No description provided for @privacyPolicySection1Body.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Posea, a mobile application developed by Team LUMINA at the Faculty of Applied Sciences, Rajarata University of Sri Lanka.\n\nPosea helps users capture better beach photographs by suggesting suitable poses using artificial intelligence (AI) based on the background environment and lighting conditions.\n\nThis Privacy Policy explains how we collect, use, and protect your information when you use the Posea application.'**
  String get privacyPolicySection1Body;

  /// No description provided for @privacyPolicySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Information We Collect'**
  String get privacyPolicySection2Title;

  /// No description provided for @privacyPolicySection21Title.
  ///
  /// In en, this message translates to:
  /// **'2.1 Account Information'**
  String get privacyPolicySection21Title;

  /// No description provided for @privacyPolicySection21Body.
  ///
  /// In en, this message translates to:
  /// **'When you register in the Posea app, we may collect the following information:\n\n- Full name\n- Email address\n- Password\n- Profile picture (optional)\n\nThis information is required to create and manage your user account.'**
  String get privacyPolicySection21Body;

  /// No description provided for @privacyPolicySection22Title.
  ///
  /// In en, this message translates to:
  /// **'2.2 Image Data'**
  String get privacyPolicySection22Title;

  /// No description provided for @privacyPolicySection22Body.
  ///
  /// In en, this message translates to:
  /// **'Posea allows users to upload or capture images to generate pose suggestions.\n\nThe app may access:\n\n- Photos captured using the device camera\n- Images selected from the device gallery\n\nThese images are used only for pose suggestion analysis and improving the user experience.'**
  String get privacyPolicySection22Body;

  /// No description provided for @privacyPolicySection23Title.
  ///
  /// In en, this message translates to:
  /// **'2.3 Device and Usage Information'**
  String get privacyPolicySection23Title;

  /// No description provided for @privacyPolicySection23Body.
  ///
  /// In en, this message translates to:
  /// **'We may collect limited device information such as:\n\n- Device type\n- Operating system version\n- App performance and usage data\n\nThis helps us improve the reliability and functionality of the application.'**
  String get privacyPolicySection23Body;

  /// No description provided for @privacyPolicySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. How We Use Your Information'**
  String get privacyPolicySection3Title;

  /// No description provided for @privacyPolicySection3Body.
  ///
  /// In en, this message translates to:
  /// **'We use the collected information for the following purposes:\n\n- To create and manage user accounts\n- To authenticate users during login\n- To analyze uploaded images using AI models\n- To generate pose suggestions based on the background environment\n- To display wireframe pose guidance for users\n- To allow users to capture and save photos\n- To improve application performance and user experience\n\nThe AI model analyzes the uploaded background image to identify environment conditions such as lighting and scene type, then retrieves suitable poses from the pose dataset.\n\nLumina_20_21_SRS[1.3]_Revised'**
  String get privacyPolicySection3Body;

  /// No description provided for @privacyPolicySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Camera and Storage Permissions'**
  String get privacyPolicySection4Title;

  /// No description provided for @privacyPolicySection4Body.
  ///
  /// In en, this message translates to:
  /// **'Posea may request the following permissions:\n\nCamera Access\nUsed to:\n- Capture background images\n- Display live camera preview\n- Capture the final photo\n\nGallery / Storage Access\nUsed to:\n- Upload existing images from the gallery\n- Save captured photos to the device gallery\n\nThese permissions are requested only when required for specific features.'**
  String get privacyPolicySection4Body;

  /// No description provided for @privacyPolicySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Data Storage and Security'**
  String get privacyPolicySection5Title;

  /// No description provided for @privacyPolicySection5Body.
  ///
  /// In en, this message translates to:
  /// **'User data is stored securely in the application database.\n\nWe implement reasonable security measures to protect your information from:\n\n- Unauthorized access\n- Data loss\n- Misuse or alteration\n\nPasswords are stored securely and protected using standard authentication practices.'**
  String get privacyPolicySection5Body;

  /// No description provided for @privacyPolicySection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Data Sharing'**
  String get privacyPolicySection6Title;

  /// No description provided for @privacyPolicySection6Body.
  ///
  /// In en, this message translates to:
  /// **'Posea does not sell, rent, or share personal information with third parties.\n\nHowever, limited information may be shared in the following situations:\n\n- When required by law\n- To protect the security of the system\n- For system maintenance and technical support'**
  String get privacyPolicySection6Body;

  /// No description provided for @privacyPolicySection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. User Control Over Data'**
  String get privacyPolicySection7Title;

  /// No description provided for @privacyPolicySection7Body.
  ///
  /// In en, this message translates to:
  /// **'Users have full control over their account and data. Through the Manage Account feature, users can:\n\n- Update personal information\n- Change their password\n- Log out from the application\n- Delete their account permanently\n\nOnce an account is deleted, the associated data cannot be recovered.\n\nLumina_20_21_SRS[1.3]_Revised'**
  String get privacyPolicySection7Body;

  /// No description provided for @privacyPolicySection8Title.
  ///
  /// In en, this message translates to:
  /// **'8. Photo Storage'**
  String get privacyPolicySection8Title;

  /// No description provided for @privacyPolicySection8Body.
  ///
  /// In en, this message translates to:
  /// **'Photos captured using the Posea app are saved only on the user\'s device gallery unless the user chooses to store them elsewhere.\n\nThe application does not automatically publish or share photos online.'**
  String get privacyPolicySection8Body;

  /// No description provided for @privacyPolicySection9Title.
  ///
  /// In en, this message translates to:
  /// **'9. Children\'s Privacy'**
  String get privacyPolicySection9Title;

  /// No description provided for @privacyPolicySection9Body.
  ///
  /// In en, this message translates to:
  /// **'Posea is not intended for children under the age of 13.\nWe do not knowingly collect personal information from children.\n\nIf we discover that a child has provided personal information, we will delete it immediately.'**
  String get privacyPolicySection9Body;

  /// No description provided for @privacyPolicySection10Title.
  ///
  /// In en, this message translates to:
  /// **'10. Changes to This Privacy Policy'**
  String get privacyPolicySection10Title;

  /// No description provided for @privacyPolicySection10Body.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy from time to time to reflect changes in the application or legal requirements.\n\nUsers will be notified of important updates within the application.'**
  String get privacyPolicySection10Body;

  /// No description provided for @privacyPolicySection11Title.
  ///
  /// In en, this message translates to:
  /// **'11. Contact Information'**
  String get privacyPolicySection11Title;

  /// No description provided for @privacyPolicySection11Body.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about this Privacy Policy, please contact:\n\nTeam LUMINA\nFaculty of Applied Sciences\nRajarata University of Sri Lanka'**
  String get privacyPolicySection11Body;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @logOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Log Out?'**
  String get logOutQuestion;

  /// No description provided for @logOutDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?\nYou\'ll need to enter your credentials to log back in.'**
  String get logOutDescription;

  /// No description provided for @removeProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Remove profile image'**
  String get removeProfileImage;

  /// No description provided for @removed.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get removed;

  /// No description provided for @profileImageRemovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile image removed successfully'**
  String get profileImageRemovedSuccessfully;

  /// No description provided for @removeProfileImageQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove profile image?'**
  String get removeProfileImageQuestion;

  /// No description provided for @removeProfileImageAfterSave.
  ///
  /// In en, this message translates to:
  /// **'Your profile image will be removed after you save changes.'**
  String get removeProfileImageAfterSave;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your Full Name'**
  String get enterYourFullName;

  /// No description provided for @writeSomething.
  ///
  /// In en, this message translates to:
  /// **'Write Something..........'**
  String get writeSomething;

  /// No description provided for @bioAlreadyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Bio is already empty'**
  String get bioAlreadyEmpty;

  /// No description provided for @cleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get cleared;

  /// No description provided for @bioClearedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Bio cleared successfully'**
  String get bioClearedSuccessfully;

  /// No description provided for @clearBio.
  ///
  /// In en, this message translates to:
  /// **'Clear Bio'**
  String get clearBio;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @newPasswordDifferentDescription.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from\nprevious password'**
  String get newPasswordDifferentDescription;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @enterYourOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your Old Password'**
  String get enterYourOldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterYourNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your New Password'**
  String get enterYourNewPassword;

  /// No description provided for @enterPasswordAgain.
  ///
  /// In en, this message translates to:
  /// **'Enter again password'**
  String get enterPasswordAgain;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password Changed'**
  String get passwordChanged;

  /// No description provided for @passwordChangedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated successfully'**
  String get passwordChangedDescription;

  /// No description provided for @beachImageWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Image may not be beach'**
  String get beachImageWarningTitle;

  /// No description provided for @beachImageWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'This image does not look like a beach. Upload anyway?'**
  String get beachImageWarningMessage;

  /// No description provided for @uploadAnyway.
  ///
  /// In en, this message translates to:
  /// **'Upload anyway'**
  String get uploadAnyway;

  /// No description provided for @beachImageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please upload a beach image.'**
  String get beachImageRequired;

  /// No description provided for @uploadBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Background'**
  String get uploadBackgroundTitle;

  /// No description provided for @uploadBackgroundCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload background'**
  String get uploadBackgroundCardTitle;

  /// No description provided for @uploadBackgroundCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select photo from your gallery\nor use the camera'**
  String get uploadBackgroundCardSubtitle;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get userNotAuthenticated;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
