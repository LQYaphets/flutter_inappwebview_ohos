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
    return URLCredentials
  }
}