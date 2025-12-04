import 'package:flutter/material.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:kaashtkart/features/customer/screen/bottom_navigation/entrypoint_ui.dart';
import 'package:kaashtkart/features/vendor/bottom_navigation/entrypoint_ui.dart';


class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_basket,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 16),

                  // App Name
                  Text(
                    'KaashtKart',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3440),
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    'Choose your role to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Cards Section
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildRoleCard(
                          context: context,
                          index: 0,
                          title: 'Customer',
                          icon: Icons.shopping_cart,
                          color: Color(0xFF4CAF50),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CustomerEntryPointUI()),
                            );
                          },
                        ),
                        _buildRoleCard(
                          context: context,
                          index: 1,
                          title: 'Vendor',
                          icon: Icons.store,
                          color: Color(0xFFFF9800),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const VendorEntryPointUI()),
                            );
                          },
                        ),
                        _buildRoleCard(
                          context: context,
                          index: 2,
                          title: 'Admin',
                          icon: Icons.admin_panel_settings,
                          color: Color(0xFFF44336),
                          onTap: () {
                            Navigator.pushNamed(context, '/admin_login');
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Footer
                  Text(
                    '© 2025 KaashtKart',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required int index,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: isMobile ? 140 : 160,
          height: isMobile ? 140 : 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isHovered ? color.withOpacity(0.3) : Colors.black.withOpacity(0.08),
                blurRadius: isHovered ? 20 : 10,
                offset: Offset(0, isHovered ? 8 : 4),
              ),
            ],
          ),
          transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E3440),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}