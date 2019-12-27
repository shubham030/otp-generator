import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otp_generator/ui/bloc/otp_generator_bloc.dart';
import 'package:otp_generator/ui/widgets/table_row.dart';

class BuildTable extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final OtpGeneratorBloc otpGeneratorBloc;

  const BuildTable({
    Key key,
    this.snapshot,
    this.otpGeneratorBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 20;
    return Column(
      children: [
        Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    border: Border(
                      right: BorderSide(width: 1),
                    ),
                  ),
                  child: Center(
                      child: Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
              Container(
                width: width * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  border: Border(
                    right: BorderSide(width: 1),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Otp',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: width * 0.20,
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    'Action',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ...snapshot.data.documents.map((DocumentSnapshot document) {
          otpGeneratorBloc.existingEmail.add(document['email']);
          return CustomTableRow(
            key: GlobalKey(),
            id: document.documentID,
            email: document['email'],
            otp: document['otp'],
            timeStamp: document['timeStamp'].toDate(),
          );
        }).toList(),
      ],
    );
  }
}

//without timer
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:otp_generator/ui/bloc/otp_generator_bloc.dart';
// import 'package:otp_generator/ui/models/otp_time_info.dart';

// class BuildTable extends StatelessWidget {
//   final AsyncSnapshot<QuerySnapshot> snapshot;
//   final OtpGeneratorBloc otpGeneratorBloc;

//   const BuildTable({Key key, this.snapshot, this.otpGeneratorBloc})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Table(
//       border: TableBorder.all(width: 1.0, color: Colors.black),
//       columnWidths: {
//         1: FractionColumnWidth(0.1),
//         2: FractionColumnWidth(0.2),
//         3: FractionColumnWidth(0.8),
//       },
//       defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//       children: [
//         TableRow(
//           children: [
//             TableCell(
//               child: Container(
//                 color: Colors.grey,
//                 height: 30,
//                 child: Center(
//                   child: Text(
//                     'Email',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//             TableCell(
//               child: Container(
//                 color: Colors.grey,
//                 height: 30,
//                 child: Center(
//                   child: Text(
//                     'Otp',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//             TableCell(
//               child: Container(
//                 color: Colors.grey,
//                 height: 30,
//                 child: Center(
//                   child: Text(
//                     'Action',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         ...snapshot.data.documents.map((DocumentSnapshot document) {
//           otpGeneratorBloc.existingEmail.add(document['email']);
//           DateTime x = document['timeStamp'].toDate();
//           otpGeneratorBloc.otpTime.add(
//             OtpTime(
//               document.documentID,
//               x.add(Duration(minutes: 1)),
//             ),
//           );
//           return TableRow(
//             children: [
//               TableCell(
//                 child: Text(
//                   '  ${document['email']}',
//                 ),
//               ),
//               TableCell(
//                 child: Center(
//                   child: Text(
//                     document['otp'].toString(),
//                   ),
//                 ),
//               ),
//               TableCell(
//                 child: FlatButton(
//                   child: Text('Delete'),
//                   onPressed: () {
//                     otpGeneratorBloc.deleteOtp(document.documentID);
//                   },
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ],
//     );
//   }
// }
