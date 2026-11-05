import 'package:flutter/material.dart';
import '../theme.dart';

class MaintenanceCard extends StatelessWidget {
  final String itemName;
  final String serviceType;
  final String status;
  final String cost;
  final VoidCallback onTap;

  const MaintenanceCard({
    super.key,
    required this.itemName,
    required this.serviceType,
    required this.status,
    required this.cost,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = status == 'done';
    final statusColor = isDone ? const Color(0xFF2F7A4F) : AppTheme.rust;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.gap10),
      child: Material(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(AppTheme.rbM),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.rbM),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.rbM),
              border: Border.all(color: const Color(0xFFE8E3DB)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 38,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        serviceType,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppTheme.ash,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isDone ? 'Selesai' : 'Terjadwal',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Rp$cost',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}