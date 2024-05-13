import URLCredentialContract from './URLCredentialContract';
import URLProtectionSpaceContract from './URLProtectionSpaceContract';
import { Context } from '@kit.AbilityKit';

export default class CredentialDatabaseHelper {
  private static SQL_CREATE_PROTECTION_SPACE_TABLE: string =
    "CREATE TABLE " + URLProtectionSpaceContract.TABLE_NAME + " (" +
    URLProtectionSpaceContract._ID + " INTEGER PRIMARY KEY," +
    URLProtectionSpaceContract.COLUMN_NAME_HOST + " TEXT NOT NULL," +
    URLProtectionSpaceContract.COLUMN_NAME_PROTOCOL + " TEXT," +
    URLProtectionSpaceContract.COLUMN_NAME_REALM + " TEXT," +
    URLProtectionSpaceContract.COLUMN_NAME_PORT + " INTEGER," +
      "UNIQUE(" + URLProtectionSpaceContract.COLUMN_NAME_HOST + ", " + URLProtectionSpaceContract.COLUMN_NAME_PROTOCOL + ", " +
    URLProtectionSpaceContract.COLUMN_NAME_REALM + ", " + URLProtectionSpaceContract.COLUMN_NAME_PORT +
      ")" +
      ");";

  private static SQL_CREATE_CREDENTIAL_TABLE: string =
    "CREATE TABLE " + URLCredentialContract.TABLE_NAME + " (" +
    URLCredentialContract._ID + " INTEGER PRIMARY KEY," +
    URLCredentialContract.COLUMN_NAME_USERNAME + " TEXT NOT NULL," +
    URLCredentialContract.COLUMN_NAME_PASSWORD + " TEXT NOT NULL," +
    URLCredentialContract.COLUMN_NAME_PROTECTION_SPACE_ID + " INTEGER NOT NULL," +
      "UNIQUE(" + URLCredentialContract.COLUMN_NAME_USERNAME + ", " + URLCredentialContract.COLUMN_NAME_PASSWORD + ", " +
    URLCredentialContract.COLUMN_NAME_PROTECTION_SPACE_ID +
      ")," +
      "FOREIGN KEY (" + URLCredentialContract.COLUMN_NAME_PROTECTION_SPACE_ID + ") REFERENCES " +
    URLProtectionSpaceContract.TABLE_NAME + " (" + URLProtectionSpaceContract._ID + ") ON DELETE CASCADE" +
      ");";

  private static SQL_DELETE_PROTECTION_SPACE_TABLE: string =
    "DROP TABLE IF EXISTS " + URLProtectionSpaceContract.TABLE_NAME;

  private static SQL_DELETE_CREDENTIAL_TABLE: string =
    "DROP TABLE IF EXISTS " + URLCredentialContract.TABLE_NAME;

  constructor(context: Context) {}
}