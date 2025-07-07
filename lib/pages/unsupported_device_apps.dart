// Stub for device_apps for non-Android platforms
class DeviceApps {
  static Future<List<dynamic>> getInstalledApplications({
    bool onlyAppsWithLaunchIntent = true,
    bool includeSystemApps = false,
    bool includeAppIcons = true,
  }) async {
    return [];
  }
}
