class AppConfig {
  static String API_BASE_URL = "https://app.alsukssd.com/api";

  // static String API_BASE_URL = "http://10.0.2.2:8888/alsuk-backend/api";
  static String CURRENCY = "UGX";
  static const String ONESIGNAL_APP_ID = "89e02cdc-adf7-436d-8931-2f789bcd740a";

  static const String DASHBOARD_URL = "https://app.alsukssd.com";
  static const String APP_LINK =
      "https://play.google.com/store/apps/details?id=alsukssd.com";
  // dart run change_app_package_name:main alsukssd.com

  /*static const String DASHBOARD_URL = "http://10.0.2.2:8000/ham";*/
  static const String APP_VERSION = "1";
  static const String contact = "+256780245409";
  static const String DATABASE_PATH = "AL_SUD_$APP_VERSION";
  static const int DATABASE_VERSION = 1;

  static const String MAIN_SITE_URL = DASHBOARD_URL;

  // static const String MAIN_SITE_URL = "http://10.0.2.2:8888/ham";

  static String APP_NAME = "Al Suk";
  static String logo = "assets/images/logo-2.png";
  static String logo2 = "assets/images/8tech.png";
  static String logos = "assets/images/logo-2.png";
  static String logo_1 = "assets/images/logo-2.png";
  static String logo_2 = "assets/images/logo-2.png";
  static const String USER_ROLE = "USER_ROLE";
  static String logo1 = "assets/images/logo.png";
  static String user_icon = "assets/user.png";
  static const String TestScreen = "TestScreen";
  static const String AccountEdit = "AccountEdit";
  static const String AccountChangePassword = "AccountChangePassword";
  static const String OfflineCasesScreen = "OfflineCasesScreen";
  static const String SectionExhibits = "SectionExhibits";
  static const String SectionSuspect = "SectionSuspect";
  static const String SectionCases = "SectionCases";
  static const String TestHomeScreen = "TestHomeScreen";
  static const String CaseCreateBasicPreviewScreen =
      "CaseCreateBasicPreviewScreen";
  static const String CaseCreateBasicEditScreen = "CaseCreateBasicEditScreen";
  static const String SuspectArrestEditScreen = "SuspectArrestEditScreen";
  static const String OnlineSuspectScreen = "OnlineSuspectScreen";
  static const String SuspectEditScreen = "SuspectEditScreen";
  static const String SuspectCourtEditScreen = "SuspectCourtEditScreen";
  static const String CaseCreateSuspectsListScreen =
      "CaseCreateSuspectsListScreen";
  static const String SuspectCreateBasicEditScreen =
      "SuspectCreateBasicEditScreen";
  static const String LoginScreen = "LoginScreen";
  static const String CaseConfirmationScreen = "CaseConfirmationScreen";
  static const String ExhibitCreateScreen = "ExhibitCreateScreen";
  static const String NO_IMAGE = "assets/images/no_image.png";
  static const String USER_IMAGE = "assets/images/user.png";
  static const String USER_IMAGE_1 = "assets/images/user-1.png";
  static const String OnlineCaseScreen = "OnlineCaseScreen";
  static const String CaseCreateExhibitsListScreen =
      "CaseCreateExhibitsListScreen";
  static const String PROFILE_PICS = "./assets/images/profiles/";
  static const String LOGIN_PICS = "./assets/images/login/";
  static const String lorem_1 =
      "A widget that clips its child using a rectangle. By default, ClipRect prevents its child from painting outside its bounds, but the size and location of the clip rect can be customized using a custom clipper. ClipRect i commonly used with these widgets, which commonly paint outside their bounds: CustomPaint.";

  static const List<String> EDUCATION_LEVELS = [
    '',
    'None',
    'Below primary',
    'Secondary',
    'A-Level',
    'Bachelor',
    'Masters',
    'PhD',
  ];

