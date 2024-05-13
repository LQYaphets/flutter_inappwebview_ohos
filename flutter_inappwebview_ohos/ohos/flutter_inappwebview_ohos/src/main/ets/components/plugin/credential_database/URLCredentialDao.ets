import URLCredential from '../types/URLCredential'
import CredentialDatabaseHelper from './CredentialDatabaseHelper'
import URLCredentialContract from './URLCredentialContract'
import List from '@ohos.util.List'

export default class URLCredentialDao {
  credentialDatabaseHelper: CredentialDatabaseHelper
  projection: string[] = [
    URLCredentialContract._ID,
    URLCredentialContract.COLUMN_NAME_USERNAME,
    URLCredentialContract.COLUMN_NAME_PASSWORD,
    URLCredentialContract.COLUMN_NAME_PROTECTION_SPACE_ID,
  ]

  constructor(credentialDatabaseHelper: CredentialDatabaseHelper) {
    this.credentialDatabaseHelper = credentialDatabaseHelper
  }

  public getAllByProtectionSpaceId(protectionSpaceId: number): List<URLCredential> {
    let selection: string = URLCredentialContract.COLUMN_NAME_PROTECTION_SPACE_ID + " = ?";
    let selectionArgs: string[] = [protectionSpaceId.toString()]
    let URLCredentials: List<URLCredential> = new List<URLCredential>();

    //TODO
    // Cursor cursor = credentialDatabaseHelper.getReadableDatabase().query(
    //   URLCredentialContract.FeedEntry.TABLE_NAME,
    //   projection,
    //   selection,
    //   selectionArgs,
    //   null,
    //   null,
    //   null
    // );
    // while (cursor.moveToNext()) {
    //   Long id = cursor.getLong(cursor.getColumnIndexOrThrow(URLCredentialContract.FeedEntry._ID));
    //   String username = cursor.getString(cursor.getColumnIndexOrThrow(URLCredentialContract.FeedEntry.COLUMN_NAME_USERNAME));
    //   String password = cursor.getString(cursor.getColumnIndexOrThrow(URLCredentialContract.FeedEntry.COLUMN_NAME_PASSWORD));
    //   URLCredentials.add(new URLCredential(id, username, password, protectionSpaceId));
    // }
    // cursor.close();
    return URLCredentials
  }

  public find(username: string, password: string, protectionSpaceId: number): URLCredential | null {
    //TODO
    // String selection = URLCredentialContract.FeedEntry.COLUMN_NAME_USERNAME + " = ? AND " +
    // URLCredentialContract.FeedEntry.COLUMN_NAME_PASSWORD + " = ? AND " +
    // URLCredentialContract.FeedEntry.COLUMN_NAME_PROTECTION_SPACE_ID + " = ?";
    // String[] selectionArgs = {username, password, protectionSpaceId.toString()};
    //
    // Cursor cursor = credentialDatabaseHelper.getReadableDatabase().query(
    //   URLCredentialContract.FeedEntry.TABLE_NAME,
    //   projection,
    //   selection,
    //   selectionArgs,
    //   null,
    //   null,
    //   null
    // );

    let URLCredential: URLCredential | null = null;
    //   if (cursor.moveToNext()) {
    //   Long rowId = cursor.getLong(cursor.getColumnIndexOrThrow(URLCredentialContract.FeedEntry._ID));
    //   String rowUsername = cursor.getString(cursor.getColumnIndexOrThrow(URLCredentialContract.FeedEntry.COLUMN_NAME_USERNAME));
    //   String rowPassword = cursor.getString(cursor.getColumnIndexOrThrow(URLCredentialContract.FeedEntry.COLUMN_NAME_PASSWORD));
    //   URLCredential = new URLCredential(rowId, rowUsername, rowPassword, protectionSpaceId);
    // }
    // cursor.close();

    return URLCredential;
  }

  public insert(urlCredential: URLCredential): number {
    //TODO
    // let credentialValues: ContentValues = new ContentValues();
    //   credentialValues.put(URLCredentialContract.FeedEntry.COLUMN_NAME_USERNAME, urlCredential.getUsername());
    //   credentialValues.put(URLCredentialContract.FeedEntry.COLUMN_NAME_PASSWORD, urlCredential.getPassword());
    //   credentialValues.put(URLCredentialContract.FeedEntry.COLUMN_NAME_PROTECTION_SPACE_ID, urlCredential.getProtectionSpaceId());
    //
    //   return credentialDatabaseHelper.getWritableDatabase().insert(URLCredentialContract.FeedEntry.TABLE_NAME, null, credentialValues);
    return 0;
  }


  public update( urlCredential: URLCredential): number {
    //TODO
    // ContentValues credentialValues = new ContentValues();
    // credentialValues.put(URLCredentialContract.FeedEntry.COLUMN_NAME_USERNAME, urlCredential.getUsername());
    // credentialValues.put(URLCredentialContract.FeedEntry.COLUMN_NAME_PASSWORD, urlCredential.getPassword());
    //
    // String whereClause = URLCredentialContract.FeedEntry.COLUMN_NAME_PROTECTION_SPACE_ID + " = ?";
    // String[] whereArgs = {urlCredential.getProtectionSpaceId().toString()};
    //
    // return credentialDatabaseHelper.getWritableDatabase().update(URLCredentialContract.FeedEntry.TABLE_NAME, credentialValues, whereClause, whereArgs);
    return 0;
  }

  public  delete( urlCredential: URLCredential): number {
    let whereClause: string = URLCredentialContract._ID + " = ?";
    let whereArgs = [urlCredential.getId()?.toString()];
    // return this.credentialDatabaseHelper.getWritableDatabase().delete(URLCredentialContract.TABLE_NAME, whereClause, whereArgs);
    return 0;
  }
}