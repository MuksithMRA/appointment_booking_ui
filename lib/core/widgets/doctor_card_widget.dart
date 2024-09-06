import 'package:asiri/authentication/models/doctor_model.dart';
import 'package:asiri/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../utils/screen_size.dart';

class DoctorCardWidget extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorCardWidget({
    required this.doctor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isFutureDay = !(doctor.isToday() || doctor.isTomorrow());

    return Container(
      width: ScreenSize.width * 0.25,
      height: ScreenSize.width * 0.2,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(doctor.avatar),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${doctor.firstName} ${doctor.lastName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(doctor.specialization),
                ],
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      context
                          .read<DoctorProvider>()
                          .updateSelectedDateTime(doctor.id, DateTime.now());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: doctor.isToday() ? Colors.blue : null,
                        borderRadius: BorderRadius.circular(5),
                        border: !doctor.isToday()
                            ? Border.all(color: Colors.black, width: 1)
                            : null,
                      ),
                      child: Text(
                        "Today",
                        style: TextStyle(
                            color: doctor.isToday() ? Colors.white : null),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      context.read<DoctorProvider>().updateSelectedDateTime(
                          doctor.id,
                          DateTime.now().add(const Duration(days: 1)));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: doctor.isTomorrow() ? Colors.blue : null,
                        borderRadius: BorderRadius.circular(5),
                        border: !doctor.isTomorrow()
                            ? Border.all(color: Colors.black, width: 1)
                            : null,
                      ),
                      child: Text(
                        "Tomorrow",
                        style: TextStyle(
                            color: doctor.isTomorrow() ? Colors.white : null),
                      ),
                    ),
                  )
                ],
              ),
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () async {
                  final selectedDateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                      const Duration(days: 30),
                    ),
                    initialDate: DateTime.now(),
                  );

                  if (selectedDateTime != null) {
                    // ignore: use_build_context_synchronously
                    context
                        .read<DoctorProvider>()
                        .updateSelectedDateTime(doctor.id, selectedDateTime);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isFutureDay ? Colors.blue : null,
                    borderRadius: BorderRadius.circular(30),
                    border: isFutureDay
                        ? null
                        : Border.all(color: Colors.blue, width: 1),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        isFutureDay
                            ? Formatter.formatDate(doctor.selectedDateTime)
                            : "Calendar",
                        style: TextStyle(
                          fontSize: 12,
                          color: isFutureDay ? Colors.white : Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 13,
                        backgroundColor:
                            isFutureDay ? Colors.white : Colors.blue,
                        child: Icon(
                          Icons.calendar_month,
                          color: isFutureDay ? Colors.blue : Colors.white,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          Expanded(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: doctor.getSlotsbyDateTime()
                  .map(
                    (e) =>  Chip(
                      label: Text(e.slotFormattedTime),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
