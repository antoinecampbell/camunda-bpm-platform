/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.camunda.bpm.connect.soap.httpclient;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.InputStreamEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.camunda.bpm.connect.impl.AbstractConnector;

import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.Map;
import java.util.Map.Entry;

/**
 * @author Daniel Meyer
 *
 */
public class SoapHttpConnector extends AbstractConnector<SoapHttpRequest, SoapHttpResponse> {

  private static final SoapHttpConnectorLogger LOG = SoapHttpLogger.SOAP_CONNECTOR_LOGGER;

  public static final String ID = "soap-http-connector";

  protected CloseableHttpClient httpClient;

  public SoapHttpConnector() {
    httpClient = createClient();
  }

  public String getId() {
    return ID;
  }

  // lifecycle and configuration //////////////////////////////

  protected CloseableHttpClient createClient() {
    return HttpClients.createDefault();
  }

  // request handling ////////////////////////////////////////

  public SoapHttpRequest createRequest() {
    return new SoapHttpRequest(this);
  }

  public SoapHttpResponse execute(SoapHttpRequest soapHttpRequest) {

    // create the http post
    HttpPost httpPost = createHttpPost(soapHttpRequest);

    try {

      HttpRequestInvocation invocation = new HttpRequestInvocation(httpPost, soapHttpRequest, requestInterceptors, httpClient);

      // route request through interceptor chain
      return new SoapHttpResponse((CloseableHttpResponse) invocation.proceed());

    } catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }

  /**
   * Transforms the {@link SoapHttpRequest} into a {@link HttpPost} object which can be executed by the HttpClient.
   *
   * @param soapHttpRequest the request object to transform
   * @return the HttpPost object
   */
  protected HttpPost createHttpPost(SoapHttpRequest soapHttpRequest) {

    // handle endpoint
    String endpointUrl = soapHttpRequest.getEndpointUrl();
    if(endpointUrl == null || endpointUrl.isEmpty()) {
      throw LOG.invalidRequestParameter(SoapHttpRequest.PARAM_NAME_ENDPOINT_URL, "param must be set");
    }
    HttpPost httpPost = new HttpPost(soapHttpRequest.getEndpointUrl());

    // handle headers
    Map<String, String> headers = soapHttpRequest.getHeaders();
    if(headers != null) {
      for (Entry<String, String> entry : headers.entrySet()) {
        httpPost.setHeader(entry.getKey(), entry.getValue());
        LOG.setHeader(entry.getKey(), entry.getValue());
      }
    }

    // handle payload
    String soapEnvelope = soapHttpRequest.getSoapEnvelope();
    if(soapEnvelope == null || soapEnvelope.isEmpty()) {
      throw LOG.invalidRequestParameter(SoapHttpRequest.PARAM_NAME_SOAP_ENVELOPE, "param must be set");
    }
    ByteArrayInputStream envelopeStream = new ByteArrayInputStream(soapEnvelope.getBytes(Charset.forName("utf-8")));
    httpPost.setEntity(new InputStreamEntity(envelopeStream));

    return httpPost;
  }

}
