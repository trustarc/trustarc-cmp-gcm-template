___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "TrustArc CMP (Consent Mode)",
  "categories": ["UTILITY"],
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "TrustArc CMP communicates consent choices to Google using Consent Mode as an alternate to blocking tags and improving Analytics or Advertising tracking while adhering to regulations like the GDPR.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "consentTypes",
    "displayName": "Consent Types",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "adPersonalizationId",
        "displayName": "ad_personalization",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "adStorageId",
        "displayName": "ad_storage",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "adUserDataId",
        "displayName": "ad_user_data",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "analyticsStorageId",
        "displayName": "analytics_storage",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "functionalityStorageId",
        "displayName": "functionality_storage",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "personalizationStorageId",
        "displayName": "personalization_storage",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "securityStorageId",
        "displayName": "security_storage",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "settings",
    "displayName": "Settings",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableAdsRedacted",
        "checkboxText": "Redact Ads data",
        "simpleValueType": true
      },
      {
        "type": "CHECKBOX",
        "name": "enableUrlPassthrough",
        "checkboxText": "Enable URL Passthrough",
        "simpleValueType": true
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "prefCookie",
    "displayName": "Preferences Cookie",
    "macrosInSelect": true,
    "selectItems": [],
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "behaviorCookie",
    "displayName": "Behavior Cookie",
    "macrosInSelect": true,
    "selectItems": [],
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// required funcs
const log = require('logToConsole');
const setDefaultConsentState = require('setDefaultConsentState');
const gtagSet = require('gtagSet');

const ConsentType = {
    DENIED: 'denied',
    GRANTED: 'granted'
};

let adStorage, analyticsStorage, adPersonalization, adUserData, functionalityStorage, personalizationStorage, securityStorage;

adStorage = analyticsStorage = adPersonalization = adUserData = functionalityStorage = personalizationStorage = securityStorage = false;

gtagSet({
  'developer_id.dNTIxZG': true,
  'ads_data_redaction': data.enableAdsRedacted,
  'url_passthrough': data.enableUrlPassthrough
});
log("ads_data_redaction: " + data.enableAdsRedacted);
log("url_passthrough: " + data.enableUrlPassthrough);
log("prefCookie: " + data.prefCookie);


// no existing consent
if (!data.prefCookie) {
  log("behaviorCookie: " + data.behaviorCookie);
  // us: grant by default, eu: deny by default
  if (data.behaviorCookie && data.behaviorCookie.indexOf('us') > -1) {
    adStorage = analyticsStorage = adPersonalization = adUserData = functionalityStorage =                 personalizationStorage = securityStorage = true;
  }
} else { // has existing consent, fetch via mapped
  log("adPersonalizationId: " + data.adPersonalizationId);
  if (data.adPersonalizationId > -1) {
    adPersonalization = data.prefCookie.indexOf(data.adPersonalizationId) > -1;
  }
  log("adStorageId: " + data.adStorageId);
  if (data.adStorageId > -1) {
    adStorage = data.prefCookie.indexOf(data.adStorageId) > -1;
  }
  log("adUserDataId: " + data.adUserDataId);
  if (data.adUserDataId > -1) {
    adUserData = data.prefCookie.indexOf(data.adUserDataId) > -1;
  }
  log("analyticsStorageId: " + data.analyticsStorageId);
  if (data.analyticsStorageId > -1) {
    analyticsStorage = data.prefCookie.indexOf(data.analyticsStorageId) > -1;
  }
  log("functionalityStorageId: " + data.functionalityStorageId);
  if (data.functionalityStorageId > -1) {
    functionalityStorage = data.prefCookie.indexOf(data.functionalityStorageId) > -1;
  }
  log("personalizationStorageId: " + data.personalizationStorageId);
  if (data.personalizationStorageId > -1) {
    personalizationStorage = data.prefCookie.indexOf(data.personalizationStorageId) > -1;
  }
  log("securityStorageId: " + data.securityStorageId);
  if (data.securityStorageId > -1) {
    securityStorage = data.prefCookie.indexOf(data.securityStorageId) > -1;
  }
}


setDefaultConsentState({
    'ad_personalization': adPersonalization ? ConsentType.GRANTED : ConsentType.DENIED,
    'ad_storage': adStorage ? ConsentType.GRANTED : ConsentType.DENIED,
    'ad_user_data': adUserData ? ConsentType.GRANTED : ConsentType.DENIED,
    'analytics_storage': analyticsStorage ? ConsentType.GRANTED : ConsentType.DENIED,
    'functionality_storage': functionalityStorage ? ConsentType.GRANTED : ConsentType.DENIED,
    'personalization_storage': personalizationStorage ? ConsentType.GRANTED : ConsentType.DENIED,
    'security_storage': securityStorage ? ConsentType.GRANTED : ConsentType.DENIED,
    'wait_for_update': 500
});


// Call data.gtmOnSuccess when the tag is finished.
data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "functionality_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "security_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_personalization"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "write_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "developer_id.dNTIxZG"
              },
              {
                "type": 1,
                "string": "ads_data_redaction"
              },
              {
                "type": 1,
                "string": "url_passthrough"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 12/14/2023, 1:59:16 PM


