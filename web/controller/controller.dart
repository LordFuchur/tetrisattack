import 'dart:html';
import 'dart:convert';
import 'dart:async';
import "GameKeyCommunicator.dart";
import "config.dart";
import "../model/Command.dart";
import "../model/Playfield.dart";
import "../model/Level.dart";
import "../View/View.dart";

enum Platformtype
{
  Computer,
  Phone
}


class controller
{
  /**
   * Other Components
   */

  Playfield _currentField;

  View _view;

  GameKeyCommunicator _gamekey;

  /**
   * Periodic Timers
   */
  Timer timerPlaytime;

  Timer timerFieldAction;

  Timer timerFieldUp;

  Timer timerGravity;

  Timer timerView;

  /**
   * Constants
   */

  static const configPath = "";

  static const levelJSonPath = "";

  static const timerPlaytimeDuration = const Duration(seconds: 1);

  static const timerFieldUpDuration = const Duration(seconds: 8);

  static const timerFieldActionDuration = const Duration(milliseconds:  2);

  static const timerGravityDuration = const Duration(milliseconds: 50);

  static const timerViewDuration = const Duration(milliseconds : 1);

  /**
   * Variables
   */

  bool isGameRunning = false;
  bool isPaused = false;
  Platformtype devicePlatform;

  String testJson = '{"_levelNum": 1,"_colors":["#FF0000","#008000","#0000FF","#FFFF00"],"_blocks":["normalBlock"],"_levelTimeSec":120,"_comboHoldTime":2,"_requiredScore":1000,"_startField":[[{"_color":"red","x":0,"y":0},{"_color":"red","x":1,"y":0},{"_color":"red","x":2,"y":0}],[{"_color":"red","x":0,"y":1},{"_color":"red","x":1,"y":1},{"_color":"red","x":2,"y":1}],[{"_color":"red","x":0,"y":2},{"_color":"red","x":1,"y":2},{"_color":"red","x":2,"y":2}],[{"_color":"red","x":0,"y":3},{"_color":"red","x":1,"y":3},{"_color":"red","x":2,"y":3}]]}';
  String testJson2 = '{"_levelNum": 1,"_colors": ["red", "green", "blue", "yellow"],"_blocks": ["normalBlock"],"_levelTimeSec": 120,"_comboHoldTime": 2,"_requiredScore": 1000,"_startField": [[{"_color": "red", "x": 0, "y": 1}, {"_color": "red", "x": 1, "y": 1}, {"_color": "red", "x": 2, "y": 1}, {"_color": "red", "x": 3, "y": 1}, {"_color": "red", "x": 4, "y": 1}, {"_color": "red", "x": 5, "y": 1}, {"_color": "blue", "x": 6, "y": 1}, {"_color": "green", "x": 7, "y": 1}],[{"_color": "red", "x": 0, "y": 2}, {"_color": "red", "x": 1, "y": 2}, {"_color": "green", "x": 2, "y": 2}, {"_color": "blue", "x": 3, "y": 2}, {"_color": "red", "x": 4, "y": 2}, {"_color": "red", "x": 5, "y": 2}, {"_color": "blue", "x": 6, "y": 2}, {"_color": "red", "x": 7, "y": 2}],[{"_color": "blue", "x": 0, "y": 3}, {"_color": "yellow", "x": 1, "y": 3}, {"_color": "red", "x": 2, "y": 3}, {"_color": "red", "x": 3, "y": 3}, {"_color": "green", "x": 4, "y": 3}, {"_color": "blue", "x": 5, "y": 3}, {"_color": "green", "x": 6, "y": 3}, {"_color": "red", "x": 7, "y": 3}],[{"_color": "red", "x": 0, "y": 4}, {"_color": "green", "x": 1, "y": 4}, {"_color": "red", "x": 2, "y": 4}, {"_color": "red", "x": 3, "y": 4}, {"_color": "red", "x": 4, "y": 4}, {"_color": "red", "x": 5, "y": 4}, {"_color": "red", "x": 6, "y": 4}, {"_color": "red", "x": 7, "y": 4}],[{"_color": "yellow", "x": 0, "y": 5}, {"_color": "red", "x": 1, "y": 5}, {"_color": "red", "x": 2, "y": 5}, {"_color": "yellow", "x": 3, "y": 5}, {"_color": "blue", "x": 4, "y": 5}, {"_color": "red", "x": 5, "y": 5}, {"_color": "yellow", "x": 6, "y": 5}, {"_color": "yellow", "x": 7, "y": 5}],[{"_color": "red", "x": 0, "y": 6}, {"_color": "red", "x": 1, "y": 6}, {"_color": "red", "x": 2, "y": 6}, {"_color": "red", "x": 3, "y": 6}, {"_color": "red", "x": 4, "y": 6}, {"_color": "red", "x": 5, "y": 6}, {"_color": "red", "x": 6, "y": 6}, {"_color": "blue", "x": 7, "y": 6}],[{"_color": "green", "x": 0, "y": 7}, {"_color": "yellow", "x": 1, "y": 7}, {"_color": "blue", "x": 2, "y": 7}, {"_color": "red", "x": 3, "y": 7}, {"_color": "red", "x": 4, "y": 7}, {"_color": "red", "x": 5, "y": 7}, {"_color": "yellow", "x": 6, "y": 7}, {"_color": "yellow", "x": 7, "y": 7}],[{"_color": "green", "x": 0, "y": 8}, {"_color": "red", "x": 1, "y": 8}, {"_color": "red", "x": 2, "y": 8}, {"_color": "red", "x": 3, "y": 8}, {"_color": "green", "x": 4, "y": 8}, {"_color": "yellow", "x": 5, "y": 8}, {"_color": "red", "x": 6, "y": 8}, {"_color": "red", "x": 7, "y": 8}],[{"_color": "green", "x": 0, "y": 9}, {"_color": "blue", "x": 1, "y": 9}, {"_color": "red", "x": 2, "y": 9}, {"_color": "red", "x": 3, "y": 9}, {"_color": "red", "x": 4, "y": 9}, {"_color": "red", "x": 5, "y": 9}, {"_color": "red", "x": 6, "y": 9}, {"_color": "red", "x": 7, "y": 9}]]}';
  String testJson3 = '{"_levelNum":1,"_levelTimeSec":120,"_requiredScore":1000,"_comboHoldTime":8,"_colors":[ "normalBlock" ],"_blocks":[ "red","blue","green","yellow" ],"_startField":[                                    [ { "_color":"blue", "x": 0, "y": 1 },  { "_color":"green", "x": 1, "y": 1 },  { "_color":"red", "x": 2, "y": 1 },  { "_color":"red", "x": 3, "y": 1 },  { "_color":"blue", "x": 4, "y": 1 },  { "_color":"yellow", "x": 5, "y": 1 },  { "_color":"yellow", "x": 6, "y": 1 },  { "_color":"green", "x": 7, "y": 1 }  ],    [ { "_color":"blue", "x": 0, "y": 2 },  { "_color":"blue", "x": 1, "y": 2 },  { "_color":"red", "x": 2, "y": 2 },  { "_color":"red", "x": 3, "y": 2 },  { "_color":"blue", "x": 4, "y": 2 },  { "_color":"yellow", "x": 5, "y": 2 },  { "_color":"blue", "x": 6, "y": 2 },  { "_color":"red", "x": 7, "y": 2 }  ] ,   [ { "_color":"green", "x": 0, "y": 3 },  { "_color":"blue", "x": 1, "y": 3 },  { "_color":"red", "x": 2, "y": 3 },  { "_color":"red", "x": 3, "y": 3 },  { "_color":"red", "x": 4, "y": 3 },  { "_color":"red", "x": 5, "y": 3 },  { "_color":"green", "x": 6, "y": 3 },  { "_color":"green", "x": 7, "y": 3 }  ],    [ { "_color":"blue", "x": 0, "y": 4 },  { "_color":"blue", "x": 1, "y": 4 },  { "_color":"green", "x": 2, "y": 4 },  { "_color":"green", "x": 3, "y": 4 },  { "_color":"green", "x": 4, "y": 4 },  { "_color":"red", "x": 5, "y": 4 },  { "_color":"yellow", "x": 6, "y": 4 },  { "_color":"blue", "x": 7, "y": 4 }  ],    [ { "_color":"yellow", "x": 0, "y": 5 },  { "_color":"blue", "x": 1, "y": 5 },  { "_color":"green", "x": 2, "y": 5 },  { "_color":"green", "x": 3, "y": 5 },  { "_color":"blue", "x": 4, "y": 5 },  { "_color":"blue", "x": 5, "y": 5 },  { "_color":"red", "x": 6, "y": 5 },  { "_color":"yellow", "x": 7, "y": 5 }  ],    [ { "_color":"red", "x": 0, "y": 6 },  { "_color":"yellow", "x": 1, "y": 6 },  { "_color":"green", "x": 2, "y": 6 },  { "_color":"green", "x": 3, "y": 6 },  { "_color":"red", "x": 4, "y": 6 },  { "_color":"green", "x": 5, "y": 6 },  { "_color":"red", "x": 6, "y": 6 },  { "_color":"blue", "x": 7, "y": 6 }  ] ,   [ { "_color":"blue", "x": 0, "y": 7 },  { "_color":"green", "x": 1, "y": 7 },  { "_color":"red", "x": 2, "y": 7 },  { "_color":"yellow", "x": 3, "y": 7 },  { "_color":"yellow", "x": 4, "y": 7 },  { "_color":"yellow", "x": 5, "y": 7 },  { "_color":"blue", "x": 6, "y": 7 },  { "_color":"blue", "x": 7, "y": 7 }  ] ,   [ { "_color":"red", "x": 0, "y": 8 },  { "_color":"blue", "x": 1, "y": 8 },  { "_color":"green", "x": 2, "y": 8 },  { "_color":"yellow", "x": 3, "y": 8 }, { "_color":"blue", "x": 5, "y": 8 },  { "_color":"yellow", "x": 6, "y": 8 },  { "_color":"blue", "x": 7, "y": 8 }  ] ,   [ { "_color":"green", "x": 0, "y": 9 },  { "_color":"yellow", "x": 1, "y": 9 },  { "_color":"red", "x": 2, "y": 9 },  { "_color":"red", "x": 3, "y": 9 }, { "_color":"yellow", "x": 5, "y": 9 },  { "_color":"green", "x": 6, "y": 9 },  { "_color":"blue", "x": 7, "y": 9 }  ] ,   [ { "_color":"blue", "x": 1, "y": 10 },  { "_color":"yellow", "x": 2, "y": 10 },  { "_color":"red", "x": 3, "y": 10 }, { "_color":"yellow", "x": 5, "y": 10 },  { "_color":"green", "x": 6, "y": 10 },  { "_color":"yellow", "x": 7, "y": 10 }  ] ,   [ { "_color":"red", "x": 1, "y": 11 },  { "_color":"blue", "x": 2, "y": 11 },  { "_color":"yellow", "x": 3, "y": 11 }, { "_color":"yellow", "x": 5, "y": 11 },  { "_color":"blue", "x": 6, "y": 11 },  { "_color":"red", "x": 7, "y": 11 }  ] ,   [ { "_color":"blue", "x": 1, "y": 12 },  { "_color":"blue", "x": 2, "y": 12 },  { "_color":"red", "x": 3, "y": 12 },  { "_color":"red", "x": 5, "y": 12 },  { "_color":"green", "x": 6, "y": 12 },  { "_color":"green", "x": 7, "y": 12 }  ]   ]}';//return of the jsons
  String testJson4 = '{"_levelNum":1,"_levelTimeSec":120,"_requiredScore":1000,"_comboHoldTime":8,"_colors":[ "normalBlock" ],"_blocks":[ "red","blue","green","yellow" ],"_startField":[                                     [ { "_color":"red", "x": 0, "y": 1 },  { "_color":"red", "x": 1, "y": 1 },  { "_color":"red", "x": 2, "y": 1 } ],    [ { "_color":"red", "x": 1, "y": 2 } ],    [ { "_color":"red", "x": 1, "y": 3 } ]   ]}';
  String gravityTest = '{"_levelNum":1,"_levelTimeSec":120,"_requiredScore":1000,"_comboHoldTime":8,"_colors":[ "normalBlock" ],"_blocks":[ "red","blue","green","yellow" ],"_startField":[ [ { "_color":"red", "x": 3, "y": 5 }   ]]}';
  String gravityTestFusion = '{"_levelNum":1,"_levelTimeSec":120,"_requiredScore":1000,"_comboHoldTime":8,"_colors":[ "normalBlock" ],"_blocks":[ "red","blue","green","yellow" ],"_startField":[                                     [ { "_color":"red", "x": 2, "y": 8 }, { "_color":"red", "x": 3, "y": 8 }, { "_color":"red", "x": 4, "y": 8 }, { "_color":"red", "x": 5, "y": 8 }, { "_color":"red", "x": 6, "y": 8 }],                                   [ { "_color":"red", "x": 3, "y": 7 }, { "_color":"red", "x": 4, "y": 7 }, { "_color":"red", "x": 5, "y": 7 } ]                                   ]}';
  String firstViewTest = '{"_levelNum":1,"_levelTimeSec":60,"_requiredScore":30,"_comboHoldTime":2,"_blocks":[ "normalBlock" ],"_colors":[ "red","blue","green","yellow","black","purple" ],"_startField":[  [  { "_color":"red", "x": 0, "y": 1 },  { "_color":"red", "x": 1, "y": 1 },  { "_color":"blue", "x": 2, "y": 1 },  { "_color":"yellow", "x": 3, "y": 1 },  { "_color":"red", "x": 4, "y": 1 },  { "_color":"red", "x": 5, "y": 1 },  { "_color":"yellow", "x": 6, "y": 1 },  { "_color":"blue", "x": 7, "y": 1 }  ],    [  { "_color":"blue", "x": 0, "y": 2 },  { "_color":"blue", "x": 1, "y": 2 },  { "_color":"green", "x": 2, "y": 2 },  { "_color":"red", "x": 3, "y": 2 },  { "_color":"blue", "x": 4, "y": 2 },  { "_color":"yellow", "x": 5, "y": 2 },  { "_color":"yellow", "x": 6, "y": 2 },  { "_color":"green", "x": 7, "y": 2 }  ],[  { "_color":"green", "x": 0, "y": 3 },  { "_color":"green", "x": 1, "y": 3 },  { "_color":"yellow", "x": 2, "y": 3 },  { "_color":"green", "x": 3, "y": 3 },  { "_color":"blue", "x": 4, "y": 3 },  { "_color":"yellow", "x": 5, "y": 3 },  { "_color":"blue", "x": 6, "y": 3 },  { "_color":"red", "x": 7, "y": 3 }  ],[  { "_color":"yellow", "x": 0, "y": 4 },  { "_color":"yellow", "x": 1, "y": 4 },  { "_color":"red", "x": 2, "y": 4 },  { "_color":"red", "x": 3, "y": 4 },  { "_color":"red", "x": 4, "y": 4 },  { "_color":"red", "x": 5, "y": 4 },  { "_color":"green", "x": 6, "y": 4 },  { "_color":"green", "x": 7, "y": 4 }  ],[  { "_color":"red", "x": 0, "y": 5 },  { "_color":"red", "x": 1, "y": 5 },  { "_color":"blue", "x": 2, "y": 5 },  { "_color":"green", "x": 3, "y": 5 },  { "_color":"blue", "x": 4, "y": 5 },  { "_color":"red", "x": 5, "y": 5 },  { "_color":"yellow", "x": 6, "y": 5 },  { "_color":"blue", "x": 7, "y": 5 }  ],[  { "_color":"blue", "x": 0, "y": 6 },  { "_color":"blue", "x": 1, "y": 6 },  { "_color":"yellow", "x": 2, "y": 6 },  { "_color":"yellow", "x": 3, "y": 6 },  { "_color":"blue", "x": 4, "y": 6 },  { "_color":"blue", "x": 5, "y": 6 },  { "_color":"red", "x": 6, "y": 6 },  { "_color":"yellow", "x": 7, "y": 6 }  ],[  { "_color":"green", "x": 0, "y": 7 },  { "_color":"green", "x": 1, "y": 7 },  { "_color":"green", "x": 2, "y": 7 },  { "_color":"green", "x": 3, "y": 7 },  { "_color":"blue", "x": 4, "y": 7 },  { "_color":"green", "x": 5, "y": 7 },  { "_color":"red", "x": 6, "y": 7 },  { "_color":"blue", "x": 7, "y": 7 }  ],[  { "_color":"yellow", "x": 0, "y": 8 },  { "_color":"yellow", "x": 1, "y": 8 },  { "_color":"yellow", "x": 2, "y": 8 },  { "_color":"yellow", "x": 3, "y": 8 },  { "_color":"red", "x": 4, "y": 8 },  { "_color":"yellow", "x": 5, "y": 8 },  { "_color":"blue", "x": 6, "y": 8 },  { "_color":"yellow", "x": 7, "y": 8 }  ],[  { "_color":"red", "x": 0, "y": 9 },  { "_color":"red", "x": 1, "y": 9 },  { "_color":"yellow", "x": 2, "y": 9 },  { "_color":"red", "x": 3, "y": 9 },  { "_color":"red", "x": 4, "y": 9 },  { "_color":"blue", "x": 5, "y": 9 },  { "_color":"yellow", "x": 6, "y": 9 },  { "_color":"blue", "x": 7, "y": 9 }  ]      ]}';
  String secondViewTest = '{"_levelNum":1,"_levelTimeSec":70000,"_requiredScore":50,"_comboHoldTime":1,"_colors":[ "red","green","blue","purple","yellow" ],"_blocks":[ "normalBlock" ],"_startField":[  [  { "_color":"red", "x": 0, "y": 0 },  { "_color":"purple", "x": 1, "y": 0 },  { "_color":"purple", "x": 2, "y": 0 },  { "_color":"yellow", "x": 3, "y": 0 },  { "_color":"green", "x": 4, "y": 0 },  { "_color":"red", "x": 5, "y": 0 },  { "_color":"yellow", "x": 6, "y": 0 },  { "_color":"blue", "x": 7, "y": 0 }  ],    [  { "_color":"blue", "x": 0, "y": 1 },  { "_color":"purple", "x": 1, "y": 1 },  { "_color":"red", "x": 2, "y": 1 },  { "_color":"red", "x": 3, "y": 1 },  { "_color":"green", "x": 4, "y": 1 },  { "_color":"yellow", "x": 5, "y": 1 },  { "_color":"yellow", "x": 6, "y": 1 },  { "_color":"blue", "x": 7, "y": 1 }  ],    [  { "_color":"blue", "x": 0, "y": 2 },  { "_color":"green", "x": 1, "y": 2 },  { "_color":"green", "x": 2, "y": 2 },  { "_color":"red", "x": 3, "y": 2 },  { "_color":"blue", "x": 4, "y": 2 },  { "_color":"purple", "x": 5, "y": 2 },  { "_color":"green", "x": 6, "y": 2 },  { "_color":"red", "x": 7, "y": 2 }  ]    ]}';
  Level testLevel;

