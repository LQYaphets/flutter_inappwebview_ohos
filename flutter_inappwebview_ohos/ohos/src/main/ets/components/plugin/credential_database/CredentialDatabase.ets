/*
* Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

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