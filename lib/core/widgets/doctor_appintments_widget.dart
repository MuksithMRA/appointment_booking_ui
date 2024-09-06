import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../authentication/providers/authentication_provider.dart';
import '../models/appointment_model.dart';
import '../utils/formatter.dart';
import '../utils/screen_size.dart';

class DoctorAppointmentsWidget extends StatefulWidget {
  const DoctorAppointmentsWidget({super.key});

  @override
  State<DoctorAppointmentsWidget> createState() =>
      _DoctorAppointmentsWidgetState();
}

class _DoctorAppointmentsWidgetState extends State<DoctorAppointmentsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Dr ${context.read<AuthenticationProvider>().fullName}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "You can view your appointments and manage your schedule here.",
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
              DataColumn(label: Text('Appointment No')),
              DataColumn(label: Text('Patient Name')),
              DataColumn(label: Text('Scheduled On')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Action')),
            ],
            source: DataSource(
              data: [
                AppointmentModel(
                  id: 1,
                  patientName: 'John Doe',
                  scheduledDateTime: DateTime.now(),
                  status: 'Booked',
                ),
                AppointmentModel(
                  id: 2,
                  patientName: 'John Doe',
                  scheduledDateTime: DateTime.now(),
                  status: 'CheckedIn',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DataSource extends DataTableSource {
  final List<AppointmentModel> data;

  DataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.id.toString())),
      DataCell(Text(item.patientName)),
      DataCell(Text(Formatter.formatDateTime(item.scheduledDateTime!))),
      DataCell(Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: Colors.white),
        ),
        label: Text(
          item.status,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: item.status == 'Booked'
            ? Colors.orange
            : item.status == 'CheckedIn'
                ? Colors.blue
                : Colors.green,
      )),
      DataCell(Row(
        children: [
          IconButton(
            tooltip: "Mark as Completed",
            icon: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
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
