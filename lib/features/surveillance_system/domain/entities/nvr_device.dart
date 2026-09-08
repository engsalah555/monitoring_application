import 'nvr_brand.dart';

/// Immutable domain entity representing an NVR/DVR camera device recorder.
class NvrDevice {
  final String id;
  final NvrBrand brand;
  final String ipAddress;
  final int port;
  final String username;
  final String password;
  final int channelsCount;
  final bool isConnected;

  const NvrDevice({
    required this.id,
    required this.brand,
    required this.ipAddress,
    required this.port,
    required this.username,
    required this.password,
    required this.channelsCount,
    this.isConnected = true,
  });

  String get rtspStreamUrl {
    switch (brand) {
      case NvrBrand.hikvision:
        return 'rtsp://$username:$password@$ipAddress:$port/Streaming/Channels/101';
      case NvrBrand.dahua:
        return 'rtsp://$username:$password@$ipAddress:$port/cam/realmonitor?channel=1&subtype=0';
      case NvrBrand.ezviz:
        return 'rtsp://$username:$password@$ipAddress:$port/h264/ch1/main/av_stream';
      case NvrBrand.onvif:
        return 'rtsp://$username:$password@$ipAddress:$port/onvif1';
      case NvrBrand.customRtsp:
        return 'rtsp://$username:$password@$ipAddress:$port/live';
    }
  }
}
