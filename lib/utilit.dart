import 'package:flutter/material.dart';

Widget loading()
{
  return Center(
    child: CircularProgressIndicator(),
  );
}

Widget connectionerror()
{
  return Center(
    child: Text('Connection Error!',style: TextStyle(color: Colors.red),),
  );
}

Widget nodata()
{
  return Center(
    child: Text('No Data Available!',style: TextStyle(color: Colors.red),),
  );
}