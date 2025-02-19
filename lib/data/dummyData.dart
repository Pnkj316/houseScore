import 'package:houszscore/Utils/app_img.dart';

List<Map<String, dynamic>> dummyData = [
  {
    "propertyAgent": "Agent1",
    "propertyId": "prop_1",
    "name": "Modern Family Home",
    "address": "123 Elm St, Springfield",
    "openHouse": "2024-12-10 10:00 AM",
    "pricePerSqFt": "450",
    "yearBuilt": "2022",
    "lotSize": "3000 sq ft",
    "hoa": "No",
    "status": "For Sale",
    "score": 8,
    "image": AppImage.houseGreen,
    "favorite": false,
    "visited": false,
    "recommended": true
  },
  {
    "propertyAgent": "Agent2",
    "propertyId": "prop_2",
    "name": "Cozy Cottage",
    "address": "456 Maple Rd, Rivertown",
    "openHouse": "2024-12-12 2:00 PM",
    "pricePerSqFt": "350",
    "yearBuilt": "2019",
    "lotSize": "1800 sq ft",
    "hoa": "Yes",
    "status": "Sold",
    "score": 7,
    "image": AppImage.townhouse,
    "favorite": true,
    "visited": true,
    "recommended": false
  },
  {
    "propertyAgent": "Agent3",
    "propertyId": "prop_3",
    "name": "Luxury Downtown Apartment",
    "address": "789 Oak Ave, Metropolis",
    "openHouse": "2024-12-14 12:00 PM",
    "pricePerSqFt": "800",
    "yearBuilt": "2021",
    "lotSize": "1200 sq ft",
    "hoa": "Yes",
    "status": "For Rent",
    "score": 9,
    "image": AppImage.ranch,
    "favorite": false,
    "visited": false,
    "recommended": true
  },
  {
    "propertyAgent": "Agent4",
    "propertyId": "prop_4",
    "name": "Charming Victorian House",
    "address": "101 Rose Blvd, Oldtown",
    "openHouse": "2024-12-16 11:00 AM",
    "pricePerSqFt": "500",
    "yearBuilt": "1910",
    "lotSize": "3500 sq ft",
    "hoa": "No",
    "status": "For Sale",
    "score": 8,
    "image": AppImage.split,
    "favorite": true,
    "visited": false,
    "recommended": false
  },
  {
    "propertyAgent": "Agent5",
    "propertyId": "prop_5",
    "name": "Sleek Modern Loft",
    "address": "202 Pine Ln, Newcity",
    "openHouse": "2024-12-18 4:00 PM",
    "pricePerSqFt": "700",
    "yearBuilt": "2023",
    "lotSize": "1000 sq ft",
    "hoa": "Yes",
    "status": "For Rent",
    "score": 7,
    "image": AppImage.nearby,
    "favorite": false,
    "visited": true,
    "recommended": true
  },
  {
    "propertyAgent": "Agent6",
    "propertyId": "prop_6",
    "name": "Family Ranch",
    "address": "303 Cedar Dr, Greenfields",
    "openHouse": "2024-12-20 3:00 PM",
    "pricePerSqFt": "400",
    "yearBuilt": "2005",
    "lotSize": "5000 sq ft",
    "hoa": "No",
    "status": "For Sale",
    "score": 6,
    "image": AppImage.drive,
    "favorite": true,
    "visited": false,
    "recommended": true
  },
  {
    "propertyAgent": "Agent7",
    "propertyId": "prop_7",
    "name": "Beachside Villa",
    "address": "404 Seaside Ave, Sunnybeach",
    "openHouse": "2024-12-22 1:00 PM",
    "pricePerSqFt": "1000",
    "yearBuilt": "2015",
    "lotSize": "7000 sq ft",
    "hoa": "Yes",
    "status": "For Sale",
    "score": 9,
    "image": AppImage.good_view,
    "favorite": false,
    "visited": false,
    "recommended": true
  },
  {
    "propertyAgent": "Agent8",
    "propertyId": "prop_8",
    "name": "Mountain Retreat",
    "address": "505 Hilltop Rd, Peakview",
    "openHouse": "2024-12-24 10:00 AM",
    "pricePerSqFt": "600",
    "yearBuilt": "2010",
    "lotSize": "4000 sq ft",
    "hoa": "No",
    "status": "For Rent",
    "score": 8,
    "image": AppImage.house,
    "favorite": false,
    "visited": true,
    "recommended": false
  },
  {
    "propertyAgent": "Agent9",
    "propertyId": "prop_9",
    "name": "Urban Studio Apartment",
    "address": "606 City St, Downtown City",
    "openHouse": "2024-12-26 5:00 PM",
    "pricePerSqFt": "850",
    "yearBuilt": "2022",
    "lotSize": "800 sq ft",
    "hoa": "Yes",
    "status": "For Rent",
    "score": 7,
    "image": AppImage.Hao,
    "favorite": true,
    "visited": false,
    "recommended": true
  },
  {
    "propertyAgent": "Agent10",
    "propertyId": "prop_10",
    "name": "Suburban Family Home",
    "address": "707 Birch Ln, Woodside",
    "openHouse": "2024-12-28 6:00 PM",
    "pricePerSqFt": "500",
    "yearBuilt": "2018",
    "lotSize": "3500 sq ft",
    "hoa": "Yes",
    "status": "For Sale",
    "score": 7,
    "image": AppImage.cul_de,
    "favorite": true,
    "visited": true,
    "recommended": false
  },
  {
    "propertyAgent": "Agent11",
    "propertyId": "prop_11",
    "name": "Stylish City Condo",
    "address": "808 Market St, Downtown",
    "openHouse": "2025-01-01 2:00 PM",
    "pricePerSqFt": "950",
    "yearBuilt": "2020",
    "lotSize": "900 sq ft",
    "hoa": "Yes",
    "status": "For Sale",
    "score": 8,
    "image": AppImage.land,
    "favorite": false,
    "visited": true,
    "recommended": true
  },
  {
    "propertyAgent": "Agent12",
    "propertyId": "prop_12",
    "name": "Lakefront Mansion",
    "address": "909 Lakeview Dr, Lakecity",
    "openHouse": "2025-01-03 1:00 PM",
    "pricePerSqFt": "1200",
    "yearBuilt": "2017",
    "lotSize": "10000 sq ft",
    "hoa": "No",
    "status": "For Rent",
    "score": 9,
    "image": AppImage.garage_size,
    "favorite": true,
    "visited": false,
    "recommended": true
  },
  {
    "propertyAgent": "Agent13",
    "propertyId": "prop_13",
    "name": "Eco-Friendly House",
    "address": "1010 Green Rd, Solarpower",
    "openHouse": "2025-01-05 4:00 PM",
    "pricePerSqFt": "700",
    "yearBuilt": "2022",
    "lotSize": "2500 sq ft",
    "hoa": "No",
    "status": "For Sale",
    "score": 7,
    "image": AppImage.backyard,
    "favorite": true,
    "visited": true,
    "recommended": false
  },
  {
    "propertyAgent": "Agent14",
    "propertyId": "prop_14",
    "name": "Contemporary Ranch",
    "address": "1111 Oakwood Ln, Willowbrook",
    "openHouse": "2025-01-07 3:00 PM",
    "pricePerSqFt": "550",
    "yearBuilt": "2021",
    "lotSize": "4200 sq ft",
    "hoa": "Yes",
    "status": "For Rent",
    "score": 6,
    "image": AppImage.ceiling,
    "favorite": false,
    "visited": false,
    "recommended": true
  },
  {
    "propertyAgent": "Agent15",
    "propertyId": "prop_15",
    "name": "Penthouse Suite",
    "address": "1212 Skyline Blvd, Metropolis",
    "openHouse": "2025-01-09 11:00 AM",
    "pricePerSqFt": "2000",
    "yearBuilt": "2023",
    "lotSize": "1500 sq ft",
    "hoa": "Yes",
    "status": "For Rent",
    "score": 9,
    "image": AppImage.mob,
    "favorite": false,
    "visited": false,
    "recommended": true
  }
];
