// import 'package:cr_calendar/cr_calendar.dart';
// import 'colors.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
//
// const kAppBarDateFormat = 'M/yyyy';
// const kMonthFormat = 'MMMM';
// const kMonthFormatWidthYear = 'MMMM yyyy';
// const kDateRangeFormat = 'dd-MM-yy';
//
// extension DateTimeExt on DateTime {
//   String format(String formatPattern) => DateFormat(formatPattern).format(this);
// }
//
// class WeekDaysWidget extends StatelessWidget {
//   const WeekDaysWidget({
//     required this.day,
//     super.key,
//   });
//
//   final WeekDay day;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       child: Center(
//         child: Text(
//           describeEnum(day).substring(0, 1).toUpperCase(),
//           style: TextStyle(
//             color: Color(0xff69695D).withOpacity(0.9),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class EventWidget extends StatelessWidget {
//   const EventWidget({
//     required this.drawer,
//     super.key,
//   });
//
//   final EventProperties drawer;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 3),
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(4)),
//         color: drawer.backgroundColor,
//       ),
//       child: FittedBox(
//         fit: BoxFit.fitHeight,
//         alignment: Alignment.centerLeft,
//         child: Text(
//           drawer.name,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
//
// class CreateEventDialog extends StatefulWidget {
//   const CreateEventDialog({super.key});
//
//   @override
//   _CreateEventDialogState createState() => _CreateEventDialogState();
// }
//
// class _CreateEventDialogState extends State<CreateEventDialog> {
//
//   int _selectedColorIndex = 0;
//   final _eventNameController = TextEditingController();
//   File? _selectedImage; // 이미지를 저장할 변수
//
//   String _rangeButtonText = 'Select date';
//
//   DateTime? _beginDate;
//   DateTime? _endDate;
//
//   @override
//   void dispose() {
//     _eventNameController.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Dialog(
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxHeight: size.height * 0.7,
//           maxWidth: size.width * 0.8,
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Dialog title.
//                 const Text(
//                   '내용을 추가하세요',
//                   style: TextStyle(
//                     color: Color(0xff69695D),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//
//                 TextField(
//                   cursorColor: Color(0xff69695D),
//                   style:
//                       const TextStyle(color: Color(0xff69695D), fontSize: 16),
//                   decoration: InputDecoration(
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide:
//                           BorderSide(color: Color(0xff69695D).withOpacity(1)),
//                     ),
//                     hintText: 'Enter the event name',
//                     hintStyle: TextStyle(
//                         color: Color(0xff69695D).withOpacity(0.6),
//                         fontSize: 16),
//                   ),
//                   controller: _eventNameController,
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Color selection section.
//                 const Text(
//                   'Select event color',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xff69695D),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//
//                 // Color selection row.
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ...List.generate(
//                         eventColors.length,
//                         (index) => GestureDetector(
//                           onTap: () {
//                             _selectColor(index);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8),
//                             child: Container(
//                               foregroundDecoration: BoxDecoration(
//                                 border: index == _selectedColorIndex
//                                     ? Border.all(
//                                         color: Colors.black.withOpacity(0.3),
//                                         width: 2)
//                                     : null,
//                                 shape: BoxShape.circle,
//                                 color: eventColors[index],
//                               ),
//                               width: 32,
//                               height: 32,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Image upload button.
//                 ElevatedButton(
//                   onPressed: _pickImage,
//                   child: const Text('Upload Image'),
//                 ),
//
//                 // Display selected image.
//                 if (_selectedImage != null)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Image.file(_selectedImage!),
//                   ),
//
//                 // Date selection button.
//                 TextButton(
//                   onPressed: _showRangePicker,
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.calendar_today_outlined,
//                         color: Color(0xff69695D),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         _rangeButtonText,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Color(0xff69695D),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     // Cancel button.
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('CANCEL'),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//
//                     // OK button.
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed:
//                             _validateEventData() ? _onEventCreation : null,
//                         child: const Text('OK'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Select color on tap.
//   void _selectColor(int index) {
//     setState(() {
//       _selectedColorIndex = index;
//     });
//   }
//
//   // Set range picker button text.
//   void _setRangeData(DateTime? begin, DateTime? end) {
//     if (begin == null || end == null) {
//       return;
//     }
//     setState(() {
//       _beginDate = begin;
//       _endDate = end;
//       _rangeButtonText = _parseDateRange(begin, end);
//     });
//   }
//
//   // Parse selected date to readable format.
//   String _parseDateRange(DateTime begin, DateTime end) {
//     if (begin.isAtSameMomentAs(end)) {
//       return begin.format(kDateRangeFormat);
//     } else {
//       return '${begin.format(kDateRangeFormat)} - ${end.format(kDateRangeFormat)}';
//     }
//   }
//
//   // Validate event info for enabling "OK" button.
//   bool _validateEventData() {
//     return _eventNameController.text.isNotEmpty &&
//         _beginDate != null &&
//         _endDate != null;
//   }
//
//   // Close dialog and pass CalendarEventModel as arguments.
//   void _onEventCreation() {
//     final beginDate = _beginDate;
//     final endDate = _endDate;
//     if (beginDate == null || endDate == null) {
//       return;
//     }
//     Navigator.of(context).pop(
//       CalendarEventModel(
//         name: _eventNameController.text,
//         begin: beginDate,
//         end: endDate,
//         eventColor: eventColors[_selectedColorIndex],
//         eventImage: _selectedImage, // Add image
//       ),
//     );
//   }
//
//   // Show calendar in pop up dialog for selecting date range for calendar event.
//   void _showRangePicker() {
//     FocusScope.of(context).unfocus();
//     showCrDatePicker(
//       context,
//       properties: DatePickerProperties(
//         onDateRangeSelected: _setRangeData,
//         dayItemBuilder: (properties) =>
//             PickerDayItemWidget(properties: properties),
//         weekDaysBuilder: (day) => WeekDaysWidget(day: day),
//         initialPickerDate: _beginDate ?? DateTime.now(),
//         pickerTitleBuilder: (date) => DatePickerTitle(date: date),
//         yearPickerItemBuilder: (year, isPicked) => Container(
//           height: 24,
//           width: 54,
//           decoration: BoxDecoration(
//             color: isPicked ? Color(0xff69695D) : Colors.white,
//             borderRadius: const BorderRadius.all(Radius.circular(8)),
//           ),
//           child: Center(
//             child: Text(
//               year.toString(),
//               style: TextStyle(
//                   color: isPicked ? Colors.white : Color(0xff69695D),
//                   fontSize: 16),
//             ),
//           ),
//         ),
//         controlBarTitleBuilder: (date) => Text(
//           DateFormat(kAppBarDateFormat).format(date),
//           style: const TextStyle(
//             fontSize: 16,
//             color: Color(0xff69695D),
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//         okButtonBuilder: (onPress) => ElevatedButton(
//           onPressed: () => onPress?.call(),
//           child: const Text('OK'),
//         ),
//         cancelButtonBuilder: (onPress) => OutlinedButton(
//           onPressed: () => onPress?.call(),
//           child: const Text('CANCEL'),
//         ),
//       ),
//     );
//   }
//
//   // Image picker method
//   Future<void> _pickImage() async {
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//       });
//     }
//   }
// }
//
// class PickerDayItemWidget extends StatelessWidget {
//   const PickerDayItemWidget({
//     required this.properties,
//     super.key,
//   });
//
//   final DayItemProperties properties;
//
//   @override
//   Widget build(BuildContext context) {
//     /// Lock aspect ratio of items to be rectangle.
//     return AspectRatio(
//       aspectRatio: 1 / 1,
//       child: Stack(
//         children: [
//           /// Semi transparent violet background for days in selected range.
//           if (properties.isInRange)
//
//             /// For first and last days in range background color visible only
//             /// on one side.
//             Row(
//               children: [
//                 Expanded(
//                     child: Container(
//                         color: properties.isFirstInRange
//                             ? Colors.transparent
//                             : Color(0xff69695D).withOpacity(0.4))),
//                 Expanded(
//                     child: Container(
//                         color: properties.isLastInRange
//                             ? Colors.transparent
//                             : Color(0xff69695D).withOpacity(0.4))),
//               ],
//             ),
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: properties.isFirstInRange ||
//                       properties.isLastInRange ||
//                       properties.isSelected
//                   ? Color(0xff69695D)
//                   : Colors.transparent,
//             ),
//             child: Center(
//               child: Text('${properties.dayNumber}',
//                   style: TextStyle(
//                       color: properties.isInRange || properties.isSelected
//                           ? Colors.white
//                           : Color(0xff69695D)
//                               .withOpacity(properties.isInMonth ? 1 : 0.5))),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DatePickerTitle extends StatelessWidget {
//   const DatePickerTitle({
//     required this.date,
//     super.key,
//   });
//
//   final DateTime date;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: const EdgeInsets.only(top: 16),
//         alignment: Alignment.centerLeft,
//         child: Text(
//           date.format(kMonthFormatWidthYear),
//           style: const TextStyle(
//             fontSize: 21,
//             color: Color(0xff69695D),
//             fontWeight: FontWeight.w500,
//           ),
//         ));
//   }
// }
//
// class DayEventsBottomSheet extends StatelessWidget {
//   const DayEventsBottomSheet({
//     required this.screenHeight,
//     required this.events,
//     required this.day,
//     super.key,
//   });
//
//   final List<CalendarEventModel> events;
//   final DateTime day;
//   final double screenHeight;
//
//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//         maxChildSize: 0.9,
//         expand: false,
//         builder: (context, controller) {
//           return events.isEmpty
//               ? const Center(child: Text('No events for this day'))
//               : ListView.builder(
//                   controller: controller,
//                   itemCount: events.length + 1,
//                   itemBuilder: (context, index) {
//                     if (index == 0) {
//                       return Padding(
//                         padding: const EdgeInsets.only(
//                           left: 18,
//                           top: 16,
//                           bottom: 16,
//                         ),
//                         child: Text(day.format('dd/MM/yy')),
//                       );
//                     } else {
//                       final event = events[index - 1];
//                       return Container(
//                           height: 100,
//                           child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 4),
//                               child: Card(
//                                   clipBehavior: Clip.antiAlias,
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         color: event.eventColor,
//                                         width: 6,
//                                       ),
//                                       Expanded(
//                                           child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(left: 16),
//                                         child: Align(
//                                           alignment: Alignment.centerLeft,
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 event.name,
//                                                 style: const TextStyle(
//                                                     fontSize: 16),
//                                               ),
//                                               const SizedBox(height: 8),
//                                               Text(
//                                                 '${event.begin.format(kDateRangeFormat)} - '
//                                                 '${event.end.format(kDateRangeFormat)}',
//                                                 style: const TextStyle(
//                                                     fontSize: 14),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ))
//                                     ],
//                                   ))));
//                     }
//                   });
//         });
//   }
// }
//
// /// Widget of day item cell for calendar
// class DayItemWidget extends StatelessWidget {
//   const DayItemWidget({
//     required this.properties,
//     super.key,
//   });
//
//   final DayItemProperties properties;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(
//               color: Color(0xff69695D).withOpacity(0.3), width: 0.3)),
//       child: Stack(
//         children: [
//           Container(
//             padding: const EdgeInsets.only(top: 4),
//             alignment: Alignment.topCenter,
//             child: Container(
//               height: 18,
//               width: 18,
//               decoration: BoxDecoration(
//                 color: properties.isCurrentDay
//                     ? Color(0xff69695D)
//                     : Colors.transparent,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text('${properties.dayNumber}',
//                     style: TextStyle(
//                         color: properties.isCurrentDay
//                             ? Colors.white
//                             : Color(0xff69695D)
//                                 .withOpacity(properties.isInMonth ? 1 : 0.5))),
//               ),
//             ),
//           ),
//           if (properties.notFittedEventsCount > 0)
//             Container(
//               padding: const EdgeInsets.only(right: 2, top: 2),
//               alignment: Alignment.topRight,
//               child: Text('+${properties.notFittedEventsCount}',
//                   style: TextStyle(
//                       fontSize: 10,
//                       color: Color(0xff69695D)
//                           .withOpacity(properties.isInMonth ? 1 : 0.5))),
//             ),
//         ],
//       ),
//     );
//   }
// }


  class CalendarWidget extends StatefulWidget {
    @override
    _CalendarWidgetState createState() => _CalendarWidgetState();
  }
  
  class _CalendarWidgetState extends State<CalendarWidget> {
    DateTime selectedDate = DateTime.now();
  
    final weekDayAbbreviations = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
  
    @override
    Widget build(BuildContext context) {
      return Column(
        children: <Widget>[
          _buildHeader(),
          SizedBox(height: 30),
          _buildWeekDays(),
          Expanded(
            child: _buildCalendar(),
          ),
        ],
      );
    }
  
    Widget _buildHeader() {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month - 1,
                    selectedDate.day,
                  );
                });
              },
            ),
            Text(
              "${selectedDate.year}년 ${selectedDate.month}월",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                setState(() {
                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month + 1,
                    selectedDate.day,
                  );
                });
              },
            ),
          ],
        ),
      );
    }
  
    Widget _buildWeekDays() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16), // 간격 추가
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDayAbbreviations.map((day) {
            return Text(
              day,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
      );
    }
  
    Widget _buildCalendar() {
      final now = DateTime.now(); // 현재 날짜 가져오기
      final daysInMonth = DateTime(
        selectedDate.year,
        selectedDate.month + 1,
        0,
      ).day;
      final firstDayOfMonth = DateTime(
        selectedDate.year,
        selectedDate.month,
        1,
      );
      final weekDayOfFirstDay = firstDayOfMonth.weekday;
  
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemBuilder: (context, index) {
          if (index < weekDayOfFirstDay - 1 ||
              index >= daysInMonth + weekDayOfFirstDay - 1) {
            return Container();
          } else {
            final day = index - (weekDayOfFirstDay - 1) + 1;
            final isToday = now.year == selectedDate.year &&
                now.month == selectedDate.month && now.day == day;
  
            return GestureDetector(
              onTap: () {
                print("Selected date: ${selectedDate.year}-${selectedDate
                    .month}-$day");
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
  
                  color: isToday ? Colors.red : Colors
                      .transparent, // 오늘 날짜면 빨간색 동그라미, 아니면 투명
                ),
                child: Text(
                  "$day",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.white : Colors
                        .black, // 오늘 날짜면 글자 색상 변경
                  ),
                ),
              ),
            );
          }
        },
        itemCount: 7 * 6,
      );
    }
  }