import CredentialDatabaseHelper from './CredentialDatabaseHelper';

export default class URLProtectionSpaceDao {

  credentialDatabaseHelper: CredentialDatabaseHelper

  constructor(credentialDatabaseHelper: CredentialDatabaseHelper) {
    this.credentialDatabaseHelper = credentialDatabaseHelper
  }
}