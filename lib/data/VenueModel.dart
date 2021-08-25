import 'dart:core';


class Venue {
  String name;
  String location;
  String description;
  String imageUrl;
  String selectedMenuId;
  String selectedTheme;


  Venue({
    this.name,
    this.location,
    this.description,
    this.selectedMenuId,
    this.selectedTheme,
  });
}