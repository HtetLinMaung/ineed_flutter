import 'package:flutter/material.dart';
import 'package:ineed_flutter/constants/api.dart';
import 'package:ineed_flutter/store/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<void> showDeleteDialog(BuildContext context) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This will delete permenantly from Database!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () async {
                try {
                  Navigator.of(dialogContext).pop();
                  final store = context.read<AppProvider>();

                  store.setLoading(true);
                  var response = await http.delete(
                    '$api/needs/${store.id}',
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer ${store.token}'
                    },
                  );
                  print(response.statusCode);
                  store.setLoading(false);
                } catch (err) {
                  print(err);
                }
              },
            ),
          ],
        );
      });
}
