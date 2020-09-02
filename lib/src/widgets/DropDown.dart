//   import 'package:flutter/material.dart';

// Container getDropDown({@required hintText, @required type, @required List<dynamic> valueMap}) {
//     return Container(
//       padding: EdgeInsets.only(left: 20.0, right: 20.0),
//       child: DropdownButtonFormField(
//         hint: Text('$hintText'),
//         isExpanded: true,
//         onChanged: (value) {
//           setState(() {
//             switch (type) {
//               case 'department':
//                 {
//                   departmentValue = value;
//                   break;
//                 }

//               case 'division':
//                 {
//                   divisionValue = value;
//                   break;
//                 }

//               case 'year':
//                 {
//                   yearValue = value;
//                 }
//             }
//           });
//         },
//         validator: (value) => value == null ? 'This field is required' : null,
//         items: valueMap.map((value) {
//           return DropdownMenuItem(
//             value: value,
//             child: Text(
//               '$value',
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