  /**
   * #####################################################################################
   *
   * Code below
   *
   * #####################################################################################
   */

  /**
   * Constructor
   */

  controller()
  {
    // Detect Device
    devicePlatform = detectDevice();

    // Create View and GameKeyCom
    _gamekey = new GameKeyCommunicator();
    _view = new View(devicePlatform);

    // Load Test Level
    loadLevels();

    print("normalPrint");

    // enable Keyboard Events
    controlEvents();

    // generate Field
    _view.generateField(config.fieldX,config.fieldY + 1);

    // GameKey Connection

    // Load Config and Level Files

    //throw new Exception("not implemented yet");
  }

  /**
   * Start a new Game.
   * Create a new Playfield with the data from the config
   */

  void newGame()
  {
    // create new play field with specific setting
    _currentField = new Playfield(config.modelFieldX,config.modelFieldY,config.cursor01,config.cursor02,testLevel);
    //
    eventHandler(eventType.Loaded);
    // enable Events of the play field

    _currentField.allEvents.listen((e) => eventHandler(e));
    //throw new Exception("not tested yet");
  }

  /**
   * Method to detect the most different platforms, and sort it in two category's (Phone and Computer)
   * return: Platform
   */
  Platformtype detectDevice()
  {
    String device = window.navigator.platform;
    device = device.toLowerCase();
    if(device.contains("arm") || device.contains("iphone") || device.contains("android") || device.contains("aarch64") || device.contains("ipod"))
    {
      return Platformtype.Phone;
    }
    else if(device.contains("win") || device.contains("i686") || device.contains("mac") || device.contains("sunos") || device.contains("x86_64") || device.contains("x11"))
    {
      return Platformtype.Computer;
    }
    else
    {
      return Platformtype.Computer;
    }
  }

