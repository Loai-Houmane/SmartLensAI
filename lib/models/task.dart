class Task {
  final int id;
  final String content;
  final String message;

  Task({
    this.id,
    this.content,
    this.message,
  });
  factory Task.fromMap(Map taskMap) {
    return Task(
      id: taskMap['id'],
      message: taskMap['message'],
      content: taskMap['content'],
    );

    // void toggle() {
    //   done = !done;
    // }
  }
}
