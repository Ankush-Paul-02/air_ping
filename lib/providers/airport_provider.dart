import 'package:flutter/material.dart';

import '../models/airport.dart';

class AirportProvider extends ChangeNotifier {
  static const List<Airport> _allAirports = [
    Airport(
      code: 'CCU',
      name: 'Netaji Subhas Chandra Bose International Airport',
      city: 'Kolkata',
      state: 'West Bengal',
    ),
    Airport(
      code: 'DEL',
      name: 'Indira Gandhi International Airport',
      city: 'New Delhi',
      state: 'Delhi',
    ),
    Airport(
      code: 'BOM',
      name: 'Chhatrapati Shivaji Maharaj International Airport',
      city: 'Mumbai',
      state: 'Maharashtra',
    ),
    Airport(
      code: 'BLR',
      name: 'Kempegowda International Airport',
      city: 'Bengaluru',
      state: 'Karnataka',
    ),
    Airport(
      code: 'HYD',
      name: 'Rajiv Gandhi International Airport',
      city: 'Hyderabad',
      state: 'Telangana',
    ),
    Airport(
      code: 'MAA',
      name: 'Chennai International Airport',
      city: 'Chennai',
      state: 'Tamil Nadu',
    ),
    Airport(
      code: 'GOI',
      name: 'Manohar International Airport',
      city: 'Goa',
      state: 'Goa',
    ),
    Airport(
      code: 'COK',
      name: 'Cochin International Airport',
      city: 'Kochi',
      state: 'Kerala',
    ),
    Airport(
      code: 'PNQ',
      name: 'Pune Airport',
      city: 'Pune',
      state: 'Maharashtra',
    ),
    Airport(
      code: 'AMD',
      name: 'Sardar Vallabhbhai Patel International Airport',
      city: 'Ahmedabad',
      state: 'Gujarat',
    ),
    Airport(
      code: 'JAI',
      name: 'Jaipur International Airport',
      city: 'Jaipur',
      state: 'Rajasthan',
    ),
    Airport(
      code: 'LKO',
      name: 'Chaudhary Charan Singh International Airport',
      city: 'Lucknow',
      state: 'Uttar Pradesh',
    ),
    Airport(
      code: 'PAT',
      name: 'Jay Prakash Narayan Airport',
      city: 'Patna',
      state: 'Bihar',
    ),
    Airport(
      code: 'IXB',
      name: 'Bagdogra Airport',
      city: 'Bagdogra',
      state: 'West Bengal',
    ),
    Airport(
      code: 'GAU',
      name: 'Lokpriya Gopinath Bordoloi International Airport',
      city: 'Guwahati',
      state: 'Assam',
    ),
    Airport(
      code: 'IXC',
      name: 'Shaheed Bhagat Singh International Airport',
      city: 'Chandigarh',
      state: 'Chandigarh',
    ),
    Airport(
      code: 'BBI',
      name: 'Biju Patnaik International Airport',
      city: 'Bhubaneswar',
      state: 'Odisha',
    ),
    Airport(
      code: 'NAG',
      name: 'Dr. Babasaheb Ambedkar International Airport',
      city: 'Nagpur',
      state: 'Maharashtra',
    ),
    Airport(
      code: 'TRV',
      name: 'Trivandrum International Airport',
      city: 'Thiruvananthapuram',
      state: 'Kerala',
    ),
    Airport(
      code: 'SXR',
      name: 'Sheikh ul-Alam International Airport',
      city: 'Srinagar',
      state: 'Jammu and Kashmir',
    ),
    Airport(
      code: 'IXA',
      name: 'Maharaja Bir Bikram Airport',
      city: 'Agartala',
      state: 'Tripura',
    )
  ];

  String _query = '';

  String get query => _query;

  List<Airport> get allAirports => List.unmodifiable(_allAirports);

  List<Airport> get filteredAirports {
    if (_query.trim().isEmpty) {
      return allAirports;
    }

    final searchQuery = _query.trim().toLowerCase();

    return _allAirports.where((airport) {
      return airport.searchText.contains(searchQuery);
    }).toList();
  }

  List<Airport> get popularAirports {
    const popularCodes = ['DEL', 'BOM', 'BLR', 'CCU', 'HYD', 'MAA'];

    return _allAirports
        .where((airport) => popularCodes.contains(airport.code))
        .toList();
  }

  void searchAirports(String value) {
    _query = value;
    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    notifyListeners();
  }

  Airport? findByCode(String code) {
    for (final airport in _allAirports) {
      if (airport.code.toUpperCase() == code.toUpperCase()) {
        return airport;
      }
    }

    return null;
  }
}
