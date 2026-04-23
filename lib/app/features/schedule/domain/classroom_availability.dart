import 'package:freezed_annotation/freezed_annotation.dart';

part 'classroom_availability.freezed.dart';

@freezed
abstract class ClassroomAvailability with _$ClassroomAvailability {
  const factory ClassroomAvailability({
    required String classroom,
    required String building,
    required DateTime freeFrom,
    required DateTime freeUntil,
    required Duration freeDuration,
  }) = _ClassroomAvailability;
}