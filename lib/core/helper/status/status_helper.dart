 class StatusHelper {
  const StatusHelper._(); // private constructor (no instance)

  static String statusText(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';

      case 'in_progress':
        return 'In Progress';

      case 'not_started':
        return 'Start';

      default:
        return 'Start';
    }
  }
}