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

import cert from '@ohos.security.cert';
import { Any } from '@ohos/flutter_ohos';

export default class SslCertificateExt {
  constructor() {}

  public static toMap(X509Cert: Array<cert.X509Cert> | null): Map<string, Any> | null{
    if(X509Cert == null) {
      return null
    }

    let sslCertificateMap: Map<string, Any> = new Map<string, Any>();

    for (let i = 0; i < X509Cert.length; i++) {
      let x509CertificateData = X509Cert[i].getEncoded()

      let validNotAfterDate: string = X509Cert[i].getNotAfterTime()
      let validNotBeforeDate: string = X509Cert[i].getNotBeforeTime()

      sslCertificateMap.set("issuedBy", Uint8ArrayToString(X509Cert[i].getIssuerName().data));
      sslCertificateMap.set("issuedTo", Uint8ArrayToString(X509Cert[i].getSubjectName().data));
      sslCertificateMap.set("validNotAfterDate", validNotAfterDate);
      sslCertificateMap.set("validNotBeforeDate", validNotBeforeDate);
      sslCertificateMap.set("x509Certificate", x509CertificateData);
    }


    return sslCertificateMap;
  }
}

function Uint8ArrayToString(dataArray:Uint8Array) {
  let dataString = ''
  for (let i = 0; i < dataArray.length; i++) {
    dataString += String.fromCharCode(dataArray[i])
  }
  return dataString
}