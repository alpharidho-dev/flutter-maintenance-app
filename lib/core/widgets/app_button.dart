import 'package:flutter/material.dart';
import '../theme.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: loading ? const Color(0xFF5A5754) : AppTheme.ink,
      borderRadius: BorderRadius.circular(AppTheme.rbM),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.rbM),
        onTap: loading ? null : onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}