  /**
   * TODO: Need to be changed. Load from GameKey Server
   */
  bool loadConfig()
  {
    // Load Config
    //TODO: add String of the JSON
    Map jsonConfig = JSON.decode("String of the JSOn");


    return false;
  }

  /**
   * TODO: Need to be changed. Load from GameKey Server
   */
  bool loadLevels()
  {
    /**
     * jsonLevels = map list<level>
     * Example JSON Levels:
     * {
     *  "_levels": [ [_level], [_level], [_level], ...
     *  ]
     * }
     * Example JSON Level:
     * {
     *  "_levelNum: 1,
     *  "_colors": ["red", ...],
     *  "_blocks": ["normalBlock", ..],
     *  ...
     *  "_startField":[ [{"_color":"red","x":0,"y":0},{"_color":"red","x":1,"y":0},{"_color":"red","x":2,"y":0}],
     *                  [{"_color":"red","x":0,"y":1},{"_color":"red","x":1,"y":1},{"_color":"red","x":2,"y":1}],
     *                  ...
     *  ]
     * }
     */

    // Load Levels
    try
    {
      /*
      // Fetch levels.json
      Map jsonLevels = JSON.decode(testJson);
      // Variables
      List<Level> allLevels = new List<Level>();
      List<String> lvls;
      Map level;
      // add every Level in Levels to List
      lvls = jsonLevels["_levels"];
      // for each Level String convert into Level class
      for(String lvl in lvls)
      {
        level = JSON.decode(lvl);
        allLevels.add( new Level(
            level["_colors"],
            level["_blocks"],
            Level.convertStartfieldMapToStartField(level["_startField"]),
            level["_levelTimeSec"],
            level["_comboHoldTime"],
            level["_requiredScore"],
            level["_levelNum"])
        );
      }
      */

      Map level = JSON.decode(secondViewTest);
      List<List<Map>> mapField = level["_startField"];
      testLevel = new Level(
          level["_colors"],
          level["_blocks"],
          Level.convertStartfieldMapToStartField(mapField),
          level["_levelTimeSec"],
          level["_comboHoldTime"],
          level["_requiredScore"],
          level["_levelNum"]
      );


      // set into Config
      //TODO: Override Config / Insert Level in Config


      return true;
    }
    catch(error)
    {

      return false;
    }
  }

