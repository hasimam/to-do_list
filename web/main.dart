import 'dart:html';
import 'dart:async';

TextAreaElement toDoInput;
UListElement toDoPendingList;
UListElement toDoDoneList;
SpanElement dateToShow;
SpanElement timeToShow;

SpanElement pendingCount;
SpanElement doneCount;

Timer _timer;
DateTime time = new DateTime.now();
String dateStr = '';

List _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
List _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
'Oct', 'Nov', 'Dec'];
int hours;
int minutes;
String seconds;

void main() {
  toDoInput = querySelector('#newTaskInput');
  toDoPendingList = querySelector('#pendingList');
  toDoDoneList = querySelector('#doneList');
  dateToShow = querySelector('#dateSpan');
  timeToShow = querySelector('#timeSpan');

  pendingCount = querySelector('#pendingCount');
  doneCount = querySelector('#doneCount');

  toDoInput.onChange.listen(addNewItem);

  var oneSecond = new Duration(seconds: 1);
  _timer = new Timer.periodic(oneSecond, updateTime);
  updateTime(_timer);

  pendingCount.text = '${(toDoPendingList.children.length-1).toString()} tasks';
  doneCount.text = '${(toDoDoneList.children.length-1).toString()} tasks';
}

void updateTime(Timer t) {
  timeToShow.text = getTime();
  dateToShow.text = getDate();
}

String getDate() {
  time = new DateTime.now();
  dateStr = [_days[time.weekday - 1], _months[time.month - 1], time.day].join(' ');
  return dateStr;
}

String getTime() {
  time = new DateTime.now();
  hours = time.hour;
  minutes = time.minute;
  seconds = time.second.toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

void addNewItem(Event e) {
  // create the task and its components
  var newToDoElement = new DivElement();
  var textDiv = new DivElement();
  textDiv.classes = ['text-div', 'wrap'];
  textDiv.text = toDoInput.value;
  newToDoElement.append(textDiv);
  newToDoElement.classes = ['list-group-item', 'task'];
  var spanElement = new SpanElement();
  spanElement.classes = ['badge', 'badge-pending'];
  spanElement.text = 'Pending';
  spanElement.onClick.listen(spanClick);
  newToDoElement.append(spanElement);
  var taskDateTimeDiv = new DivElement();
  taskDateTimeDiv.classes = ['text-muted', 'font-italic', 'date-time-div'];
  taskDateTimeDiv.style.float = 'right';
  taskDateTimeDiv.style.marginTop = '10px';
  taskDateTimeDiv.text = 'Date: ${getDate()},   Time: ${getTime()}';
  newToDoElement.append(taskDateTimeDiv);

  // bind the action that controls task's state (pending, Done) to click event
  newToDoElement.onClick.listen(moveElement);

  // reset after adding
  toDoInput.value = '';
  toDoPendingList.children[0].style.display = 'none';

  // adding the task with the animation
  toDoPendingList.children.insert(1, newToDoElement);
  var animation = newToDoElement.animate([{"opacity": 0}, {"opacity": 100}], 300);
  animation.play();

  // update counters after adding
  calcCount();
}

void calcCount() {
  pendingCount.text = '${(toDoPendingList.children.length-1).toString()} tasks';
  doneCount.text = '${(toDoDoneList.children.length-1).toString()} tasks';
}

void spanClick(Event e) {
  e.stopPropagation();
  e.preventDefault();
}

void moveElement(Event e) {
  e.preventDefault();
  var newToDoElement = new DivElement();

  newToDoElement = e.target;
  if (newToDoElement.classes.contains('text-div') ||
      newToDoElement.classes.contains('date-time-div'))
    newToDoElement = newToDoElement.parent;

  var animation = newToDoElement.animate([{"opacity": 100}, {"opacity": 0}], 300);
  animation.onFinish.listen((Event e) {
    // show (list empty) note to the empty list after leaving it
    if (newToDoElement.parent.children.length == 2)
      newToDoElement.parent.children[0].style.display = '';

    if (newToDoElement.parent == toDoPendingList) {
      // hide (list empty) note from the list after entering it
      if (toDoDoneList.children.length == 1)
        toDoDoneList.children[0].style.display = 'none';

      // some changes to the task after changing state between pending and done
      newToDoElement.querySelector('span').classes = ['badge-done', 'badge'];
      newToDoElement.querySelector('span').text = 'Done';
      toDoDoneList.children.insert(1, newToDoElement);
    } else {
      if (toDoPendingList.children.length == 1)
        toDoPendingList.children[0].style.display = 'none';

      newToDoElement.querySelector('span').classes = ['badge-pending', 'badge'];
      newToDoElement.querySelector('span').text = 'Pending';
      toDoPendingList.children.insert(1, newToDoElement);
    }
    var animation = newToDoElement.animate([{"opacity": 0}, {"opacity": 100}], 300);
    animation.onFinish.listen((Event e){
      calcCount();
    });
    animation.play();
  });
  animation.play();
}