formatNumber(int num, int place) {
  final numArray = List.filled(place, '0');

  List number = num.toString().split("");

  int indexToStart = numArray.length - number.length;

  int numberIndex = 0;
  for (var i = indexToStart; i <= numArray.length - 1; i++) {
    numArray[i] = number[numberIndex];
    numberIndex++;
  }

  return numArray.join();
}

arabicNumberConvert(int num) {
  Map<String, String> numberDict = {
    "0": "٠",
    "1": "١",
    "2": "٢",
    "3": "٣",
    "4": "٤",
    "5": "٥",
    "6": "٦",
    "7": "٧",
    "8": "٨",
    "9": "٩",
  };
  try {
    if (num <= 9) {
      return numberDict[num.toString()];
    }
    List arrayNum = num.toString().split("");
    for (var i = 0; i < arrayNum.length; i++) {
      arrayNum[i] = numberDict[arrayNum[i]];
    }
    return arrayNum.join();
  } catch (e) {
    return ".";
  }
}