  /**
   * #####################################################################################
   *
   * Events related Methods
   *
   * #####################################################################################
   */

  /**
   * Keyboard Event Methods (One Time Use)
   */

  void controlEvents()
  {
    // handle start button
    _view.StartButton.onClick.listen((_)
    {
      // Start new Game
      newGame();
      //
      _view.update(_currentField);

      //
      _view.StartButton.setAttribute("disabled","disabled");
      _view.tableDiv.setAttribute("style","display: block");
      _view.infoBox.setAttribute("style","display: block");
      _view.mainmenu.setAttribute("style","display: none");
    });

    window.onKeyDown.listen((KeyboardEvent ev)
    {
      _view.printDebugMessage("Key Pushed " + ev.keyCode.toString());
      // Escape from Event if no Game is running
      if(isGameRunning == false) return;

      // Settings of the used Controls
      switch (ev.keyCode)
          {
        case KeyCode.A:
          _currentField.addCommand(new Command(Action.moveLeft));
          break;
        case KeyCode.D:
          _currentField.addCommand(new Command(Action.moveRight));
          break;
        case KeyCode.S:
          _currentField.addCommand(new Command(Action.moveDown));
          break;
        case KeyCode.W:
          _currentField.addCommand(new Command(Action.moveUp));
          break;
        case KeyCode.SPACE:
          _currentField.addCommand(new Command(Action.swap));
          break;
          //for debugging
        case KeyCode.ENTER:
          _currentField.addRow(testLevel.getBlocks(),testLevel.getColors());
          _currentField.timerFieldUp();
          break;
        case KeyCode.P:
          // toggle pause
          isPaused = !isPaused;
          // Stop the Timers if the game is running, or create new Timer to resume the game
          (isPaused) ? timerFieldAction.cancel() : timerFieldAction = new Timer.periodic(timerFieldActionDuration,(_) => _currentField.timerDoNextAction());
          (isPaused) ? timerPlaytime.cancel() : timerFieldAction = new Timer.periodic(timerPlaytimeDuration,(_) => _currentField.timerIncreaseLevelTime());
          (isPaused) ? timerFieldUp.cancel() : timerFieldAction = new Timer.periodic(timerFieldUpDuration,(_) => _currentField.timerFieldUp());
          (isPaused) ? timerGravity.cancel() : timerFieldAction = new Timer.periodic(timerGravityDuration,(_) => _currentField.timerApplyGravity());
          break;
      }
    });

  }

