import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'data/admin_mock_data.dart';
import 'models/admin_device.dart';
import 'pages/admin_battery_page.dart';
import 'pages/admin_devices_page.dart';
import 'pages/admin_location_page.dart';
import 'pages/admin_logs_page.dart';
import 'pages/admin_overview_page.dart';
import 'pages/admin_security_page.dart';
import 'pages/admin_settings_page.dart';
import 'pages/admin_sms_page.dart';
import 'pages/admin_surveillance_page.dart';
import 'widgets/admin_sidebar.dart';
import 'widgets/admin_top_bar.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;
  String _selectedDeviceId = AdminMockData.devices.first.id;

  AdminDevice get _selectedDevice {
    return AdminMockData.devices.firstWhere(
      (device) => device.id == _selectedDeviceId,
      orElse: () => AdminMockData.devices.first,
    );
  }

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 980;
        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: isWide
              ? null
              : AdminDrawer(
                  child: AdminSidebar(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) {
                      _selectPage(index);
                      Navigator.of(context).pop();
                    },
                    persistent: false,
                  ),
                ),
          body: Row(
            children: [
              if (isWide)
                AdminSidebar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectPage,
                  persistent: true,
                ),
              Expanded(
                child: Column(
                  children: [
                    AdminTopBar(
                      selectedDevice: _selectedDevice,
                      selectedDeviceId: _selectedDeviceId,
                      onDeviceChanged: (id) {
                        if (id == null) return;
                        setState(() => _selectedDeviceId = id);
                      },
                      showMenu: !isWide,
                    ),
                    Expanded(
                      child: Container(
                        color: AppColors.background,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            isWide ? 28 : 16,
                            24,
                            isWide ? 28 : 16,
                            32,
                          ),
                          child: _buildPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return AdminOverviewPage(
          selectedDevice: _selectedDevice,
          onNavigate: _selectPage,
        );
      case 1:
        return AdminDevicesPage(
          selectedDevice: _selectedDevice,
          onDeviceSelected: (device) {
            setState(() => _selectedDeviceId = device.id);
          },
        );
      case 2:
        return AdminSurveillancePage(selectedDevice: _selectedDevice);
      case 3:
        return AdminLocationPage(selectedDevice: _selectedDevice);
      case 4:
        return AdminLogsPage(selectedDevice: _selectedDevice);
      case 5:
        return AdminSecurityPage(selectedDevice: _selectedDevice);
      case 6:
        return AdminSmsPage(selectedDevice: _selectedDevice);
      case 7:
        return AdminBatteryPage(selectedDevice: _selectedDevice);
      case 8:
        return AdminSettingsPage(selectedDevice: _selectedDevice);
      default:
        return const SizedBox.shrink();
    }
  }
}
