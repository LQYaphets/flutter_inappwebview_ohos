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

import SslCertificate from './SslCertificate'

export default class SslError {
  public static SSL_NOTYETVALID: number = 0
  public static SSL_EXPIRED: number = 1
  public static SSL_IDMISMATCH: number = 2
  public static SSL_UNTRUSTED: number = 3
  public static SSL_DATE_INVALID: number = 4
  public static SSL_INVALID: number = 5

  public static SSL_MAX_ERROR: number = 6

  mErrors: number

  mCertificate: SslCertificate

  mUrl: string

  constructor(error: number, certificate: SslCertificate, url: string) {
    // if(certificate == null) return
    // if(url == null) return
    this.addError(error)
    this.mErrors = error
    this.mCertificate = certificate;
    this.mUrl = url;
  }

  public addError(error: number): boolean {
    let rval: boolean = (0 <= error && error < SslError.SSL_MAX_ERROR);
    if (rval) {
      this.mErrors |= (0x1 << error);
    }

    return rval;
  }

}