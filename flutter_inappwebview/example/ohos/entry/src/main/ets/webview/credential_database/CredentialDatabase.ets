import CredentialDatabaseHelper from './CredentialDatabaseHelper'
import URLCredentialDao from './URLCredentialDao'
import URLProtectionSpaceDao from './URLProtectionSpaceDao'
import common from '@ohos.app.ability.common';

const TAG = "CredentialDatabase"
const DATABASE_NAME = "CredentialDatabase.db"

export default class CredentialDatabase {

  private static instance: CredentialDatabase = new CredentialDatabase(null, null, null)
  public static DATABASE_VERSION: number = 2

  public protectionSpaceDao: URLProtectionSpaceDao | null
  public credentialDao: URLCredentialDao | null
  public db: CredentialDatabaseHelper | null

  constructor(db: CredentialDatabaseHelper | null, protectionSpaceDao: URLProtectionSpaceDao | null, credentialDao: URLCredentialDao | null) {
    this.db = db
    this.credentialDao = credentialDao
    this.protectionSpaceDao = protectionSpaceDao
  }

  public static getInstance(context: common.Context): CredentialDatabase {
    if(CredentialDatabase.instance != null)
      return CredentialDatabase.instance
    let db: CredentialDatabaseHelper = new CredentialDatabaseHelper(context)
    CredentialDatabase.instance = new CredentialDatabase(db, new URLProtectionSpaceDao(db), new URLCredentialDao(db))
    return CredentialDatabase.instance
  }

}