# dart_keep_sabbath

A Dart package to help you observe the Biblical Sabbath and Holy days, using offline calculations.

Based on the understanding that the Sabbath and Biblical Holy days are from sundown Fri. to sundown Sat.

## Installing

Add ``dart_keep_sabbath`` to your pubspec.yaml:
```yaml
dependencies:
  dart_keep_sabbath: ^0.0.1
```

## Usage

### Importing

```dart
import 'package:dart_keep_sabbath/dart_keep_sabbath.dart';
```

### Using the methods

All methods can be statically accessed via the ``KeepSabbath`` class.

#### Get whether it is during the Sabbath or a Holy Day

```dart
double lat = 31.007746;
double lng = 34.903396;

List<DateTime> holyDays = [
  DateTime(2024, 3, 25), // Passover
  DateTime(2024, 4, 1), // Last day of unleavened bread
  DateTime(2024, 5, 19), // Pentecost
  DateTime(2024, 9, 5), // Feast of trumpets
  DateTime(2024, 9, 14), // Day of atonements
  DateTime(2024, 9, 19), // Feast of tabernacles
  DateTime(2024, 9, 26), // Last great day
];

bool isDuringSabbathOrHolyDay = KeepSabbath.isSabbathOrHolyDay(holyDays, lat, lng);
>> false
```

#### Get whether it is during the Sabbath day

```dart
double lat = 31.007746;
double lng = 34.903396;

bool isTheSabbath = KeepSabbath.isSabbath(lat, lng);
>> false
```

#### Get whether it is during a Holy day

```dart
double lat = 31.007746;
double lng = 34.903396;

List<DateTime> holyDays = [
  DateTime(2024, 3, 25), // Passover
  DateTime(2024, 4, 1), // Last day of unleavened bread
  DateTime(2024, 5, 19), // Pentecost
  DateTime(2024, 9, 5), // Feast of trumpets
  DateTime(2024, 9, 14), // Day of atonements
  DateTime(2024, 9, 19), // Feast of tabernacles
  DateTime(2024, 9, 26), // Last great day
];

bool isDuringHolyDay = KeepSabbath.isHolyDay(holyDays, lat, lng);
>> false
```