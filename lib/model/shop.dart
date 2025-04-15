import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:wayagram/core/data/database.dart';

part 'shop.g.dart';

const shopTable = SqfEntityTable(
  tableName: 'shops',
  useSoftDeleting: false,
  primaryKeyName: 'resourceId',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField('vendorId', DbType.text),
    SqfEntityField('name', DbType.text),
    SqfEntityField('description', DbType.text),
    SqfEntityField('deactivated', DbType.bool),
    SqfEntityField('logo', DbType.text, isNotNull: false),
    SqfEntityField('coverImage', DbType.text, isNotNull: false),
    SqfEntityField('address', DbType.text),
    SqfEntityField('state', DbType.text),
    SqfEntityField('lga', DbType.text),
    SqfEntityField('longitude', DbType.text, isNotNull: false),
    SqfEntityField('latitude', DbType.text, isNotNull: false),
    SqfEntityField('country', DbType.text),
    SqfEntityField('town', DbType.text),
    SqfEntityField('phone', DbType.text),
    SqfEntityField('email', DbType.text),
    SqfEntityField('rating', DbType.real, isNotNull: false),
    SqfEntityField('totalOrders', DbType.integer),
    SqfEntityField('totalProducts', DbType.integer),
    SqfEntityField('socialLinks', DbType.text, isNotNull: false), // Stored as JSON string
    SqfEntityField('businessHours', DbType.text, isNotNull: false), // Stored as JSON string
    SqfEntityField('isDeleted', DbType.bool),
    SqfEntityField('createdAt', DbType.datetime),
    SqfEntityField('updatedAt', DbType.datetime),
  ],
);

@SqfEntityBuilder(shopDbModel)
const shopDbModel = SqfEntityModel(
  databaseName: 'shops.db',
  modelName: "ShopDbModel",
  databaseTables: [shopTable],
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
      DbType.integer,
      isNotNull: false,
      defaultValue: 1,
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
