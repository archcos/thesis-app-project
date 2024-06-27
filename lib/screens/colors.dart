import 'package:flutter/material.dart';

Color getColorForRemarks(String remarks) {
  switch (remarks) {
    case 'Good':
      return Colors.green;
    case 'Fair':
      return Colors.yellow.shade600;
    case 'Unhealthy':
      return Colors.orange;
    case 'Very Unhealthy':
      return Colors.red.shade700;
    case 'Severely Unhealthy':
      return Colors.purple;
    case 'Emergency':
      return Color(0xFF800000);
    default:
      return Colors.white;
  }
}
