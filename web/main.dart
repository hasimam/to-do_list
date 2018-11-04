import 'dart:html';
import 'dart:async';
import 'to_do.dart';
import 'time_control.dart';
import 'dart:core';

Map<int, ToDoTask> taskList;

TextAreaElement toDoInput;
UListElement toDoPendingList;
UListElement toDoDoneList;
SpanElement timeToShow;
ButtonElement addTaskBtn;
SpanElement pendingCount;
SpanElement doneCount;

Timer _timer;



void main() {
  // initializing variables
  taskList = new Map();
  toDoInput = querySelector('#newTaskInput');
  toDoPendingList = querySelector('#pendingList');
  toDoDoneList = querySelector('#doneList');
  timeToShow = querySelector('#timeSpan');
  addTaskBtn = querySelector('#addBtn');

  pendingCount = querySelector('#pendingCount');
  doneCount = querySelector('#doneCount');

  addTaskBtn.onClick.listen(addNewItem);

  // setup time and date mechanism
  var oneSecond = new Duration(seconds: 1);
  _timer = new Timer.periodic(oneSecond, updateTime);
  updateTime(_timer);

  // update counters at the beginning
  calcCount();
}

void updateTime(Timer t) {
  timeToShow.text = getTime();
}

Future addNewItem(Event e) async {
  // in order to use await and Future event we need to make this async function

  // validate text value, empty text get alarm
  if (toDoInput.value == '') {
    toDoInput.style.borderColor = 'red';
    await Future.delayed(const Duration(milliseconds: 500), () {
      toDoInput.style.borderColor = '#ccc';
      toDoInput.focus();
    });
    return;
  }

  // create new task object and add it to tasks list

  // use the epoch time to make id to the task elements, (other solution would be id's from database)
  int addTime = getTimeInMs();
  ToDoTask newTask = ToDoTask(toDoInput.value, addTime);
  taskList[addTime] = newTask;
  DivElement newToDoElement = newTask.getElement(moveElement, deleteTsk);

  // reset after adding
  toDoInput.value = '';
  toDoPendingList.children[0].style.display = 'none';

  // adding the task with the animation
  toDoPendingList.children.insert(1, newToDoElement);
  newToDoElement.animate([{"opacity": 0}, {"opacity": 100}], 500).play();

  // update counters after adding
  calcCount();
}

void calcCount() {
  // prepare the unit
  String pendingTaskCount = toDoPendingList.children.length-1 <= 1 ? 'Task' : 'Tasks';
  String doneTaskCount = toDoDoneList.children.length-1 <= 1 ? 'Task' : 'Tasks';

  // first element is the Li element (with Empty list label)
  pendingCount.text = '( ${(toDoPendingList.children.length-1).toString()} $pendingTaskCount )';
  doneCount.text = '( ${(toDoDoneList.children.length-1).toString()} $doneTaskCount )';
}

void deleteTsk(Event e) {
  e.stopPropagation();

  Element selectedElement = e.target;
  int selectedId = int.parse(selectedElement.parent.dataset['task-id']);
  selectedElement.parent.animate([{"opacity": 100}, {"opacity": 0}], 300)..
  onFinish.listen((Event e){

    if (selectedElement.parent.parent == toDoPendingList) {
      // hide (list empty) note from the list after entering it
      if (toDoPendingList.children.length == 2)
        toDoPendingList.children[0].style.display = '';
    } else {
      if (toDoDoneList.children.length == 2)
        toDoDoneList.children[0].style.display = '';
    }

    selectedElement.parent.remove();
    taskList.remove(selectedId);
    calcCount();

  })..play();
}

void moveElement(Event e) {
  Element clickedToDoElement = e.target;
  if (clickedToDoElement.classes.contains('text-div') ||
      clickedToDoElement.classes.contains('date-time-div') ||
      clickedToDoElement.classes.contains('badge') )
    clickedToDoElement = clickedToDoElement.parent;

  int selectedId = int.parse(clickedToDoElement.dataset['task-id']);

  // make disappearing animation before moving the task
  clickedToDoElement.animate([{"opacity": 100}, {"opacity": 0}], 300)
    ..onFinish.listen((Event e) {

      taskList[selectedId].changeState();

      // show (list empty) note to the empty list after leaving it
      if (clickedToDoElement.parent.children.length == 2)
        clickedToDoElement.parent.children[0].style.display = '';

      if (clickedToDoElement.parent == toDoPendingList) {
        // hide (list empty) note from the list after entering it
        if (toDoDoneList.children.length == 1)
          toDoDoneList.children[0].style.display = 'none';

        toDoDoneList.children.insert(1, clickedToDoElement);
      } else {
        if (toDoPendingList.children.length == 1)
          toDoPendingList.children[0].style.display = 'none';

        toDoPendingList.children.insert(1, clickedToDoElement);
      }

      // make appearing animation after moving the task
      clickedToDoElement.animate([{"opacity": 0}, {"opacity": 100}], 300)
        ..onFinish.listen((Event e){
          calcCount();
        })..play();

  })..play();
}