  /**
   * Event handler for the Events from the play field (model)
   * event: eventType entry from Enum located by the play field
   */

  void eventHandler(eventType event)
  {
    //_view.printDebugMessage(event.toString());

    // choose action for each eventType
    switch(event)
        {
      case eventType.GameOver:
      // execute Game Over Method
        gameOver();
        // set Flag game running
        isGameRunning = false;
        break;
      case eventType.Win:
      // execute Win Method
        win();
        // set Flag game running
        //isGameRunning = false;
        break;
      case eventType.Loaded:
      // Create Timers etc.
        timerPlaytime = new Timer.periodic(timerPlaytimeDuration,(_) => _currentField.timerIncreaseLevelTime());
        timerFieldAction = new Timer.periodic(timerFieldActionDuration, (_) => _currentField.timerDoNextAction());
        timerFieldUp = new Timer.periodic(timerFieldUpDuration, (_) => _currentField.timerFieldUp());
        timerGravity = new Timer.periodic(timerGravityDuration, (_) => _currentField.timerApplyGravity());
        timerView = new Timer.periodic(timerViewDuration, (_) => _view.update(_currentField));
        // set Flag game running
        isGameRunning = true;

        break;
    }


  }
  /**
   * Called by Event handler after a Game Over was recognized
   */

  void gameOver()
  {
    print("Game Over #1");
    // Stop Level
    timerPlaytime.cancel();
    timerFieldAction.cancel();
    timerFieldUp.cancel();
    timerGravity.cancel();
    _view.StartButton.text = "Retry !";
    _view.StartButton.attributes.remove("disabled");
    _view.tableDiv.setAttribute("style","display: none");
    _view.mainmenu.setAttribute("style","display: block");
    _view.infoBox.setAttribute("style","display: none");

  }

  /**
   * Called by Event handler after the Level was successful ended
   */
  void win()
  {
    print("Win Level #1");
    // Stop Level
    timerPlaytime.cancel();
    timerFieldAction.cancel();
    timerFieldUp.cancel();
    timerGravity.cancel();
    _view.mainmenu.setAttribute("style","display: block");
    _view.infoBox.setAttribute("style","display: none");
  }
}