// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lsebert/helpers/loading_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../networks/api_acess.dart';
import '../../../../provider/image_picker_provider.dart';

class DottedContainer extends StatefulWidget {
  final int index;
  final String? imageUrl;
  final int? id;
  const DottedContainer(
      {super.key, required this.index, this.imageUrl, this.id});

  @override
  State<DottedContainer> createState() => _DottedContainerState();
}

class _DottedContainerState extends State<DottedContainer> {
  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        DottedBorder(
          color: AppColors.c9E9E9E,
          // Dotted line color
          strokeWidth: 2.5,
          // Dotted line width
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          // Dotted line border radius
          dashPattern: const [8, 0, 8],
          // Responsible for [- - - - - -]
          child: Container(
            width: 159.w,
            height: 154.h,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: AppColors.cffffff,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            padding: EdgeInsets.all(10.sp),
            // Padding for the red container

            child: Image.network(
              widget.imageUrl != null
                  ? widget.imageUrl!
                  : "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        widget.id == null
            ? Positioned(
                bottom: -12.h,
                right: -10.w,
                child: GestureDetector(
                  onTap: () async {
                    Map<Permission, PermissionStatus> statuses = await [
                      Permission.storage,
                      Permission.camera,
                    ].request();

                    if (statuses[Permission.storage]!.isGranted ||
                        statuses[Permission.camera]!.isGranted) {
                      _showPickImageBottomSheet(widget.index, imageProvider);
                    } else {
                      _buildShowDialog(context);
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColors.allPrimaryColor,
                    radius: 16.r,
                    child: const Icon(
                      Icons.add,
                      color: AppColors.cffffff,
                    ),
                  ),
                ),
              )
            : Positioned(
                bottom: -12.h,
                right: -10.w,
                child: GestureDetector(
                  onTap: () async {
                    await deleteProfileImageRXObj
                        .deleteProfileImage(widget.id.toString())
                        .waitingForFuture();

                    await getProProfileRxObj.fetchProfileData();
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColors.allPrimaryColor,
                    radius: 16.r,
                    child: const Icon(
                      Icons.cancel,
                      color: AppColors.cffffff,
                    ),
                  ),
                ),
              )
      ],
    );
  }

  Future<dynamic> _buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Please grant access to the camera and storage in settings to proceed.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings(); // Open app settings
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectImageFromCamera(
      int index, ImagePickerProvider imageProvider) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    log('pickFile is: $pickedFile');
    if (pickedFile != null) {
      imageProvider.setImageFile(index, File(pickedFile.path));
      imageProvider.imageCount;
    }
  }

  Future<void> _selectImageFromGallery(
      int index, ImagePickerProvider imageProvider) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    log('pickFile is: $pickedFile');
    if (pickedFile != null) {
      imageProvider.setImageFile(index, File(pickedFile.path));
      imageProvider.imageCount;
    }
  }

  void _showPickImageBottomSheet(int index, ImagePickerProvider imageProvider) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
              title: TextStyleExample(
                  name: 'Choose Image',
                  style: textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 0.1)),
              message: TextStyleExample(
                  name: "Choose an image from your camera or existing gallery.",
                  style: textTheme.bodyMedium!.copyWith(letterSpacing: 0.1)),
              actions: <Widget>[
                // List of actions
                CupertinoActionSheetAction(
                  child: TextStyleExample(
                      name: 'Camera',
                      style: textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary)),
                  onPressed: () {
                    _selectImageFromCamera(index, imageProvider);
                    Navigator.pop(context); // Close the modal popup
                  },
                ),
                CupertinoActionSheetAction(
                  child: TextStyleExample(
                      name: 'Gallery',
                      style: textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary)),
                  onPressed: () {
                    _selectImageFromGallery(index, imageProvider);
                    Navigator.pop(context); // Close the modal popup
                  },
                ),
              ],
              // A cancel button at the bottom of the modal popup
              cancelButton: CupertinoActionSheetAction(
                child: TextStyleExample(
                    name: 'Close',
                    style: textTheme.titleLarge!
                        .copyWith(color: Colors.grey, letterSpacing: 0.1)),
                onPressed: () {
                  Navigator.pop(context); // Close the modal popup
                },
              ),
            ));
  }
}

class TextStyleExample extends StatelessWidget {
  const TextStyleExample({super.key, required this.name, required this.style});

  final String name;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.sp),
      child: Text(name, style: style.copyWith(letterSpacing: 1.0)),
    );
  }
}
