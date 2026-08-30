import '../../core/constants/app_constants.dart';

class ServerConfig {
  final String ip;
  final int port;
  final bool useHttps;
  final String customEndpoint;

  const ServerConfig({
    this.ip = AppConstants.defaultServerIp,
    this.port = AppConstants.defaultServerPort,
    this.useHttps = false,
    this.customEndpoint = AppConstants.defaultEndpoint,
  });

  String get baseUrl {
    final scheme = useHttps ? 'https' : 'http';
    return '$scheme://$ip:$port';
  }

  String get fullEndpointUrl => '$baseUrl$customEndpoint';

  String get uploadUrl => '$baseUrl${AppConstants.defaultUploadEndpoint}';

  ServerConfig copyWith({
    String? ip,
    int? port,
    bool? useHttps,
    String? customEndpoint,
  }) {
    return ServerConfig(
      ip: ip ?? this.ip,
      port: port ?? this.port,
      useHttps: useHttps ?? this.useHttps,
      customEndpoint: customEndpoint ?? this.customEndpoint,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ip': ip,
      'port': port,
      'useHttps': useHttps ? 1 : 0,
      'customEndpoint': customEndpoint,
    };
  }

  factory ServerConfig.fromMap(Map<String, dynamic> map) {
    return ServerConfig(
      ip: map['ip'] as String? ?? AppConstants.defaultServerIp,
      port: map['port'] as int? ?? AppConstants.defaultServerPort,
      useHttps: (map['useHttps'] as int? ?? 0) == 1,
      customEndpoint: map['customEndpoint'] as String? ?? AppConstants.defaultEndpoint,
    );
  }
}
