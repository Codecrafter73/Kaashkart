import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';
import 'package:kaashtkart/core/ui_helper/app_text_styles.dart';
import 'package:kaashtkart/core/utls/permission_manager_utils.dart';
import 'package:kaashtkart/core/utls/responsive_helper_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_snack_bar.dart';

/// Reusable Product Images Upload Widget
/// Supports both single and multiple image selection modes
class ProductImagesUploadWidget extends StatefulWidget {
  final String productId;
  final bool allowMultiple; // true = multiple images, false = single image
  final int? maxImages; // maximum images allowed (only for multiple mode)
  final List<String>? existingImageUrls; // pre-existing images from API
  final Function(List<File> images)? onImagesSelected; // callback for selected images
  final String? title; // custom title

  const ProductImagesUploadWidget({
    super.key,
    required this.productId,
    this.allowMultiple = true,
    this.maxImages = 5,
    this.existingImageUrls,
    this.onImagesSelected,
    this.title,
  });

  @override
  State<ProductImagesUploadWidget> createState() =>
      _ProductImagesUploadWidgetState();
}

class _ProductImagesUploadWidgetState extends State<ProductImagesUploadWidget> {
  // List to hold both local files and remote URLs
  List<dynamic> _productImages = []; // Can contain File or String (URL)
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExistingImages();
  }

  /* ---------------------------------------------------------------------- */
  /*                        LOAD EXISTING IMAGES                             */
  /* ---------------------------------------------------------------------- */
  Future<void> _loadExistingImages() async {
    setState(() => _isLoading = true);
    try {
      if (widget.existingImageUrls != null && widget.existingImageUrls!.isNotEmpty) {
        _productImages = List.from(widget.existingImageUrls!);
      }
    } catch (e) {
      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        backgroundColor: Colors.red,
        message: "Error loading existing images: $e",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /* ---------------------------------------------------------------------- */
  /*                         SINGLE IMAGE PICKER                             */
  /* ---------------------------------------------------------------------- */
  Future<void> _pickSingleImage() async {
    // Try-catch for permission handling
    try {
      final granted = await PermissionManager.requestPhotosPermission(context);
      if (!granted) {
        if (mounted) {
          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            backgroundColor: Colors.orange,
            message: "Permission denied. Please enable storage permission from settings.",
          );
        }
        return;
      }
    } catch (e) {
      debugPrint("Permission check error: $e");
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result?.files.single.path != null) {
        setState(() {
          _productImages = [File(result!.files.single.path!)]; // Replace with single image
        });
        _notifyParent();
      } else {
        if (mounted) {
          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            backgroundColor: Colors.orange,
            message: "No image selected",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          backgroundColor: Colors.red,
          message: "Error selecting image: $e",
        );
      }
    }
  }

  /* ---------------------------------------------------------------------- */
  /*                        MULTIPLE IMAGES PICKER                           */
  /* ---------------------------------------------------------------------- */
  Future<void> _pickMultipleImages() async {
    // Try-catch for permission handling
    try {
      final granted = await PermissionManager.requestPhotosPermission(context);
      if (!granted) {
        if (mounted) {
          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            backgroundColor: Colors.orange,
            message: "Permission denied. Please enable storage permission from settings.",
          );
        }
        return;
      }
    } catch (e) {
      debugPrint("Permission check error: $e");
    }

    // Calculate remaining slots
    final currentCount = _productImages.length;
    final maxAllowed = widget.maxImages ?? 5;
    final remainingSlots = maxAllowed - currentCount;

    if (remainingSlots <= 0) {
      if (mounted) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          backgroundColor: Colors.orange,
          message: "Maximum $maxAllowed images allowed",
        );
      }
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final newFiles = result.files
            .where((file) => file.path != null)
            .take(remainingSlots)
            .map((file) => File(file.path!))
            .toList();

        setState(() {
          _productImages.addAll(newFiles);
        });
        _notifyParent();

        if (result.files.length > remainingSlots && mounted) {
          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            backgroundColor: Colors.orange,
            message: "Only $remainingSlots images added. Maximum limit is $maxAllowed",
          );
        }
      } else {
        if (mounted) {
          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            backgroundColor: Colors.orange,
            message: "No images selected",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          backgroundColor: Colors.red,
          message: "Error selecting images: $e",
        );
      }
    }
  }

  /* ---------------------------------------------------------------------- */
  /*                           REMOVE IMAGE                                  */
  /* ---------------------------------------------------------------------- */
  void _removeImage(int index) {
    setState(() {
      _productImages.removeAt(index);
    });
    _notifyParent();
  }

  /* ---------------------------------------------------------------------- */
  /*                           CLEAR ALL                                     */
  /* ---------------------------------------------------------------------- */
  void _clearAll() {
    setState(() {
      _productImages.clear();
    });
    _notifyParent();
  }

  /* ---------------------------------------------------------------------- */
  /*                        NOTIFY PARENT WIDGET                             */
  /* ---------------------------------------------------------------------- */
  void _notifyParent() {
    if (widget.onImagesSelected != null) {
      final localFiles = _productImages.whereType<File>().toList();
      widget.onImagesSelected!(localFiles);
    }
  }

  /* ---------------------------------------------------------------------- */
  /*                        OPEN URL (VIEW IMAGE)                            */
  /* ---------------------------------------------------------------------- */
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          backgroundColor: Colors.red,
          message: 'Could not open image. Please try again.',
        );
      }
    }
  }

  /* ---------------------------------------------------------------------- */
  /*                               SUBMIT LOGIC                              */
  /* ---------------------------------------------------------------------- */
  Future<void> _submitImages() async {
    final localFiles = _productImages.whereType<File>().toList();

    if (localFiles.isEmpty) {
      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        backgroundColor: Colors.red,
        message: "No new images to upload",
      );
      return;
    }

    CustomSnackbarHelper.customShowSnackbar(
      context: context,
      backgroundColor: Colors.green,
      message: "Images uploaded successfully!",
    );
  }

  /* ---------------------------------------------------------------------- */
  /*                                   UI                                    */
  /* ---------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(
                widget.allowMultiple ? Icons.photo_library : Icons.image,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.title ?? (widget.allowMultiple ? 'Product Images' : 'Product Image'),
                style: AppTextStyles.heading2(
                  context,
                  overrideStyle: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.fontSize(context, 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Info Text
          Text(
            widget.allowMultiple
                ? 'Upload up to ${widget.maxImages ?? 5} product images'
                : 'Upload one product image',
            style: AppTextStyles.body2(context).copyWith(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Image Preview or Empty State
          if (_productImages.isEmpty)
            _buildEmptyState()
          else
            _buildImageGrid(),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  onPressed: widget.allowMultiple ? _pickMultipleImages : _pickSingleImage,
                  text: widget.allowMultiple ? 'Add Images' : 'Select Image',
                  icon: Icons.add_photo_alternate,
                  color: AppColors.primary,
                ),
              ),
              if (_productImages.isNotEmpty) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    onPressed: _clearAll,
                    text: 'Clear All',
                    icon: Icons.delete_outline,
                    color: Colors.red.shade400,
                  ),
                ),
              ],
            ],
          ),

          // Upload Button (only if there are local files)
          if (_productImages.whereType<File>().isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: _buildActionButton(
                onPressed: _submitImages,
                text: 'Upload Images',
                icon: Icons.cloud_upload,
                color: Colors.green.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /* ---------------------------------------------------------------------- */
  /*                         EMPTY STATE WIDGET                              */
  /* ---------------------------------------------------------------------- */
  Widget _buildEmptyState() {
    return InkWell(
      onTap: widget.allowMultiple ? _pickMultipleImages : _pickSingleImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No images selected',
              style: AppTextStyles.body1(context).copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap to select ${widget.allowMultiple ? "images" : "an image"}',
              style: AppTextStyles.body2(context).copyWith(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ---------------------------------------------------------------------- */
  /*                         IMAGE GRID WIDGET                               */
  /* ---------------------------------------------------------------------- */
  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.allowMultiple ? 3 : 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: _productImages.length,
      itemBuilder: (context, index) {
        final image = _productImages[index];
        return _buildImageCard(image, index);
      },
    );
  }

  /* ---------------------------------------------------------------------- */
  /*                         IMAGE CARD WIDGET                               */
  /* ---------------------------------------------------------------------- */
  Widget _buildImageCard(dynamic image, int index) {
    final isLocal = image is File;
    final isRemote = image is String;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Image Display
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.grey[100],
              child: isLocal
                  ? Image.file(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
                  : isRemote
                  ? Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (c, child, progress) => progress == null
                    ? child
                    : Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
                ),
                errorBuilder: (_, __, ___) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 30, color: Colors.red.shade300),
                      const SizedBox(height: 4),
                      Text(
                        'Failed to load',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
                  : const SizedBox(),
            ),
          ),

          // Gradient Overlay for better button visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),

          // Remove Button
          Positioned(
            top: 6,
            right: 6,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _removeImage(index),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade500,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ),

          // View Button (for remote images)
          if (isRemote)
            Positioned(
              bottom: 6,
              right: 6,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _launchURL(image),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.visibility, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'View',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // New Badge (for local images)
          if (isLocal)
            Positioned(
              bottom: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'New',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /* ---------------------------------------------------------------------- */
  /*                         ACTION BUTTON WIDGET                            */
  /* ---------------------------------------------------------------------- */
  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    );
  }
}