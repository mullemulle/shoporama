import '../COMMON/globals.dart' show GlobalValues;

const allGoogleFonts =
    "Roboto,Lato,Open Sans,Montserrat,Oswald,Raleway,Quicksand,Poppins,Nunito,Ubuntu,ABORETO,Geostar,Crimson Text,Playfair Display,Arvo,Alegreya,Merriweather,Lora,Libre Baskerville,Vollkorn,Cinzel,Kranky,Sunshiney,Princess Sofia,Bungee Outline,Ruslan Display,Rubik Maze,Fascinate,Sixtyfour";
const allPaddings = "0,2,5,10,20,30,40,50,70,100,150,200";
const allBoxDecorations = "none,blank,Frame,Rounded frame,Box frame,Full size frame";
const filltype = "none,Full height";
const onMobileFactor = "none,1/2,1/3,fit";
const onMobileImageFit = "none,cover,fitHeight,fitWidth";
const onmobileVisible = "both,only mobile,not mobile";
const navigationVisible = "none,both,only mobile,not mobile";
const yesandno = "yes,no";

const white = "#ffffffff";
const orange = "#ffff9800";
const black = "#ff000000";
const window10 = "#FF6997B3";
const windows10dark = "#FF1B587C";
const darkgreen = "#FFd5f5c9";
const transparent = "#00000000";
const presentationTitle = "#FFFFD700";
const outColor = "#FFFA8072";

const primaryBackground = "#FF4f6367";
const primaryBackgroundDark = "#FF434f52";
const secondaryBackground = "#FFf0efe4";

final defaults = GlobalValues(map: defaultDefinition);

