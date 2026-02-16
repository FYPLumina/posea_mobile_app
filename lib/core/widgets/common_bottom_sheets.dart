import 'package:flutter/material.dart';

Widget buildAccountCreatedSheet({required VoidCallback onGetStarted, VoidCallback? onClose}) {
  return Stack(
    children: [
      CommonBottomSheet(
        icon: const Icon(Icons.check_circle, size: 40, color: Color(0xFF9B8572)),
        title: 'Account Created!',
        description: 'Welcome!\nYour account is ready.\nLet\'s start capturing your moments.',
        buttons: [
          CommonBottomSheetButton(
            text: 'Get Started',
            onPressed: onGetStarted,
            backgroundColor: const Color(0xFF9B8572),
            textColor: Colors.white,
          ),
        ],
      ),
      if (onClose != null)
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close, size: 24, color: Colors.black54),
          ),
        ),
    ],
  );
}

Widget buildSuccessSheet({
  required String title,
  required String description,
  String actionText = 'OK',
  required VoidCallback onAction,
}) {
  return CommonBottomSheet(
    icon: const Icon(Icons.check_circle, size: 40, color: Color(0xFF9B8572)),
    title: title,
    description: description,
    buttons: [
      CommonBottomSheetButton(
        text: actionText,
        onPressed: onAction,
        backgroundColor: const Color(0xFF9B8572),
        textColor: Colors.white,
      ),
    ],
  );
}

Widget buildErrorSheet({
  required String title,
  required String description,
  String actionText = 'OK',
  required VoidCallback onDismiss,
}) {
  return CommonBottomSheet(
    icon: const Icon(Icons.error_outline, size: 40, color: Colors.red),
    title: title,
    description: description,
    buttons: [
      CommonBottomSheetButton(
        text: actionText,
        onPressed: onDismiss,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      ),
    ],
  );
}

class CommonBottomSheetButton {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;
  final Color? borderColor;

  CommonBottomSheetButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
    this.borderColor,
  });
}

class CommonBottomSheet extends StatelessWidget {
  final Icon icon;
  final String title;
  final String description;
  final List<CommonBottomSheetButton> buttons;
  final EdgeInsetsGeometry padding;

  const CommonBottomSheet({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttons,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...buttons.asMap().entries.map((entry) {
            final btn = entry.value;
            final isLast = entry.key == buttons.length - 1;
            final Widget buttonWidget = btn.isOutlined
                ? OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: btn.textColor ?? Colors.black87,
                      side: BorderSide(color: btn.borderColor ?? Colors.black26),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: btn.onPressed,
                    child: Text(btn.text),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btn.backgroundColor ?? Theme.of(context).primaryColor,
                      foregroundColor: btn.textColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: btn.onPressed,
                    child: Text(btn.text),
                  );
            return Column(
              children: [
                SizedBox(width: double.infinity, child: buttonWidget),
                if (!isLast) const SizedBox(height: 12),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

// Helper builders for your two use cases:

Widget buildAllowPhotoAccessSheet({
  required VoidCallback onSettings,
  required VoidCallback onNotNow,
}) {
  return CommonBottomSheet(
    icon: const Icon(Icons.camera_alt_rounded, size: 48, color: Color(0xFF9B8572)),
    title: 'Allow Photo Access?',
    description:
        'To upload or take photos for your backgrounds, we need access to your gallery and camera. This helps personalize your experience.',
    buttons: [
      CommonBottomSheetButton(
        text: 'Settings',
        onPressed: onSettings,
        backgroundColor: const Color(0xFF9B8572),
        textColor: Colors.white,
      ),
      CommonBottomSheetButton(
        text: 'Not Now',
        onPressed: onNotNow,
        isOutlined: true,
        borderColor: const Color(0xFF9B8572),
        textColor: Colors.black87,
      ),
    ],
  );
}

Widget buildDeleteAccountSheet({required VoidCallback onDelete, required VoidCallback onCancel}) {
  return CommonBottomSheet(
    icon: const Icon(Icons.error_outline, size: 40, color: Colors.black),
    title: 'Delete Account',
    description: 'You want be able to create a account with the same Email address.',
    buttons: [
      CommonBottomSheetButton(
        text: 'Delete Account',
        onPressed: onDelete,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      ),
      CommonBottomSheetButton(
        text: 'Cancel',
        onPressed: onCancel,
        isOutlined: true,
        borderColor: Colors.black26,
        textColor: Colors.black54,
      ),
    ],
  );
}

Widget buildLogoutSheet({required VoidCallback onLogout, required VoidCallback onCancel}) {
  return CommonBottomSheet(
    icon: const Icon(Icons.error_outline, size: 40, color: Colors.black),
    title: 'Log Out',
    description: 'Are you sure you want to log out?',
    buttons: [
      CommonBottomSheetButton(
        text: 'Log Out',
        onPressed: onLogout,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      ),
      CommonBottomSheetButton(
        text: 'Cancel',
        onPressed: onCancel,
        isOutlined: true,
        borderColor: Colors.black26,
        textColor: Colors.black54,
      ),
    ],
  );
}
