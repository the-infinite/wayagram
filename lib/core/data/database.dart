// import 'package:sqfentity_gen/sqfentity_gen.dart';

/// An enum that contains all possible synchronization states of any record
/// inside of an on-device database. Useful, yes. Yes it is. This way, we can
/// effectively give the user the look and feel of "instant" responsiveness.
enum WayagramDatabaseSyncStatus {
  /// This has been created on-device but does not yet have any mirror in the
  /// server.
  created,

  /// This has been created on-device and mirrored in the server. So, both
  /// parties should have the "most" up-to-date version of the record.
  synced,

  /// This has been deleted from this device by request of the user but has not
  /// yet been deleted at the server-side.
  deleted,
}

/// A class that extends [SqfEntityTable] to define the database table structure
/// for WayaGram.
///
/// This class is responsible for managing the database schema and operations
/// for the WayaGram application using the SqfEntity ORM framework.
///
/// It adds the default behavior and fields to each table so that all
/// implementations are not expected to generate the data manually.
// class WayagramDatabaseTable extends SqfEntityTable {
//   const WayagramDatabaseTable({
//     super.primaryKeyName = 'resourceId',
//     super.primaryKeyType = PrimaryKeyType.integer_auto_incremental,
//     super.objectType = ObjectType.table,
//     super.tableName,
//     super.useSoftDeleting,
//     super.defaultJsonUrl,
//     super.modelName,
//     super.customCode,
//     super.relationType,
//     super.formListTitleField,
//     super.formListSubTitleField,
//     super.sqlStatement,
//     super.abstractModelName,
//     required super.fields,
//   });
// }
