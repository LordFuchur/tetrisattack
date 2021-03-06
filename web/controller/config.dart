import "dart:math";

class config
{
  static int dimBlockX = 4;
  static int dimBlockY = 4;
  static int fieldX = 8;
  static int fieldY = 13;
  static int modelFieldX = 8;
  static int modelFieldY = 13;
  static List<String> colors = ['red','green','blue','yellow'];
  static Point cursor01 = new Point(0,13);
  static Point cursor02 = new Point(1,13);

/* Field
  upwards
  [0][0] = column[0]row[0]
  [0][1] = column[0]row[1]
 */

  // Block size getter
  static int getBlockSizeX()
  {
    return dimBlockX;
  }

  static int getBlockSizeY()
  {
    return dimBlockY;
  }

  // Field size getter
  static int getFieldSizeX()
  {
    return fieldX;
  }

  static int getFieldSizeY()
  {
    return fieldY;
  }

  // Color list getter
  static List<String> getColorList()
  {
    return colors;
  }

}