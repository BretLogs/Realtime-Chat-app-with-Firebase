import 'package:chatapp_realtime_firebase/services/navigation_services.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class AlertService {
  AlertService() {
    _navigationServices = _getIt.get<NavigationServices>();
  }
  late NavigationServices _navigationServices;
  final GetIt _getIt = GetIt.instance;

  void showToast({
    required String text,
    IconData icon = Icons.info,
  }) {
    try {
      DelightToastBar(
          autoDismiss: true,
          position: DelightSnackbarPosition.top,
          builder: (BuildContext context) {
            return ToastCard(
              leading: Icon(
                icon,
                size: 28,
              ),
              title: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            );
          }).show(_navigationServices.navigatorKey!.currentContext!);
    } catch (e) {
      print(e);
    }
  }
}
