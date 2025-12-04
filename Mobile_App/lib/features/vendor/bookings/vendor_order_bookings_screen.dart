// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../ui_helper/app_colors.dart';
// import '../../../ui_helper/app_text_styles.dart';
// import '../../utls/default_common_app_bar.dart';
//
// class VendorOrderBookingsScreen extends StatefulWidget {
//   final String employeeId;
//
//   const VendorOrderBookingsScreen({Key? key, required this.employeeId})
//       : super(key: key);
//
//   @override
//   State<VendorOrderBookingsScreen> createState() => _VendorOrderBookingsScreenState();
// }
//
// class _VendorOrderBookingsScreenState extends State<VendorOrderBookingsScreen>  with SingleTickerProviderStateMixin {
//
//   late TabController _tabController;
//   final List<Map<String, dynamic>> _tabs = [
//     {"name": "Booking Completed", "icon": Icons.book},
//     {"name": "Booking Cancelled", "icon": Icons.work_history_outlined},
//   ];
//
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   final List<Color> avatarBgColors = [
//     Colors.blue.shade50,
//     Colors.green.shade50,
//     Colors.pink.shade50,
//     Colors.orange.shade50,
//     Colors.purple.shade50,
//     Colors.teal.shade50,
//     Colors.amber.shade50,
//   ];
//
//   void _previewImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(20),
//         child: Stack(
//           children: [
//             // Main Image Container
//             Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.white.withOpacity(0.3),
//                       blurRadius: 30,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Container(
//                     constraints: BoxConstraints(
//                       maxHeight: MediaQuery.of(context).size.height * 0.8,
//                       maxWidth: MediaQuery.of(context).size.width * 0.9,
//                     ),
//                     child: InteractiveViewer(
//                       minScale: 0.5,
//                       maxScale: 4.0,
//                       child: Image.network(
//                         imageUrl,
//                         fit: BoxFit.contain,
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return Container(
//                             color: Colors.grey.shade900,
//                             child: Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   CircularProgressIndicator(
//                                     value:
//                                     loadingProgress.expectedTotalBytes !=
//                                         null
//                                         ? loadingProgress
//                                         .cumulativeBytesLoaded /
//                                         loadingProgress
//                                             .expectedTotalBytes!
//                                         : null,
//                                     color: Colors.white,
//                                   ),
//                                   const SizedBox(height: 16),
//                                   const Text(
//                                     'Loading image...',
//                                     style: TextStyle(
//                                       color: Colors.white70,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                         errorBuilder: (_, __, ___) => Container(
//                           padding: const EdgeInsets.all(40),
//                           color: Colors.grey.shade900,
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: const [
//                                 Icon(
//                                   Icons.broken_image_outlined,
//                                   color: Colors.white70,
//                                   size: 64,
//                                 ),
//                                 SizedBox(height: 16),
//                                 Text(
//                                   'Image not found',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   'Unable to load image',
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // Close Button - Top Right
//             Positioned(
//               top: 10,
//               right: 10,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.6),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: () => Navigator.pop(context),
//                     borderRadius: BorderRadius.circular(50),
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       child: const Icon(
//                         Icons.close_rounded,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // Optional: Zoom hint text (bottom center)
//             Positioned(
//               bottom: 20,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.6),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       Icon(Icons.zoom_in, color: Colors.white70, size: 18),
//                       SizedBox(width: 8),
//                       Text(
//                         'Pinch to zoom',
//                         style: TextStyle(color: Colors.white70, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightBgColor,
//       appBar: const DefaultCommonAppBar(
//         activityName: "All Booking",
//         backgroundColor: AppColors.primary,
//       ),
//       body: Column(
//         children: [
//           // Tab Bar
//           Container(
//             color: AppColors.primary,
//             child: TabBar(
//               controller: _tabController,
//               isScrollable: true,
//               tabAlignment: TabAlignment.start,
//               labelColor: AppColors.whiteColor,
//               unselectedLabelColor: AppColors.whiteColor.withOpacity(0.7),
//               indicatorColor: AppColors.whiteColor,
//               indicatorWeight: 4.0,
//               labelStyle: AppTextStyles.heading1(
//                 context,
//                 overrideStyle: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//               tabs: _tabs
//                   .map(
//                     (tab) => Tab(
//                   text: tab["name"],
//                   icon: Icon(tab["icon"], size: 18),
//                 ),
//               )
//                   .toList(),
//             ),
//           ),
//           // Tab Bar View
//           Expanded(
//             child: Consumer<HREmployeeApiProvider>(
//               builder: (context, provider, child) {
//                 if (provider.isLoading) {
//                   return LoadingIndicatorUtils();
//                 }
//                 if (provider.errorMessage.isNotEmpty) {
//                   return Center(
//                     child: Text(
//                       provider.errorMessage,
//                       style: AppTextStyles.heading2(context),
//                     ),
//                   );
//                 }
//
//                 final employee = provider.employeeListDetailModel?.data;
//                 if (employee == null) {
//                   return const Center(child: Text('No employee data found.'));
//                 }
//
//                 return TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildCompleteBookingsInfoTab(employee),
//
//                     _buildCancelledBookingsInfoab(employee),
//
//
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCompleteBookingsInfoTab(Data employee) {
//     return RefreshIndicator(
//       onRefresh: () => Provider.of<HREmployeeApiProvider>(
//         context,
//         listen: false,
//       ).getHREmployeeDetail(widget.employeeId),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Profile Header
//             _buildProfileHeader(employee),
//
//             const SizedBox(height: 20),
//
//             // Personal Details
//             _buildSectionCard(
//               title: "Personal Details",
//               children: [
//                 _ProfileField(label: "Full Name", value: employee.name ?? '-'),
//                 _ProfileField(label: "Email", value: employee.email ?? '-'),
//                 _ProfileField(
//                   label: "Work Email",
//                   value: employee.workEmail ?? '-',
//                 ),
//                 _ProfileField(label: "Phone", value: employee.phone ?? '-'),
//                 _ProfileField(
//                   label: "Alternate No",
//                   value: employee.alternateNo ?? '-',
//                 ),
//                 _ProfileField(
//                   label: "WhatsApp",
//                   value: employee.whatsapp ?? '-',
//                 ),
//                 _ProfileField(
//                   label: "Date of Birth",
//                   value: employee.dob != null
//                       ? DateFormatterUtils.formatToShortMonth(employee.dob!)
//                       : '-',
//                 ),
//                 _ProfileField(
//                   label: "Gender",
//                   value: StringUtils.capitalizeFirstLetter(
//                     employee.gender ?? '-',
//                   ),
//                 ),
//                 _ProfileField(
//                   label: "Marital Status",
//                   value: StringUtils.capitalizeFirstLetter(
//                     employee.maritalStatus ?? '-',
//                   ),
//                 ),
//                 _ProfileField(
//                   label: "Blood Group",
//                   value: employee.bloodGroup ?? '-',
//                 ),
//                 _ProfileField(
//                   label: "Qualification",
//                   value: StringUtils.toUpperCase(employee.qualification ?? '-'),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 16),
//
//             // Address Details
//             _buildSectionCard(
//               title: "Address Details",
//               children: [
//                 _ProfileField(
//                   label: "Current Address",
//                   value: StringUtils.capitalizeEachWord(
//                     employee.currentAddress ?? '-',
//                   ),
//                 ),
//                 _ProfileField(
//                   label: "Permanent Address",
//                   value: StringUtils.capitalizeEachWord(
//                     employee.permanentAddress ?? '-',
//                   ),
//                 ),
//                 _ProfileField(label: "Country", value: employee.country ?? '-'),
//                 _ProfileField(
//                   label: "Zone",
//                   value: StringUtils.capitalizeFirstLetter(
//                     employee.zoneId?.title ?? '-',
//                   ),
//                 ),
//                 _ProfileField(
//                   label: "State",
//                   value: StringUtils.capitalizeFirstLetter(
//                     employee.stateId?.title ?? '-',
//                   ),
//                 ),
//                 _ProfileField(
//                   label: "City",
//                   value: StringUtils.capitalizeFirstLetter(
//                     employee.cityId?.title ?? '-',
//                   ),
//                 ),
//                 _ProfileField(
//                   label: "Branch",
//                   value: StringUtils.capitalizeFirstLetter(
//                     employee.branchId?.title ?? '-',
//                   ),
//                 ),
//                 _ProfileField(
//                   label: "Department",
//                   value: StringUtils.capitalizeFirstLetter(
//                     employee.departmentId?.title ?? '-',
//                   ),
//                 ),
//                 _ProfileField(
//                   label: "Designation",
//                   value: StringUtils.capitalizeFirstLetter(
//                     employee.designationId?.title ?? '-',
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 16),
//
//             // Emergency Contact
//             if (employee.emergencyContact != null)
//               _buildSectionCard(
//                 title: "Emergency Contact",
//                 children: [
//                   _ProfileField(
//                     label: "Name",
//                     value: employee.emergencyContact!.name ?? '-',
//                   ),
//                   _ProfileField(
//                     label: "Relation",
//                     value: StringUtils.capitalizeFirstLetter(
//                       employee.emergencyContact!.relation ?? '-',
//                     ),
//                   ),
//                   _ProfileField(
//                     label: "Phone",
//                     value: employee.emergencyContact!.phone ?? '-',
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCancelledBookingsInfoab(Data employee) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildSectionCard(
//             title: "Official Details",
//             children: [
//               _ProfileField(
//                 label: "Employee ID",
//                 value: employee.employeeId ?? '-',
//               ),
//               _ProfileField(
//                 label: "Joining Date",
//                 value: employee.joiningDate != null
//                     ? DateFormatterUtils.formatToLongDate(employee.joiningDate!)
//                     : '-',
//               ),
//               _ProfileField(
//                 label: "Employee Type",
//                 value: StringUtils.capitalizeEachWord(
//                   employee.employeeType ?? '-',
//                 ),
//               ),
//               _ProfileField(
//                 label: "Probation Period",
//                 value: employee.probationPeriod ?? '-',
//               ),
//               _ProfileField(
//                 label: "Training Period",
//                 value: employee.trainingPeriod ?? '-',
//               ),
//               _ProfileField(
//                 label: "Work Location",
//                 value: StringUtils.capitalizeEachWord(
//                   employee.workLocation ?? '-',
//                 ),
//               ),
//               _ProfileField(
//                 label: "Status",
//                 value: StringUtils.capitalizeFirstLetter(
//                   employee.status ?? '-',
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // Branch & Department Info
//           _buildSectionCard(
//             title: "Organization Details",
//             children: [
//               _ProfileField(
//                 label: "Branch",
//                 value: employee.branchId?.title ?? '-',
//               ),
//               _ProfileField(
//                 label: "Department",
//                 value: employee.departmentId?.title ?? '-',
//               ),
//               _ProfileField(
//                 label: "Designation",
//                 value: employee.designationId?.title ?? '-',
//               ),
//               _ProfileField(
//                 label: "State",
//                 value: employee.stateId?.title ?? '-',
//               ),
//               _ProfileField(
//                 label: "City",
//                 value: employee.cityId?.title ?? '-',
//               ),
//               _ProfileField(
//                 label: "Zone",
//                 value: employee.zoneId?.title ?? '-',
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // PF & ESIC
//           _buildSectionCard(
//             title: "Statutory Details",
//             children: [
//               _ProfileField(
//                 label: "PF Account No",
//                 value: employee.pfAccountNo ?? '-',
//               ),
//               _ProfileField(label: "UAN", value: employee.uan ?? '-'),
//               _ProfileField(label: "ESIC No", value: employee.esicNo ?? '-'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBankSalaryTab(Data employee) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Bank Details
//           if (employee.bankDetail != null)
//             _buildSectionCard(
//               title: "Bank Details",
//               children: [
//                 _ProfileField(
//                   label: "Bank Name",
//                   value: employee.bankDetail!.bankName ?? '-',
//                 ),
//                 _ProfileField(
//                   label: "Account Holder",
//                   value: employee.bankDetail!.accountHolderName ?? '-',
//                 ),
//                 _ProfileField(
//                   label: "Account Number",
//                   value: employee.bankDetail!.accountNumber?.toString() ?? '-',
//                 ),
//                 _ProfileField(
//                   label: "IFSC Code",
//                   value: employee.bankDetail!.ifscCode ?? '-',
//                 ),
//                 _ProfileField(
//                   label: "Branch Name",
//                   value: employee.bankDetail!.branchName ?? '-',
//                 ),
//               ],
//             ),
//
//           const SizedBox(height: 16),
//
//           // Salary Details
//           if (employee.salary != null)
//             _buildSectionCard(
//               title: "Salary Breakdown (CTC)",
//               children: [
//                 _ProfileField(
//                   label: "CTC",
//                   value: employee.salary!.ctc != null
//                       ? "₹ ${employee.salary!.ctc}"
//                       : '-',
//                 ),
//                 _ProfileField(
//                   label: "Basic",
//                   value: employee.salary!.basic != null
//                       ? "₹ ${employee.salary!.basic}"
//                       : '-',
//                 ),
//                 _ProfileField(
//                   label: "HRA",
//                   value: employee.salary!.hra != null
//                       ? "₹ ${employee.salary!.hra}"
//                       : '-',
//                 ),
//                 _ProfileField(
//                   label: "Allowances",
//                   value: employee.salary!.allowances != null
//                       ? "₹ ${employee.salary!.allowances}"
//                       : '-',
//                 ),
//                 _ProfileField(
//                   label: "Deductions",
//                   value: employee.salary!.deductions != null
//                       ? "₹ ${employee.salary!.deductions}"
//                       : '-',
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileHeader(Data employee) {
//     final int colorIndex =
//         (employee.sId?.hashCode ?? 0).abs() % avatarBgColors.length;
//
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () {
//               final imageUrl = employee.photo?.publicUrl ?? employee.photo?.url;
//               if (imageUrl != null && imageUrl.isNotEmpty) {
//                 _previewImage(context, imageUrl);
//               }
//             },
//             child: Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: avatarBgColors[colorIndex],
//                 shape: BoxShape.circle,
//               ),
//               child: CircleAvatar(
//                 radius: 36,
//                 backgroundColor: Colors.white,
//                 backgroundImage:
//                 (employee.photo?.publicUrl ?? employee.photo?.url) != null
//                     ? NetworkImage(
//                   employee.photo!.publicUrl ?? employee.photo!.url!,
//                 )
//                     : null,
//                 child:
//                 (employee.photo?.publicUrl ?? employee.photo?.url) == null
//                     ? const Icon(Icons.person, size: 50, color: Colors.grey)
//                     : null,
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   employee.name ?? 'N/A',
//                   style: AppTextStyles.heading2(context).copyWith(fontSize: 18),
//                 ),
//                 Text(
//                   employee.email ?? 'N/A',
//                   style: AppTextStyles.body2(
//                     context,
//                   ).copyWith(color: Colors.grey[700]),
//                 ),
//                 if (employee.designationId?.title != null)
//                   Text(
//                     employee.designationId!.title!,
//                     style: TextStyle(fontSize: 14, color: AppColors.primary),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionCard({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: AppTextStyles.heading2(
//               context,
//             ).copyWith(color: AppColors.primary, fontSize: 15),
//           ),
//           const SizedBox(height: 12),
//           ...children,
//         ],
//       ),
//     );
//   }
// }
//
// class _ProfileField extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _ProfileField({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               "$label:",
//               style: AppTextStyles.caption(
//                 context,
//               ).copyWith(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: AppTextStyles.body2(context).copyWith(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
