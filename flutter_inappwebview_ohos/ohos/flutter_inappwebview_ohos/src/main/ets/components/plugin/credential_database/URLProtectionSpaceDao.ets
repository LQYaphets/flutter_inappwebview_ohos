import URLProtectionSpace from '../types/URLProtectionSpace';
import CredentialDatabaseHelper from './CredentialDatabaseHelper';
import URLProtectionSpaceContract from './URLProtectionSpaceContract';

export default class URLProtectionSpaceDao {
  credentialDatabaseHelper: CredentialDatabaseHelper
  projection: Array<string> = [
    URLProtectionSpaceContract._ID,
    URLProtectionSpaceContract.COLUMN_NAME_HOST,
    URLProtectionSpaceContract.COLUMN_NAME_PROTOCOL,
    URLProtectionSpaceContract.COLUMN_NAME_REALM,
    URLProtectionSpaceContract.COLUMN_NAME_PORT
  ];

  constructor(credentialDatabaseHelper: CredentialDatabaseHelper) {
    this.credentialDatabaseHelper = credentialDatabaseHelper
  }

  public getAll(): Array<URLProtectionSpace> {
    let URLProtectionSpaces: Array<URLProtectionSpace> = new Array<URLProtectionSpace>();

    //TODO
    // SQLiteDatabase readableDatabase = credentialDatabaseHelper.getReadableDatabase();
    // Cursor cursor = readableDatabase.query(
    //   URLProtectionSpaceContract.FeedEntry.TABLE_NAME,
    //   projection,
    //   null,
    //   null,
    //   null,
    //   null,
    //   null
    // );
    // while (cursor.moveToNext()) {
    //   Long rowId = cursor.getLong(cursor.getColumnIndexOrThrow(URLProtectionSpaceContract.FeedEntry._ID));
    //   String rowHost = cursor.getString(cursor.getColumnIndexOrThrow(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_HOST));
    //   String rowProtocol = cursor.getString(cursor.getColumnIndexOrThrow(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_PROTOCOL));
    //   String rowRealm = cursor.getString(cursor.getColumnIndexOrThrow(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_REALM));
    //   Integer rowPort = cursor.getInt(cursor.getColumnIndexOrThrow(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_PORT));
    //   URLProtectionSpaces.add(new URLProtectionSpace(rowId, rowHost, rowProtocol, rowRealm, rowPort));
    // }
    // cursor.close();

    return URLProtectionSpaces;
  }

  public find(host: string, protocol: string, realm: string, port: number): URLProtectionSpace | null {
    //TODO
    // SQLiteDatabase readableDatabase = credentialDatabaseHelper.getReadableDatabase();
    //
    // String selection = URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_HOST + " = ? AND " + URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_PROTOCOL + " = ? AND " +
    // URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_REALM + " = ? AND " + URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_PORT + " = ?";
    // String[] selectionArgs = {host, protocol, realm, port.toString()};
    //
    // Cursor cursor = readableDatabase.query(
    //   URLProtectionSpaceContract.FeedEntry.TABLE_NAME,
    //   projection,
    //   selection,
    //   selectionArgs,
    //   null,
    //   null,
    //   null
    // );
    //
    // URLProtectionSpace URLProtectionSpace = null;
    // if (cursor.moveToNext()) {
    //   Long rowId = cursor.getLong(cursor.getColumnIndexOrThrow(URLProtectionSpaceContract.FeedEntry._ID));
    //   String rowHost = cursor.getString(cursor.getColumnIndexOrThrow(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_HOST));
    //   String rowProtocol = cursor.getString(cursor.getColumnIndexOrThrow(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_PROTOCOL));
    //   String rowRealm = cursor.getString(cursor.getColumnIndexOrThrow(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_REALM));
    //   Integer rowPort = cursor.getInt(cursor.getColumnIndexOrThrow(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_PORT));
    //   URLProtectionSpace = new URLProtectionSpace(rowId, rowHost, rowProtocol, rowRealm, rowPort);
    // }
    // cursor.close();
    //
    // return URLProtectionSpace;
    return null;
  }

  public insert(URLProtectionSpace: URLProtectionSpace): number {
    //TODO
    // ContentValues protectionSpaceValues = new ContentValues();
    // protectionSpaceValues.put(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_HOST, URLProtectionSpace.getHost());
    // protectionSpaceValues.put(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_PROTOCOL, URLProtectionSpace.getProtocol());
    // protectionSpaceValues.put(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_REALM, URLProtectionSpace.getRealm());
    // protectionSpaceValues.put(URLProtectionSpaceContract.FeedEntry.COLUMN_NAME_PORT, URLProtectionSpace.getPort());
    //
    // return credentialDatabaseHelper.getWritableDatabase().insert(URLProtectionSpaceContract.FeedEntry.TABLE_NAME, null, protectionSpaceValues);
    return 0;
  }

  public delete(URLProtectionSpace: URLProtectionSpace): number {
    //TODO
    // String whereClause = URLProtectionSpaceContract.FeedEntry._ID + " = ?";
    // String[] whereArgs = {URLProtectionSpace.getId().toString()};
    //
    // return credentialDatabaseHelper.getWritableDatabase().delete(URLProtectionSpaceContract.FeedEntry.TABLE_NAME, whereClause, whereArgs);
    return 0;
  }
}