final defaultDefinition = {
  "color": {
    "white": white,
    "black": black,
    "window10": window10,
    "windows10dark": windows10dark,
    "transparent": transparent,
    "app_std_background": window10,
    "app_advertise_collection_background": primaryBackground,
    "app_advertise_features_background": primaryBackground,

    "search_background": primaryBackground,
    "image_selection_background": primaryBackground,
    "sort_background": primaryBackground,
    "property_background": primaryBackground,
    "productlist_background": primaryBackground,
    "qr_list_background": primaryBackground,
    "info_background": white,

    // SWIOME
    "splash_background": white, //"#ff57a340", //primaryBackground, //window10, //"#FF3AA6B9",
  },
  "font": {
    "productTileTitle": {"color": windows10dark, "backgroundcolor": white, "size": 15.0, "fontname": "Montserrat"},
    "productTileText": {"color": window10, "backgroundcolor": white, "size": 12.0, "fontname": "Open Sans"},
    "productTilePrice": {"color": windows10dark, "backgroundcolor": white, "size": 12.0, "fontname": "Open Sans"},

    "snackBarStyle": {"color": orange, "backgroundcolor": black, "size": 12.0, "fontname": "Open Sans"},

    "chat_user_name": {"color": windows10dark, "backgroundcolor": transparent, "size": 9.0, "fontname": "Open Sans"},
    "chat_me": {"color": windows10dark, "backgroundcolor": darkgreen, "size": 13.0, "fontname": "Open Sans"},
    "chat_other": {"color": white, "backgroundcolor": window10, "size": 13.0, "fontname": "Open Sans"},

    "site_title": {"color": windows10dark, "backgroundcolor": transparent, "size": 30.0, "fontname": "Montserrat"},
    "small_text": {"color": window10, "backgroundcolor": transparent, "size": 10.0, "fontname": "Montserrat"},
    "snackbartitlefont": {"color": white, "backgroundcolor": black, "size": 12.0, "fontname": "Montserrat"},

    "table_text": {"color": white, "backgroundcolor": black, "size": 12.0, "fontname": "Montserrat"},

    "standarderrorfont": {"color": windows10dark, "backgroundcolor": transparent, "size": 15.0, "fontname": "Montserrat"},
    "inputfont": {"color": windows10dark, "backgroundcolor": transparent, "size": 22.0, "fontname": "Montserrat"},
    "button": {"color": window10, "backgroundcolor": transparent, "size": 18.0, "fontname": "Montserrat"},

    "popup_analyse": {"color": windows10dark, "backgroundcolor": white, "size": 20.0, "fontname": "Montserrat"},
    // login
    "sigintitlefont": {"color": white, "backgroundcolor": transparent, "size": 55.0, "fontname": "Montserrat"},
    "sigintextfont": {"color": white, "backgroundcolor": transparent, "size": 15.0, "fontname": "Lato"},
    "sigininputfont": {"color": white, "backgroundcolor": white, "size": 30.0, "fontname": "Lato"},
    "siginbuttonfont": {"color": white, "backgroundcolor": transparent, "size": 20.0, "fontname": "Lato"},

    // Empty screen
    "advertiser_title": {"color": white, "backgroundcolor": transparent, "size": 25.0, "fontname": "Montserrat"},

    // Markdown
    "markdowntitlefont": {"color": darkgreen, "backgroundcolor": "00000000", "size": 20.0, "fontname": "Montserrat"}, // DONE - Collection hjælp
    "markdownsubtitlefont": {"color": darkgreen, "backgroundcolor": "00000000", "size": 18.0, "fontname": "Montserrat"}, // DONE - Collection hjælp
    "markdowntextfont": {"color": darkgreen, "backgroundcolor": "00000000", "size": 15, "fontname": "Lato", "height": 1.6}, // DONE - Collection hjælp
    "feed_markdowntitlefont": {"color": windows10dark, "backgroundcolor": "00000000", "size": 20.0, "fontname": "Montserrat"}, // DONE - Collection hjælp
    "feed_markdownsubtitlefont": {"color": windows10dark, "backgroundcolor": "00000000", "size": 18.0, "fontname": "Montserrat"}, // DONE - Collection hjælp
    "feed_markdowntextfont": {"color": windows10dark, "backgroundcolor": "00000000", "size": 15, "fontname": "Lato", "height": 1.2}, // DONE - Collection hjælp
    // PROPERTIES
    "property_headerfont": {"color": windows10dark, "backgroundcolor": outColor, "size": 18.0, "fontname": "Montserrat"},
    "property_titlefont": {"color": windows10dark, "backgroundcolor": transparent, "size": 15.0, "fontname": "Montserrat"},
    "property_tilefont": {"color": windows10dark, "backgroundcolor": transparent, "size": 15.0, "fontname": "Montserrat"},
    "property_inputfont": {"color": windows10dark, "backgroundcolor": white, "size": 15.0, "fontname": "Montserrat"},
    "property_subtitlefont": {"color": window10, "backgroundcolor": transparent, "size": 13.0, "fontname": "Montserrat"},
    "property_navigationfont": {"color": white, "backgroundcolor": window10, "size": 15.0, "fontname": "Montserrat"},
    "property_labelfont": {"color": window10, "backgroundcolor": "00000000", "size": 13.0, "fontname": "Lato"},
    "property_hintfont": {"color": window10, "backgroundcolor": "00000000", "size": 15.0, "fontname": "Lato"},

    // POPUP
    "popup_titlefont": {"color": windows10dark, "backgroundcolor": transparent, "size": 18.0, "fontname": "Montserrat"},
    "popup_inputfont": {"color": window10, "backgroundcolor": transparent, "size": 15.0, "fontname": "Lato"},
    "popup_buttonfont": {"color": window10, "backgroundcolor": transparent, "size": 15.0, "fontname": "Lato"},

    // Presentation
    "titlePresentationfont": {"color": presentationTitle, "backgroundcolor": transparent, "size": 55.0, "fontname": "Montserrat"},
    "textPresentationfont": {"color": window10, "backgroundcolor": transparent, "size": 40.0, "fontname": "Lato"},
    "inputPresentationfont": {"color": windows10dark, "backgroundcolor": transparent, "size": 30.0, "fontname": "Lato"},

    // SWIOME
    "menu": {"color": windows10dark, "backgroundcolor": transparent, "size": 15.0, "fontname": "Montserrat"},

    "titlefont": {"color": black, "backgroundcolor": transparent, "size": 17.0, "fontname": "Montserrat"},
    "subtitlefont": {"color": windows10dark, "backgroundcolor": transparent, "size": 15.0, "fontname": "Lato"},

    "tiletitlefont": {"color": windows10dark, "backgroundcolor": transparent, "size": 15.0, "fontname": "Montserrat"}, // DONE - Collection oversigt
    "tilesubtitlefont": {"color": window10, "backgroundcolor": transparent, "size": 12.0, "fontname": "Lato"}, // DONE - Collection oversigt
    "tilebuttonfont": {"color": windows10dark, "backgroundcolor": white, "size": 15.0, "fontname": "Montserrat"}, // DONE - Collection oversigt

    "lookupTitle": {"color": windows10dark, "backgroundcolor": transparent, "size": 15.0, "fontname": "Montserrat"}, // DONE - Collection oversigt

    "popuptitlefont": {"color": black, "backgroundcolor": white, "size": 15.0, "fontname": "Montserrat"},
    "singleActionStyle": {"color": windows10dark, "backgroundcolor": windows10dark, "size": 15.0, "fontname": "Montserrat"},
  },
  "value": {"internal_padding_top": "0.0", "padding_left": "20.0", "padding_right": "20.0", "padding_top": "20.0", "padding_bottom ": "20.0", "margin_bottom": "0.0"},
  "decoration": {
    "help": {"border": true, "radius": 10, "color": white, "backgroundcolor": outColor},
    "button": {"border": true, "radius": 20, "color": window10, "backgroundcolor": transparent},
    "select_image": {"border": true, "radius": 5, "color": primaryBackgroundDark, "backgroundcolor": primaryBackgroundDark},
  },
  "padding": {
    "button": {"left": 20, "right": 20, "top": 3, "bottom": 3},
    "buttonMargin": {"left": 0, "right": 0, "top": 10, "bottom": 10},
  },
  "property": {'value': {}, "standard": {}},
};
