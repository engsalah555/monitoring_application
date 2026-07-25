import 'package:flutter/material.dart';

/// Supported NVR/DVR Manufacturers and Streaming Protocols.
enum NvrBrand {
  hikvision(
    label: 'Hikvision (هيكفيجن)',
    code: 'HIKVISION',
    icon: Icons.videocam,
  ),
  dahua(
    label: 'Dahua (دلهوا)',
    code: 'DAHUA',
    icon: Icons.security,
  ),
  onvif(
    label: 'ONVIF Standard (بروتوكول عام)',
    code: 'ONVIF',
    icon: Icons.language,
  ),
  customRtsp(
    label: 'RTSP / Stream URL (بث مخصص)',
    code: 'RTSP',
    icon: Icons.stream,
  );

  final String label;
  final String code;
  final IconData icon;

  const NvrBrand({
    required this.label,
    required this.code,
    required this.icon,
  });
}
