import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:wayagram/core/data/database.dart';

part 'message.g.dart';

const messageTable = SqfEntityTable(
  tableName: 'messages',
  useSoftDeleting: false,
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.text,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField('chatId', DbType.text),
    SqfEntityField('senderId', DbType.text),
    SqfEntityField('content', DbType.text, isNotNull: false),
    SqfEntityField('mediaUrl', DbType.text, isNotNull: false),
    SqfEntityField('messageType', DbType.text, isNotNull: true),
    SqfEntityField('edited', DbType.bool),
    SqfEntityField('originalMessageId', DbType.text, isNotNull: false),
    SqfEntityField('forwardedFrom', DbType.text, isNotNull: false),
    SqfEntityField('isReply', DbType.bool),
    SqfEntityField('createdAt', DbType.datetime),
    SqfEntityField('updatedAt', DbType.datetime),
    SqfEntityField('momentId', DbType.text, isNotNull: false),
    SqfEntityField('isDeleted', DbType.bool, isNotNull: false),
    SqfEntityField('isDeletedBySender', DbType.bool, isNotNull: false),
  ],
);

const messageMediaTable = SqfEntityTable(
  tableName: 'messageMedia',
  useSoftDeleting: false,
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.text,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField('messageId', DbType.text),
    SqfEntityField('mediaType', DbType.text),
    SqfEntityField('mediaUrl', DbType.text),
    SqfEntityField('createdAt', DbType.datetime),
    SqfEntityField('updatedAt', DbType.datetime)
  ],
);

const messageReactionTable = SqfEntityTable(
  tableName: 'messageReaction',
  useSoftDeleting: false,
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.text,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField("messageId", DbType.text),
    SqfEntityField("userId", DbType.text),
    SqfEntityField("reaction", DbType.text),
  ],
);

const messageStatusTable = SqfEntityTable(
  tableName: 'messageStatuses',
  useSoftDeleting: false,
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.text,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField("messageId", DbType.text),
    SqfEntityField("userId", DbType.text),
    SqfEntityField("status", DbType.text),
    SqfEntityField("createdAt", DbType.datetime)
  ],
);

const messageChats = SqfEntityTable(
  tableName: 'chatSync',
  useSoftDeleting: false,
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.text,
  objectType: ObjectType.table,
  fields: [],
);

@SqfEntityBuilder(messageDbModel)
const messageDbModel = SqfEntityModel(
  databaseName: 'chat.db',
  modelName: "MessageDbModel",
  databaseTables: [
    messageMediaTable,
    messageReactionTable,
    messageStatusTable,
    messageTable,
    messageChats,
  ],
  defaultColumns: [
    SqfEntityField(
      'synced_at',
      DbType.datetime,
      isNotNull: false,
    ),
    SqfEntityField(
      'sync_status',
      DbType.text,
      isNotNull: true,
      defaultValue: WayagramDatabaseSyncStatus.created,
    ),
  ],
);
