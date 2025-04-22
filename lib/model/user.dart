import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:wayagram/core/data/database.dart';

part 'user.g.dart';

const userDetailsTable = SqfEntityTable(
  tableName: 'userDetails',
  useSoftDeleting: false,
  primaryKeyName: 'resourceId',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField('phoneNumber', DbType.text, isNotNull: false),
    SqfEntityField('email', DbType.text, isNotNull: false),
    SqfEntityField('firstName', DbType.text),
    SqfEntityField('lastName', DbType.text),
    SqfEntityField('gender', DbType.text, isNotNull: false),
    SqfEntityField('address', DbType.text, isNotNull: false),
    SqfEntityField('passwordHash', DbType.text, isNotNull: false),
    SqfEntityField('city', DbType.text, isNotNull: false),
    SqfEntityField('lga', DbType.text, isNotNull: false),
    SqfEntityField('state', DbType.text, isNotNull: false),
    SqfEntityField('country', DbType.text, isNotNull: false),
    SqfEntityField('countryCode', DbType.text, isNotNull: false),
    SqfEntityField('postalCode', DbType.text, isNotNull: false),
    SqfEntityField('middleName', DbType.text, isNotNull: false),
    SqfEntityField('dateOfBirth', DbType.datetime, isNotNull: false),
    SqfEntityField('twoFactorEnabled', DbType.bool, isNotNull: false),
    SqfEntityField('profilePicture', DbType.text, isNotNull: false),
    SqfEntityField('fcmToken', DbType.text, isNotNull: false),
    SqfEntityField('emailVerified', DbType.bool, isNotNull: false),
    SqfEntityField('phoneVerified', DbType.bool, isNotNull: false),
    SqfEntityField('accountStatus', DbType.text, isNotNull: false),
    SqfEntityField('tcAgreement', DbType.bool, isNotNull: false),
    SqfEntityField('policyAgreement', DbType.bool, isNotNull: false),
    SqfEntityField('emailVerifiedDate', DbType.datetime, isNotNull: false),
    SqfEntityField('deletedAt', DbType.text, isNotNull: false),
    SqfEntityField('roleId', DbType.text, isNotNull: false),
    SqfEntityField('accountTypeId', DbType.text, isNotNull: false),
    SqfEntityField('createdAt', DbType.datetime, isNotNull: false),
    SqfEntityField('updatedAt', DbType.datetime, isNotNull: false),
    SqfEntityField('role', DbType.text, isNotNull: false),
    SqfEntityField('accountType', DbType.text, isNotNull: false),
  ],
);

const socialProfileTable = SqfEntityTable(
  tableName: 'userProfile',
  useSoftDeleting: false,
  primaryKeyName: 'resourceId',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField('userId', DbType.text, isNotNull: true),
    SqfEntityField('displayName', DbType.text, isNotNull: false),
    SqfEntityField('username', DbType.text, isNotNull: false),
    SqfEntityField('avatar', DbType.text, isNotNull: false),
    SqfEntityField('coverImage', DbType.text, isNotNull: false),
    SqfEntityField('bio', DbType.text, isNotNull: false),
    SqfEntityField('isPublic', DbType.bool, isNotNull: true),
    SqfEntityField('isBanned', DbType.bool, isNotNull: false),
    SqfEntityField('deletedAt', DbType.datetime, isNotNull: false),
    SqfEntityField('simulatedUser', DbType.bool, isNotNull: false),
    SqfEntityField('isMuted', DbType.bool, isNotNull: false),
    SqfEntityField('referenceCode', DbType.text, isNotNull: false),
    SqfEntityField('referredBy', DbType.text, isNotNull: false),
    SqfEntityField('streamKey', DbType.text, isNotNull: false),
    SqfEntityField('hasFollowedAll', DbType.bool, isNotNull: false),
  ],
);

@SqfEntityBuilder(userDbModel)
const userDbModel = SqfEntityModel(
  databaseName: 'users.db',
  modelName: "UserDbModel",
  databaseTables: [userDetailsTable, socialProfileTable],
  defaultColumns: [
    SqfEntityField(
      'id',
      DbType.text,
      isIndex: true,
      isUnique: true,
      isNotNull: true,
    ),
    SqfEntityField(
      '_v',
      DbType.text,
      isNotNull: false,
      defaultValue: "1",
    ),
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
