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

export default class SslCertificate {
  private static ISO_8601_DATE_FORMAT: string = "yyyy-MM-dd HH:mm:ssZ"
  private mIssuedTo: DName
  private mIssuedBy: DName
  private mValidNotBefore: Date | null
  private mValidNotAfter: Date | null

  constructor(issuedTo: string, issuedBy: string, validNotBefore: Date, validNotAfter: Date) {
    this.mIssuedTo = new DName(issuedTo);
    this.mIssuedBy = new DName(issuedBy);
    this.mValidNotBefore = this.cloneDate(validNotBefore);
    this.mValidNotAfter  = this.cloneDate(validNotAfter);
  }

  private cloneDate(date: Date): Date | null {
    if (date == null) {
      return null;
    }
    return date;
  }
}

export class DName {
  private mDName: string | null = null
  private mCName: string | null = null
  private mOName: string | null = null
  private mUName: string | null = null

  constructor(dName: string) {
    if(dName != null) {
      this.mDName = dName;
    }
  }

  public getDName(): string {
    return this.mDName != null ? this.mDName : "";
  }

  public getCName(): string {
    return this.mCName != null ? this.mCName : "";
  }

  public getOName(): string {
    return this.mOName != null ? this.mOName : "";
  }

  public getUName(): string {
    return this.mUName != null ? this.mUName : "";
  }
}