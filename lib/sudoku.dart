import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class SudokuApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SudokuAppState();
  }
}

class SudokuAppState extends State<SudokuApp> {
  List<List<int>> board;
  List<List<bool>> boardCanChange;
  List<List<List<int>>> pastMoves;
  List<int> counts;

  String dropdownValue;
  SudokuGameStuff game;

  int time;

  int selected;
  bool win;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    time = 0;

    dropdownValue = 'Easy';
    win = true;
    game = new SudokuGameStuff();
//    var s = game.makePuzzle(1);
//    board = s[0];
//    boardCanChange = s[1];
    counts = List<int>.generate(9, (i) => 0);
    board = List<List<int>>.generate(9, (i) =>
    List<int>.generate(9, (j) => 0));
    boardCanChange = List<List<bool>>.generate(9, (i) =>
    List<bool>.generate(9, (j) => false));

    selected = 0;
//    board = List<List<int>>.generate(9, (i) => List<int>.generate(9, (j) => 0));
//    boardCanChange = List<List<bool>>.generate(9, (i) => List<bool>.generate(9, (j) => true));
    pastMoves = new List();
    //boardCanChange[1][1] = false;
    Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        if(!win) time++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    var boardBtns = makeBoardBtns();
    var selectorBtns = makeSelectorBtns();
    return new Scaffold(
      backgroundColor: Color(0xffd0d0e1),
      //appBar: new AppBar(
      //  title: new Text("Sudoku App", textAlign: TextAlign.center,),
      //),
      body: new Container(
        child: new Column(
        children: [
          new Container(
            //height: 30,
            child: new Divider(
              height: 40,
              color: Colors.transparent,
            ),
          ),
          new Row(
            children: <Widget>[
                new Expanded(
                  child: new DropdownButton(
                    value: dropdownValue,
                    onChanged: (String newVal) {
                      setState(() {
                       dropdownValue = newVal;
                      });
                    },
                    items: <DropdownMenuItem<String>>[
                      new DropdownMenuItem<String>(
                        value: 'Easy',
                        child: new Text('Easy'),
                      ),
                      new DropdownMenuItem<String>(
                        value: 'Medium',
                        child: new Text('Medium'),
                      ),
                      new DropdownMenuItem<String>(
                        value: 'Hard',
                        child: new Text('Hard'),
                      )
                    ],
                  ),
                ),
                new Expanded(
                  child: new Text('${time ~/ 60}:${(time % 60).toString().padLeft(2,'0')}',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  )),
                ),
                new Expanded(
                  child: new FlatButton(
                    color: Colors.blue,
                    child: new Text('Make game'),
                    onPressed: () {
                      setState(() {
                        var s = game.makePuzzle(dropdownValue == 'Easy' ? 1 : dropdownValue == 'Medium' ? 2 : 3);
                        board = s[0];
                        boardCanChange = s[1];
                        win = false;
                        time = 0;
                        counts = List<int>.generate(9, (i) => 0);
                        for(int i = 0; i < 9; i++){
                          for(int j = 0; j < 9; j++){
                            if(board[i][j] != 0) counts[board[i][j]-1]++;
                          }
                        }
                      });
                    },
                  ),
                ),
            ],
          ),
          /*new Container(
            child: new Divider(
              height: 30,
              color: Colors.transparent,
            )
          ),*/
        ]..addAll(boardBtns)..addAll([
          new Divider(
            height: 20,
            color: Colors.transparent,  
          )
        ])..addAll(selectorBtns),
      )),
    );
  }
  List<Widget> makeSelectorBtns(){
    return List<Widget>.generate(3, (k) {
     if (k != 1)
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(9, (i) {
          if(i%2 == 0)
            return new GestureDetector(
              onTap: () => toggleSelected((i/2 + 5 * (k == 2 ? k-1 : k)).toInt() + 1),
              child: new ClipOval(
                child: new Container(
                  color: selected == (i/2 + 5 * (k == 2 ? k-1 : k)).toInt() + 1 ? Color(0xff4da9ff) : Color(0xff80c1ff),
                  height: 60,
                  width: 60,
                  child: Center(
                    child: (i/2 + 5 * (k == 2 ? k-1 : k)).toInt() + 1 == 10 ? 
                    new Icon(Icons.undo) :
                    new Column(
                      children: <Widget>[
                        new Expanded(
                          child: Container(
                            //padding: EdgeInsets.symmetric(
                            //  vertical: 10
                            //),
                            height: 35,
                            child: Center(
                              child: new Text(
                                '${(i/2 + 5 * (k == 2 ? k-1 : k)).toInt() + 1}',
                                style: new TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        //new Expanded(
                        Container(
                          color: Colors.transparent,
                          height: 20,
                          //padding: EdgeInsets.symmetric(
                          //  vertical: 
                          //),
                            child: Center(
                              child: new Text(
                                
                                '${9 - counts[(i/2 + 5 * (k == 2 ? k-1 : k)).toInt()]}',
                                style: new TextStyle(
                                 fontSize: 10,
                                 fontWeight: FontWeight.bold 
                                )),
                            ),
                              
                        ),
                        //)
                      ]
                    )
                  ),
                )
              ),
            );
          else
            return new Container(
              width: 10,
            );
        })
      );  
    else
      return new Divider(
        height: 10,
        color: Colors.transparent
      );
    });
  }

  void toggleSelected(int val){
    setState(() {
      if(val == 10 && !win){
        if(pastMoves.length > 0){
          var t = pastMoves.removeLast();
          for(int i = 0; i < 9; i++){
            for(int j = 0; j < 9; j++){
              board[i][j] = t[i][j];
            }
          }
        }
      }
      else if(val == selected) selected = 0;
      else if(val != 10) selected = val; 
    });

  }

  List<Widget> makeBoardBtns() {
    return List<Widget>.generate(13, (i) {
      if (i == 0 || i == 4 || i == 8 || i == 12) {
        return new Container(
          width: double.infinity,
          height: 1.5,
          color: Colors.black,
        );
      } else {
        return new Row(
          children: List<Widget>.generate(13, (j) {
            if (j == 0 || j == 4 || j == 8 || j == 12) {
              return new Container(
                width: 1.5,
                height: 44,
                color: Colors.black,
              );
            } else {
              return makeBtn(i, j);
            }
          }),
        );
      }
    });
  }

  Widget makeBtn(int i, int j) {
    if (i > 7)
      i -= 3;
    else if (i > 3)
      i -= 2;
    else
      i -= 1;

    if (j > 7)
      j -= 3;
    else if (j > 3)
      j -= 2;
    else
      j -= 1;


    return new Expanded(
      child: Padding(
      padding: const EdgeInsets.all(2.0),
        child: new SizedBox(
          height: 40,
          width: 40,
          child: new FlatButton(
            disabledColor: (board[i][j] == selected && !win? Color(0xff5a5a8c) : Color(0xff4da9ff)),
            disabledTextColor: Colors.black,
            color: (board[i][j] == selected && selected != 0 && !win? Color(0xffa2a2c3) : Color(0xff80c1ff)),
            child: new Text((board[i][j] == 0 ? '' : board[i][j].toString()),
            textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            onPressed: (!boardCanChange[i][j] || win) ? null : () {
              updateBtn(i, j);
            },
          ),
        ),
      )
    );
  }
  void updateBtn(int i, int j){
    setState(() {

      //kind of gross but couldnt figure out how to make a deep copy
      List<List<int>> t = List<List<int>>.generate(9, (i) =>
        List<int>.generate(9, (j) => board[i][j]));
      pastMoves.add(t);
      if(pastMoves.length > 15) pastMoves.removeAt(0);
      if(board[i][j] != 0)
        counts[board[i][j] - 1]--;
      board[i][j] = selected;
      if(board[i][j] != 0)
        counts[board[i][j] - 1]++;
      //print('${board[i][j]} : ${counts[board[i][j]-1]}');
      if(game.isFull(board)){
        win = game.checkWin(board);
      }
    });
  }
}


class SudokuGameStuff{

  SudokuGameStuff(){}


  //difficulty 1 = easy, 2 = medium, 3 = hard
  List makePuzzle(int difficulty){

    //print('diff: ${difficulty}');

    List<List<int>> temp = new List<List<int>>.generate(9, (i) =>
      List<int>.generate(9, (j) => 0));
    List<List<bool>> tempBool = new List<List<bool>>.generate(9, (i) =>
      List<bool>.generate(9, (j) => true));

    while(!makeTiles(temp, tempBool, difficulty)); // do this so we dont kill the stack

    return [temp,tempBool]; 
  }

  bool makeTiles(List<List<int>> temp, List<List<bool>> tempBool, int difficulty){
    var r = new Random();
    int numRand = 0;
    if(difficulty == 1) numRand = 35;
    else if(difficulty == 2) numRand = 30;
    else if(difficulty == 3) numRand = 25;
     
    for(int i = 0; i < numRand; i++){
      //print('Making: ${i}');
      while(!fillRandomSpot(r,temp,tempBool)); // dont want to increase the stack
    }

//    printPuzzle(temp); 
    if(solve(0, 0, temp, tempBool)){
     // printPuzzle(temp);
      reset(false, temp, tempBool);
      return true;
    }
    
    reset(true, temp, tempBool);
    return false;
    //makeTiles(temp, tempBool, difficulty);
    
  }

  reset(bool setTiles, List<List<int>> b, List<List<bool>> c){
    for(int i = 0; i < 9; i++){
      for(int j = 0; j < 9; j++){
        if(setTiles){
          b[i][j] = 0;
          c[i][j] = true;
        }else{
          if(c[i][j]) b[i][j] = 0;
        }
      }
    }
  }

 bool fillRandomSpot(Random r, List<List<int>> b, List<List<bool>> c){
    var tRow = r.nextInt(9);
    var tCol = r.nextInt(9);
    var tVal = r.nextInt(9) + 1;

    if (b[tRow][tCol] == 0){
      b[tRow][tCol] = tVal;
      if(isValid(tRow, tCol, b)){
        c[tRow][tCol] = false;
        return true;
      }else{
        b[tRow][tCol] = 0;
      }
    }
    return false;
    //fillRandomSpot(r, b, c);
  }



  bool solve(int row, int col, List<List<int>> b, List<List<bool>> canChange){
    //print('${row}, ${col}');
    for(int i = 1; i <= 9; i++){
        if(col == 9) return true;
        else if(!canChange[row][col]) return solve((row+1) % 9, (row == 8 ? col+1:col),b,canChange);
        else{
          b[row][col] = i;
          if(isValid(row, col, b)){
            var x = solve((row+1) % 9, (row == 8 ? col+1:col), b, canChange);
            if(x) return x;
          }
        }
    }
    b[row][col] = 0;
    return false;
  }
  bool isValid(int row, int col, List<List<int>> b){
    int sqRow = row ~/ 3;
    int sqCol = col ~/ 3;

    for(int i = 0; i < 9; i++){
      if (i != row && b[row][col] == b[i][col]) return false;
      if (i != col && b[row][col] == b[row][i]) return false;

      if (((sqRow * 3) + (i % 3) != row && (sqCol * 3) + (i ~/ 3) != col ) && b[row][col] == b[(sqRow * 3) + (i % 3)][(sqCol * 3) + (i ~/ 3)]) return false;

    }

    return true;

  }
  void printPuzzle(List<List<int>> b){
    for(int i = 0; i < 9; i++){
      for(int j = 0; j < 9; j++){
        print(b[i][j]);
      }
      print('');
    }
  }
  bool isFull(List<List<int>> b){
    for(int i = 0; i < 9; i++){
      for(int j = 0; j < 9; j++){
        if(b[i][j] == 0) return false;
      }
    }
    return true;
  }
  bool checkWin(List<List<int>> b){
    for(int i = 0; i < 9; i++){
      for(int j = 0; j < 9; j++){
        if(!isValid(i,j,b)) return false;
      }
    }
    return true;

  }
}
