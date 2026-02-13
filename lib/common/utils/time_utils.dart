String getRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d';
  } else if (difference.inDays < 30) {
    return '${(difference.inDays / 7).floor()}w';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).floor()}mo';
  } else {
    return '${(difference.inDays / 365).floor()}y';
  }
}
