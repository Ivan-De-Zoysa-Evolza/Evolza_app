import 'package:flutter/material.dart';
import 'package:evolza_app/Presentation/widgets/profile_styles.dart';

class ProfileDialogButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  final BoxDecoration decoration;

  const ProfileDialogButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: decoration,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ProfileStyles.profileDialogButtonStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22),
            SizedBox(width: 8),
            Text(
              text,
              style: ProfileStyles.profileDialogButtonTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final IconData icon;

  const ProfileDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(25),
        decoration: ProfileStyles.popupContainerDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: ProfileStyles.popupIconDecoration,
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: ProfileStyles.popupTitleStyle,
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: ProfileStyles.popupSubtitleStyle,
            ),
            SizedBox(height: 30),
            ...children,
          ],
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ProfileStyles.infoRowDecoration,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: ProfileStyles.infoIconDecoration,
            child: Icon(icon, color: Colors.blue.shade600, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: ProfileStyles.infoLabelStyle),
                SizedBox(height: 4),
                Text(value, style: ProfileStyles.infoValueStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 