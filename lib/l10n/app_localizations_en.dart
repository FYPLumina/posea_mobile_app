// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get favourites => 'Favourites';

  @override
  String get profile => 'Profile';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get continueCapturingMoments => 'Continue capturing your moments';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Enter your Email';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get forgotPasswordQuestion => 'Forgot password?';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign up';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameMin2 => 'Name must be at least 2 characters';

  @override
  String get confirmPasswordRequired => 'Confirm Password is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get signUpTitle => 'Sign Up';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get name => 'Name';

  @override
  String get enterYourEmailLower => 'Enter your email';

  @override
  String get useAtLeast8 =>
      'Use at least 8 characters with uppercase, lowercase, number, and special character.';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get signingUp => 'Signing Up...';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signIn => 'Sign in';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordDescription =>
      'Enter the email address you used when you join and we\'ll send you instructions to reset your password';

  @override
  String get pleaseEnterYourEmail => 'Please enter your email';

  @override
  String get networkTimeoutTryAgain => 'Network timeout. Please try again.';

  @override
  String get resetLinkSent => 'Reset link sent!';

  @override
  String get resetLinkSentDescription =>
      'If this email exists, reset instructions have been sent.';

  @override
  String get requesting => 'Requesting...';

  @override
  String get requestPasswordReset => 'Request password Reset';

  @override
  String get haveResetToken => 'Have a reset token? ';

  @override
  String get resetNow => 'Reset now';

  @override
  String get rememberPassword => 'You remember your password. ';

  @override
  String get resetLinkSentLongDescription =>
      'We\'ve sent a password reset link to your email address, please check your inbox and spam folder to proceed';

  @override
  String get didntReceiveLink => 'Didn\'t received the link. ';

  @override
  String get resend => 'Resend';

  @override
  String get verifyYourEmail => 'Verify your email';

  @override
  String get verifyEmailDescription =>
      'Please check your inbox and click the verification link before signing in.';

  @override
  String get sending => 'Sending...';

  @override
  String get sendVerificationEmail => 'Send verification email';

  @override
  String get emailSent => 'Email Sent';

  @override
  String get emailSentDescription =>
      'If this email exists and is unverified, a verification email has been sent.';

  @override
  String get verifyNow => 'Verify now';

  @override
  String get alreadyVerified => 'I already verified';

  @override
  String get pleaseEnterVerificationToken => 'Please enter verification token';

  @override
  String get emailVerified => 'Email Verified';

  @override
  String get emailVerifiedDescription =>
      'Your email has been verified successfully.';

  @override
  String get verifyEmail => 'Verify Email';

  @override
  String get verifyTokenDescription =>
      'Enter your verification token from email to activate your account.';

  @override
  String get enterVerificationToken => 'Enter verification token';

  @override
  String get verifying => 'Verifying...';

  @override
  String get resendVerificationEmail => 'Resend verification email';

  @override
  String get setNewPassword => 'Set New Password';

  @override
  String get resetTokenAndPasswordDescription =>
      'Enter the reset token from your email and your new password.';

  @override
  String get enterResetToken => 'Enter reset token';

  @override
  String get resetToken => 'Reset Token';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get passwordResetSuccessful => 'Password Reset Successful';

  @override
  String get passwordResetSuccessfulDescription =>
      'Your password has been updated. Please sign in.';

  @override
  String get resetting => 'Resetting...';

  @override
  String get malePoses => 'Male Poses';

  @override
  String get femalePoses => 'Female Poses';

  @override
  String helloUser(Object name) {
    return 'Hello, $name!';
  }

  @override
  String get user => 'User';

  @override
  String get readyForNextPhoto => 'Ready for your next photo?';

  @override
  String get poseOfTheDay => 'Pose of the Day';

  @override
  String get tryThisPose => 'Try this pose';

  @override
  String get noProfileImageToShow => 'No profile image to show';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageUpdated => 'Language Updated';

  @override
  String languageChangedTo(Object language) {
    return 'Language changed to $language.';
  }

  @override
  String get noName => 'No Name';

  @override
  String get noEmail => 'No Email';

  @override
  String get settings => 'Settings';

  @override
  String get changePassword => 'Change password';

  @override
  String get language => 'Language';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountQuestion => 'Delete Account?';

  @override
  String get deleteAccountDescription =>
      'This action is permanent.\nAll your photos, settings, and profile data will be erased forever.';

  @override
  String get deleteAccountConfirm =>
      'I understand that my data cannot be recovered.';

  @override
  String get accountDeleted => 'Account Deleted';

  @override
  String get accountDeletedDescription =>
      'Your account has been deleted successfully.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get logOut => 'Log Out';

  @override
  String get logOutQuestion => 'Log Out?';

  @override
  String get logOutDescription =>
      'Are you sure you want to sign out?\nYou\'ll need to enter your credentials to log back in.';

  @override
  String get removeProfileImage => 'Remove profile image';

  @override
  String get removed => 'Removed';

  @override
  String get profileImageRemovedSuccessfully =>
      'Profile image removed successfully';

  @override
  String get removeProfileImageQuestion => 'Remove profile image?';

  @override
  String get removeProfileImageAfterSave =>
      'Your profile image will be removed after you save changes.';

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get enterYourFullName => 'Enter your Full Name';

  @override
  String get writeSomething => 'Write Something..........';

  @override
  String get bioAlreadyEmpty => 'Bio is already empty';

  @override
  String get cleared => 'Cleared';

  @override
  String get bioClearedSuccessfully => 'Bio cleared successfully';

  @override
  String get clearBio => 'Clear Bio';

  @override
  String get saving => 'Saving...';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get updated => 'Updated';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get favorites => 'Favorites';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get newPasswordDifferentDescription =>
      'Your new password must be different from\nprevious password';

  @override
  String get oldPassword => 'Old Password';

  @override
  String get enterYourOldPassword => 'Enter your Old Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get enterYourNewPassword => 'Enter your New Password';

  @override
  String get enterPasswordAgain => 'Enter again password';

  @override
  String get passwordChanged => 'Password Changed';

  @override
  String get passwordChangedDescription =>
      'Your password has been updated successfully';

  @override
  String get beachImageWarningTitle => 'Image may not be beach';

  @override
  String get beachImageWarningMessage =>
      'This image does not look like a beach. Upload anyway?';

  @override
  String get uploadAnyway => 'Upload anyway';

  @override
  String get beachImageRequired => 'Please upload a beach image.';

  @override
  String get uploadBackgroundTitle => 'Upload Background';

  @override
  String get uploadBackgroundCardTitle => 'Upload background';

  @override
  String get uploadBackgroundCardSubtitle =>
      'Select photo from your gallery\nor use the camera';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get userNotAuthenticated => 'User not authenticated';

  @override
  String get done => 'Done';
}
