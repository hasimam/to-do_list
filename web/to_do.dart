import 'dart:html';
import 'time_control.dart';

class ToDoTask {
  String text;
  DateTime creationDate;
  bool state; // true for pending, false for done
  int id; // a Timestamp of creation time

  ToDoTask(text, id) {
    this.text = text;
    this.creationDate = DateTime.now();
    this.state = true;
    this.id = id;
  }

  void changeState() {
    // change the object state property and the task div appearance in accordance
    this.state = !this.state;
    String stateText = this.state ? 'pending' : 'done';
    DivElement div = querySelector('.task[data-task-id="${this.id}"]');
    div.querySelector('.badge').text = stateText;
    div.querySelector('.badge').classes = ['badge', 'badge-$stateText'];
  }

  getElement(Function movEv, Function delEv) {

    // create the task and its components
    var newToDoElement = DivElement();
    SpanElement closeSpan = SpanElement();
    closeSpan.text = 'x';
    closeSpan.classes = ['close_task'];
    closeSpan.onClick.listen(delEv);
    newToDoElement.append(closeSpan);
    var textDiv = DivElement();
    textDiv.classes = ['text-div', 'wrap'];
    textDiv.text = this.text;
    newToDoElement.append(textDiv);
    newToDoElement.classes = ['list-group-item', 'task'];
    var spanElement = SpanElement();
    spanElement.classes = ['badge', 'badge-pending'];
    spanElement.text = 'pending';
    newToDoElement.append(spanElement);
    var taskDateTimeDiv = DivElement();
    taskDateTimeDiv.classes = ['text-muted', 'font-italic', 'date-time-div'];
    taskDateTimeDiv.text = '${getTime(this.creationDate)}';
    newToDoElement.append(taskDateTimeDiv);

    newToDoElement.dataset['taskId'] = this.id.toString();

    // bind the action that controls task's state (pending, Done) to click event
    newToDoElement.onClick.listen(movEv);

    return newToDoElement;
  }
}