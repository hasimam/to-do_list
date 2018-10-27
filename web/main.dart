import 'dart:html';
import 'package:bootjack/bootjack.dart';

InputElement toDoInput;
UListElement toDoPendingList;
UListElement toDoDoneList;

void main() {
  toDoInput = querySelector('#newTaskInput');
  toDoPendingList = querySelector('#pendingList');
  toDoDoneList = querySelector('#doneList');
  toDoInput.onChange.listen(addNewItem);
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

  // bind the action that controls task's state (pending, Done) to click event
  newToDoElement.onClick.listen(moveElement);

  toDoInput.value = '';
  toDoPendingList.children[0].style.display = 'none';

  toDoPendingList.children.add(newToDoElement);
}

void spanClick(Event e) {
  e.stopPropagation();
  e.preventDefault();
}

void moveElement(Event e) {
  e.preventDefault();
  var newToDoElement = new DivElement();

  newToDoElement = e.target;
  if (newToDoElement.classes.contains('text-div'))
    newToDoElement = newToDoElement.parent;

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
    toDoDoneList.children.add(newToDoElement);
  } else {
    if (toDoPendingList.children.length == 1)
      toDoPendingList.children[0].style.display = 'none';

    newToDoElement.querySelector('span').classes = ['badge-pending', 'badge'];
    newToDoElement.querySelector('span').text = 'Pending';
    toDoPendingList.children.add(newToDoElement);
  }
}