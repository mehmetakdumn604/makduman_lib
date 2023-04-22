extension Datetime on DateTime {
  String toDate() {
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(this);

    if (difference.inDays >= 7) {
      return '${(difference.inDays)} day${(difference.inDays) == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}
