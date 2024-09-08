import 'package:asiri/core/models/slot_model.dart';
import 'package:asiri/core/providers/slot_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/formatter.dart';
import '../utils/screen_size.dart';

class ScheduleWorkBench extends StatefulWidget {
  final List<SlotModel> slots;
  final Function()? onRefresh;
  const ScheduleWorkBench({super.key, required this.slots, this.onRefresh});

  @override
  State<ScheduleWorkBench> createState() => _ScheduleWorkBenchState();
}

class _ScheduleWorkBenchState extends State<ScheduleWorkBench> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Schedule Workbench",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Create and manage your schedule here.",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      "Add Schedule",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please  select a date';
                              }
                              return null;
                            },
                            controller: dateController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? dateTime = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 30)),
                              );
                              if (dateTime != null) {
                                dateController.text =
                                    Formatter.formatDateTime(dateTime);
                                selectedDate = dateTime;
                                setState(() {});
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Select slot date",
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a time';
                              }
                              return null;
                            },
                            controller: timeController,
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                timeController.text = time.format(context);
                                selectedTime = time;
                                setState(() {});
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Select slot time",
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () async{
                                  if (formKey.currentState!.validate()) {
                                    await context.read<SlotProvider>().addSlot(
                                          SlotModel(
                                            scheduleDateTime: DateTime(
                                              selectedDate!.year,
                                              selectedDate!.month,
                                              selectedDate!.day,
                                              selectedTime!.hour,
                                              selectedTime!.minute,
                                            ),
                                            slotStatus: 'Available',
                                          ),
                                        );
                                    widget.onRefresh?.call();
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Schedule"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: ScreenSize.width * 0.7,
          child: PaginatedDataTable(
            showEmptyRows: false,
            availableRowsPerPage: const [5, 10, 20],
            rowsPerPage: 5,
            columns: const [
              DataColumn(label: Text('Schedule No')),
              DataColumn(label: Text('Scheduled On')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Action')),
            ],
            source: ScheduleDataSource(data: widget.slots),
          ),
        ),
      ],
    );
  }
}

class ScheduleDataSource extends DataTableSource {
  final List<SlotModel> data;

  ScheduleDataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.id.toString())),
      DataCell(Text(Formatter.formatDateTime(item.scheduleDateTime!))),
      DataCell(Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: Colors.white),
        ),
        label: Text(
          item.slotStatus,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: item.slotStatus == 'Available'
            ? Colors.green
            : item.slotStatus == 'Unavailable'
                ? Colors.grey
                : Colors.orange,
      )),
      DataCell(Row(
        children: [
          IconButton(
            tooltip: "Mark as Unavailable",
            icon: const Icon(
              Icons.check_circle_rounded,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