  static const List<String> COLORS = [
    'Black',
    'Blue',
    'Brown',
    'Green',
    'Grey',
    'Orange',
    'Pink',
    'Purple',
    'Red',
    'White',
    'Yellow',
    'Maroon',
    'Gold',
    'Silver',
    'Bronze',
    'Other',
  ];

  static const List<String> UWA_ARREST_UNITS = [
    '',
    'Canine Unit',
    'WCU',
    'NRCN',
    'LEU',
  ];
  static const List<String> UWA_ARREST_AGENCIES = [
    '',
    'UWA',
    'UPDF',
    'UPF',
    'ESO',
    'ISO',
    'URA',
    'DCIC',
    'INTERPOL',
    'UCAA',
  ];

  static const List<String> export_permit_form_categories = [
    'Seed Merchant',
    'Seed Producer ',
    'Seed Stockist',
    'Seed Importer',
    'Seed Exporter',
    'Seed Processor',
    'Researchers'
  ];

  static const List<String> OFFENCES = [
    '',
    'Category #1',
    'Category #2',
    'Category #3',
    'Category #4',
    'Category #5',
  ];
  static const List<String> CASES_CATEGORIES = [
    '',
    'Category #1',
    'Category #2',
    'Category #3',
    'Category #4',
    'Category #5',
  ];

  static const List<String> COUNTRIES = [
    "",
    "Uganda",
    "Kenya",
    "Tanzania",
    "Sudan",
    "Rwanda",
    "Somalia",
    "Burundi",
    "Afghanistan",
    "Albania",
    "Algeria",
    "American Samoa",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antarctica",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia",
    "Bosnia and Herzegovina",
    "Botswana",
    "Bouvet Island",
    "Brazil",
    "British Indian Ocean Territory",
    "Brunei Darussalam",
    "Bulgaria",
    "Burkina Faso",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cape Verde",
    "Cayman Islands",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Christmas Island",
    "Cocos (Keeling Islands)",
    "Colombia",
    "Comoros",
    "Congo",
    "Cook Islands",
    "Costa Rica",
    "Cote D'Ivoire (Ivory Coast)",
    "Croatia (Hrvatska",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "East Timor",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Ethiopia",
    "Falkland Islands (Malvinas)",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "France",
    "Metropolitan",
    "French Guiana",
    "French Polynesia",
    "French Southern Territories",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guadeloupe",
    "Guam",
    "Guatemala",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Heard and McDonald Islands",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kiribati",
    "Korea (North)",
    "Korea (South)",
    "Kuwait",
    "Kyrgyzstan",
    "Laos",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macau",
    "Macedonia",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Martinique",
    "Mauritania",
    "Mauritius",
    "Mayotte",
    "Mexico",
    "Micronesia",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "Netherlands Antilles",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Niue",
    "Norfolk Island",
    "Northern Mariana Islands",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Pitcairn",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Reunion",
    "Romania",
    "Russian Federation",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Vincent and The Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovak Republic",
    "Slovenia",
    "Solomon Islands",
    "South Africa",
    "S. Georgia and S. Sandwich Isls.",
    "Spain",
    "Sri Lanka",
    "St. Helena",
    "St. Pierre and Miquelon",
    "Suriname",
    "Svalbard and Jan Mayen Islands",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Thailand",
    "Togo",
    "Tokelau",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks and Caicos Islands",
    "Tuvalu",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom (Britain / UK)",
    "United States of America (USA)",
    "US Minor Outlying Islands",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Vatican City State (Holy See)",
    "Venezuela",
    "Viet Nam",
    "Virgin Islands (British)",
    "Virgin Islands (US)",
    "Wallis and Futuna Islands",
    "Western Sahara",
    "Yemen",
    "Yugoslavia",
    "Zaire",
    "Zambia",
    "Zimbabwe"
  ];

  static String app_name = 'Al Suk';
  static String terms =
      'https://www.freeprivacypolicy.com/live/52c38bce-d1dc-4231-9109-3e753daf24c5';
}
