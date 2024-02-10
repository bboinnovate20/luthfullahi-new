import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final Function onSearch;
  const SearchCard({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        cursorColor: Colors.black,
        style: const TextStyle(color: Colors.black),
        onChanged: (value) {
          onSearch(value);
        },
        decoration: const InputDecoration(
          filled: true,
          prefixIcon: Icon(Icons.search_rounded),
          focusColor: Colors.black,
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          fillColor: Colors.black12,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          hintText: 'Search',
        ),
      ),
    );
  }
}
