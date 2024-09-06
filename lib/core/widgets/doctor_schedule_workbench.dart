import 'package:asiri/core/models/slot_model.dart';
import 'package:flutter/material.dart';

import '../models/appointment_model.dart';
import '../utils/formatter.dart';
import '../utils/screen_size.dart';
import 'doctor_appintments_widget.dart';

class ScheduleWorkBench extends StatelessWidget {
  const ScheduleWorkBench({super.key});

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
            source: ScheduleDataSource(
              data: [
                SlotModel(
                  id: 1,
                  scheduleDateTime: DateTime.now(),
                  slotStatus: 'Available',
                ),
                SlotModel(
                  id: 2,
                  scheduleDateTime: DateTime.now().add(const Duration(minutes: 15)),
                  slotStatus: 'Unavailable',
                ),
              ],
            ),
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
