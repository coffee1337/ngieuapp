import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/widget/home_widget_service.dart';

final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) {
  return HomeWidgetService.instance;
});
