import 'package:flutter/material.dart';
import 'package:huna_ksa/Components/constants.dart';
import 'package:huna_ksa/Components/session.dart' as session;
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
    );
  }
}
